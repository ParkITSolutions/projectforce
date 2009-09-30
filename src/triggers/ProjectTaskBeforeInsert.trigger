trigger ProjectTaskBeforeInsert on ProjectTask__c (before insert) {
    
    if (!ProjectUtil.currentlyExeTrigger) {
    	ProjectUtil.currentlyExeTrigger = true;
		try {
					
		 	List<Id> tasksInTrrNewIds = new List<Id>();
			List<String> projectSharingGroupNames = new List<String>();		
			
			ProjectTaskDuration duration = new ProjectTaskDuration(Trigger.new.get(0));
			ParentTask parent = new ParentTask();
			BigListOfTasks bigListOfTasks = new BigListOfTasks(Trigger.new.get(0).Project__c); 
			
			for(ProjectTask__c p : Trigger.new) {
		 		tasksInTrrNewIds.add( p.ParentTask__c );
				projectSharingGroupNames.add('Project' + p.Project__c);	
			}
			 
			Map<String, Id> projectMap = new Map<String, Id>();			
			for(Group g: [select Id, name from Group where Name in: projectSharingGroupNames]) {
				projectMap.put(g.Name, g.Id);
			}
 			
 			/* Code commented Deprecated code, if nothing breaks to be erased
 			List<ProjectTask__c> parentTasks = new List<ProjectTask__c>();			
 			parentTasks = [ select id, Project__c from ProjectTask__c where id in: tasksInTrrNewIds limit 1000];
			
		    ProjectTask__c tempPTNew = new ProjectTask__c();
		    for( Integer k = 0; k < Trigger.new.size(); k++ ){
		    	tempPTNew = Trigger.new.get( k );
	
				if( parentTasks.size() > 0 )
			    	if( tempPTNew.Project__c != parentTasks.get( k ).Project__c )
			    		tempPTNew.addError( 'Invalid parent task value.');
		    }
		    */
		    
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
				
				if(parent.validateParentTaskInsert(nTask) == false){
					nTask.ParentTask__c.addError('Parent Task cannot be a  milestone');
				}
				
				String queueId = projectMap.get('Project' + nTask.Project__c);
				if(queueId != null)
                    nTask.OwnerId = queueId;
                
                //if all validations passed
                if(triggerValidation){
                	nTask = duration.calculateTaskInsert(nTask);
                	nTask.Indent__c = parent.setTaskIndent(nTask);                	
                }
		    }
		}
		finally{
			ProjectUtil.currentlyExeTrigger = false;
		}
    }
}