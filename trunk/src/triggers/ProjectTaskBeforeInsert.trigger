trigger ProjectTaskBeforeInsert on ProjectTask__c (before insert) {
    
    if (!ProjectUtil.currentlyExeTrigger) {
    	ProjectUtil.currentlyExeTrigger = true;
		try {
					
		 	List<Id> tasksInTrrNewIds = new List<Id>();
			List<String> projectSharingGroupNames = new List<String>();		
			
			ProjectTaskDuration duration = new ProjectTaskDuration(Trigger.new.get(0));
			ParentTask parent = new ParentTask();
			BigListOfTasks bigListOfTask = new BigListOfTasks(Trigger.new.get(0).Project__c); 
			
			for(ProjectTask__c p : Trigger.new) {
		 		tasksInTrrNewIds.add( p.ParentTask__c );
				projectSharingGroupNames.add('Project' + p.Project__c);
			}
			 
			Map<String, Id> projectMap = new Map<String, Id>();			
			for(Group g: [select Id, name from Group where Name in: projectSharingGroupNames]) {
				projectMap.put(g.Name, g.Id);
			}
 			
			for(ProjectTask__c nTask : Trigger.new) {
				Boolean triggerValidation = true;
				
			    //Trigger Validation
			    if( nTask.StartDate__c > nTask.EndDate__c ){
			    	nTask.StartDate__c.addError('Start date should not be greater than End Date');
					nTask.EndDate__c.addError('End date should not be smaller than Start Date');
			    	triggerValidation = triggerValidation && false;
				}
				
				//duration validation
				if(duration.validateDurationInput(nTask) == false){
					nTask.DurationUI__c.addError('Invalid format for Hours / Days convention!');
					triggerValidation = triggerValidation && false; 
				}
				
				if(nTask.PercentCompleted__c <> null){
					if(nTask.PercentCompleted__c > Math.floor(nTask.PercentCompleted__c)){
						nTask.PercentCompleted__c.addError('Percent Completed must be an Integer.');
						triggerValidation = triggerValidation && false;
					}
				}
				
				ProjectTask__c prjTsk = new ProjectTask__c();
				if(nTask.ParentTask__c != null){
					prjTsk = BigListOfTasks.getById(nTask.ParentTask__c);
					if(prjTsk == null){
						nTask.ParentTask__c.addError('Parent Task selected does not belong to current project.');
						triggerValidation = triggerValidation && false;
					}
				}
				if(parent.validateParentTaskInsert(nTask) == false){
					nTask.ParentTask__c.addError('Parent Task selected does not belong in current project.');
					triggerValidation = triggerValidation && false;
				}
				
				String queueId = projectMap.get('Project' + nTask.Project__c);
				if(queueId != null)
                    nTask.OwnerId = queueId;
                
                //if all validations passed
                if(triggerValidation){
                	nTask = duration.calculateTaskInsert(nTask);
                	nTask.Indent__c = ParentTask.setTaskIndent(nTask);
                	
                	//Logging Changes for Project Members
                	//TaskActivity taskActivity = new TaskActivity( nTask.Project__c, DateTime.now(), UserInfo.getUserId(), 'insert', nTask );
					//taskActivity.log();                	
                }
		    }
		}
		finally{
			ProjectUtil.currentlyExeTrigger = false;
		}
    }
}