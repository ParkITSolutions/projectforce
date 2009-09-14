trigger ProjectTaskBeforeInsert on ProjectTask__c (before insert) {
    if (!ProjectUtil.currentlyExeTrigger) {
    	ProjectUtil.currentlyExeTrigger = true;
		try {		
		 	List<Id> tasksInTrrNewIds = new List<Id>();
			List<ProjectTask__c> parentTasks = new List<ProjectTask__c>();			
			List<String> projectSharingGroupNames = new List<String>();		
			ProjectTaskDuration duration = new ProjectTaskDuration();
			
			for(ProjectTask__c p : Trigger.new) {
		 		tasksInTrrNewIds.add( p.ParentTask__c );
				projectSharingGroupNames.add('Project' + p.Project__c);	
			}
			 
			Map<String, Id> projectMap = new Map<String, Id>();			
			for(Group g: [select Id, name from Group where Name in: projectSharingGroupNames]) {
				projectMap.put(g.Name, g.Id);
			}
 
			for(ProjectTask__c nTask : Trigger.new) {
				if( nTask.StartDate__c > nTask.EndDate__c ){
					nTask.StartDate__c.addError('Start date should not be greater than End Date');
					nTask.EndDate__c.addError('End date should not be smaller than Start Date');		
				}
				String queueId = projectMap.get('Project' + nTask.Project__c);
				if(nTask.Milestone__c){
					Project2__c project1 = [select Id, DisplayDuration__c, WorkingHours__c, DaysInWorkWeek__c 
											from Project2__c 
											where Id =: nTask.Project__c];
					duration.verifyStartDate(nTask, project1);
											
					nTask.DurationUI__c = '1'; 
					nTask.Duration__c = 1.0; 
		 			
		 			if(nTask.EndDate__c != null)
 		 				nTask.EndDate__c.addError( 'The Milestones can not have End Date.');
 		 			 
		 		} 
				if(queueId != null)
                    nTask.OwnerId = queueId;
			}
			 
			parentTasks = [ select id, Project__c from ProjectTask__c where id in: tasksInTrrNewIds limit 1000];
			
		    ProjectTask__c tempPTOld = new ProjectTask__c();
		    ProjectTask__c tempPTNew = new ProjectTask__c();
		    for( Integer k = 0; k < Trigger.new.size(); k++ ){
		    	tempPTNew = Trigger.new.get( k );
	
				if( parentTasks.size() > 0 )
			    	if( tempPTNew.Project__c != parentTasks.get( k ).Project__c )
			    		tempPTNew.addError( 'Invalid parent task value.');

		    } 	
				
			    for( Integer j = 0; j < Trigger.new.size(); j++ ){
			    	tempPTNew = Trigger.new.get( j );		
			 		if(!tempPTNew.Milestone__c){
				 		if(tempPTNew.Project__c != null){
				 			
				 			Project2__c project = [select Id, DisplayDuration__c, WorkingHours__c, DaysInWorkWeek__c 
											from Project2__c 
											where Id =: tempPTNew.Project__c];
							
							//TODO move Validation to Duration Clase
							String regex = tempPTNew.DurationUI__c;
							regex = regex.replaceAll('\\d[0-9]*[\\\\.\\d{0,2}]?[h,d,H,D]?','');
							if(regex != ''){
								tempPTNew.DurationUI__c.addError('Invalid format for Hours / Days convention!');
							}
							else{
							
								duration.verifyStartDate(tempPTNew, project);
								duration.verifyEndDate(tempPTNew, project);
								
					 			if(tempPTNew.EndDate__c == null){
					 				tempPTNew = duration.parseDuration(tempPTNew);
					 				
									if(project.DisplayDuration__c.equals('Days')){
										tempPTNew.EndDate__c = duration.doCalculateEndDateInDays(tempPTNew, Integer.valueOf(project.DaysInWorkWeek__c));
									}
									else{
										tempPTNew.EndDate__c = duration.doCalculateEndDateInHours(tempPTNew, project);
									}	
					 			}
					 			else{
		 							tempPTNew = duration.doCalculateDuration(tempPTNew);
		 							tempPTNew = duration.parseDuration(tempPTNew);
					 			}
							}
		    			}
		    		
			    	}
			    	
			    	ParentTask parent = new ParentTask();
			    	parent.setProjectId(tempPTNew.Project__c);
			    	tempPTNew.Indent__c = parent.setTaskIndent(tempPTNew);
		    }
		}
		finally{
			ProjectUtil.currentlyExeTrigger = false;
		}
    }
}