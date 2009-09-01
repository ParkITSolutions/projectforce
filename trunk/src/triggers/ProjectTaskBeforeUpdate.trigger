trigger ProjectTaskBeforeUpdate on ProjectTask__c (before update) {
	
	Map<String,ProjectTask__c> AuxMap = new Map<String,ProjectTask__c>();
 	List<Id> tasksInTrrNewIds = new List<Id>();
	List<ProjectTask__c> parentTasks = new List<ProjectTask__c>();
	
	//Task duration util class
	ProjectTaskDuration duration = new ProjectTaskDuration();

	for( ProjectTask__c task : Trigger.new){
 		
 		tasksInTrrNewIds.add(task.ParentTask__c );
 		
 		if(task.Milestone__c){
 			Project2__c project1 = [select Id, DisplayDuration__c, WorkingHours__c, DaysInWorkWeek__c 
									from Project2__c 
									where Id =: task.Project__c];
									
			duration.verifyStartDate(task, project1);
			
 			if(task.EndDate__c != null)
				task.EndDate__c.addError('The Milestones can not have End Date.');

 			if(task.ParentTask__c != null)
				task.ParentTask__c.addError('The Milestones can not have Parent Task.');
				
			task.EndDate__c = task.StartDate__c;
 		}
    }

	parentTasks = [ select id, Project__c from ProjectTask__c where id in: tasksInTrrNewIds];
	
    ProjectTask__c tempPTOld = new ProjectTask__c();
    ProjectTask__c tempPTNew = new ProjectTask__c();
    for( Integer k = 0; k < Trigger.old.size(); k++ ){
    	
    	tempPTOld = Trigger.old.get( k );
    	tempPTNew = Trigger.new.get( k );	
    	
    	Project2__c project = [select Id, DisplayDuration__c, WorkingHours__c, DaysInWorkWeek__c 
									from Project2__c 
									where Id =: tempPTNew.Project__c];
									
    	duration.verifyStartDate(tempPTNew, project);
    	
		if(!tempPTNew.Milestone__c){
			String regex = tempPTNew.DurationUI__c;
			regex = regex.replaceAll('\\d[0-9]*[\\\\.\\d{0,2}]?[h,d,H,D]?','');
			if(regex != ''){
				tempPTNew.DurationUI__c.addError('Invalid format for Hours / Days convention!');
			}
			else{
				duration.verifyStartDate(tempPTNew, project);
				duration.verifyEndDate(tempPTNew, project);
				
				//TODO branch code to pemit changes only on Start date and End date seperatly 														
		    	//Recalculate Duration when EndDate or StartDate was changed
		    	if(tempPTOld.EndDate__c != tempPTNew.EndDate__c || tempPTOld.StartDate__c != tempPTNew.StartDate__c){
		 			tempPTNew = duration.doCalculateDuration(tempPTNew);
		    	}
		    	
			   	//Recalculate EndDate when Duration was changed
		    	if(tempPTOld.DurationUI__c != tempPTNew.DurationUI__c){
		 			tempPTNew = duration.parseDuration(tempPTNew);
		 			if(project.DisplayDuration__c.equals('Days')){
						tempPTNew.EndDate__c = duration.doCalculateEndDateInDays(tempPTNew, Integer.valueOf(project.DaysInWorkWeek__c));
					}
					else{
						tempPTNew.EndDate__c = duration.doCalculateEndDateInHours(tempPTNew, project);
					}	
		    	}
			}
		}
		
		   	if( tempPTOld.Project__c != tempPTNew.Project__c){
	    		tempPTNew.addError( 'You can not modify project.');
			}
			
			if( parentTasks.size() > 0 ){
		    	if(tempPTOld.Project__c != parentTasks.get(k).Project__c ){
		    		tempPTNew.addError( 'Invalid parent task value.');
		    	}
		    	
			}
			
	   	 	AuxMap.put( tempPTOld.id, tempPTOld );
		
    } 
    ProjectUtil.BaseMap=AuxMap;    
}