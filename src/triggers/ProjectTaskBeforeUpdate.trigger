trigger ProjectTaskBeforeUpdate on ProjectTask__c (before update) {
	
	Map<String,ProjectTask__c> AuxMap = new Map<String,ProjectTask__c>();
 	List<Id> tasksInTrrNewIds = new List<Id>();
	List<ProjectTask__c> parentTasks = new List<ProjectTask__c>();
	 
	//Task duration util class 
	ProjectTaskDuration duration = new ProjectTaskDuration();
	List<String> listIds = new List<String>(); 
	Map<Id, Project2__c> projectMap = new Map<Id, Project2__c>();
	
	Project2__c project1;
	Project2__c project;
	for( Project2__c p :[select Id, DisplayDuration__c, WorkingHours__c, DaysInWorkWeek__c from Project2__c ])
		projectMap.put( p.Id, p );
	
	for( ProjectTask__c task : Trigger.new){
 		listIds.add( task.id );
 		tasksInTrrNewIds.add(task.ParentTask__c );
	}
	
	parentTasks = [ select id, Project__c from ProjectTask__c where id in: tasksInTrrNewIds];
	List<ProjectTask__c> allChildTasks = new List<ProjectTask__c>();
	allChildTasks = [select Id , ParentTask__c from ProjectTask__c where ParentTask__c in: listIds];
	
 	for( ProjectTask__c task : Trigger.new){
 		
 		listIds.add( task.id );
 		tasksInTrrNewIds.add(task.ParentTask__c );
 		
 		if(task.Milestone__c){
 			project1 = projectMap.get(task.Project__c);
									
			duration.verifyStartDate(task, project1);
			
 			if(task.EndDate__c != null)
				task.EndDate__c.addError('The Milestones can not have End Date.');
			//TODO remove Milestone will allow having Parent tasks
 			if(task.ParentTask__c != null)
				task.ParentTask__c.addError('The Milestones can not have Parent Task.');
				
 		}
    }
	
	ParentTask parent = new ParentTask(); 
	parent.setProjectId(Trigger.old.get(0).Project__c);
			
    ProjectTask__c tempPTOld = new ProjectTask__c();
    ProjectTask__c tempPTNew = new ProjectTask__c();
    for( Integer k = 0; k < Trigger.old.size(); k++ ){
    	
    	tempPTOld = Trigger.old.get( k );
    	tempPTNew = Trigger.new.get( k );	
    	
    	project = projectMap.get(tempPTNew.Project__c);
		
		List<ProjectTask__c> childTasks = new List<ProjectTask__c>();
		for(ProjectTask__c task : allChildTasks ){
			if(task.ParentTask__c == tempPTNew.Id){
				childTasks.add(task);
			}
		}
		System.debug('&&&&&&&&&&&&&&&&&&&&&&&&&&  chidl task size :'+childTasks.size()+ '  ' + ProjectUtil.getFlagValidationParentTask());
		if(childTasks.size() > 0 && ProjectUtil.getFlagValidationParentTask()){
			if(ProjectUtil.getFlagValidationParentTask()){
				if(tempPTOld.StartDate__c != tempPTNew.StartDate__c){
					tempPTNew.StartDate__c.addError( 'You cant modify Parent Tasks Start Date');
				}
				if(tempPTOld.EndDate__c != tempPTNew.EndDate__c){
					tempPTNew.EndDate__c.addError( 'You cant modify Parent Tasks End Date');
				}
				if(tempPTOld.DurationUI__c != tempPTNew.DurationUI__c){
					tempPTNew.DurationUI__c.addError( 'You cant modify Parent Tasks Duration');
				}
				if(tempPTOld.PercentCompleted__c != tempPTNew.PercentCompleted__c){
					tempPTNew.PercentCompleted__c.addError( 'You cant modify Parent Tasks Percentage value');
				}
			}
		}
		else{
		
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
				
				//TODO branch code to permit changes only on Start date and End date seperatly 														
		    	//Recalculate Duration when EndDate or StartDate was changed
		    	if(tempPTNew.EndDate__c != null){
		    		if(tempPTOld.EndDate__c != tempPTNew.EndDate__c || tempPTOld.StartDate__c != tempPTNew.StartDate__c){
		 				System.debug('Entro para recalcular su duration');
		 				tempPTNew = duration.doCalculateDuration(tempPTNew);
		    		}
		    	}
		    	
			   	//Recalculate EndDate when Duration was changed
		    	if(tempPTOld.DurationUI__c != tempPTNew.DurationUI__c || tempPTNew.EndDate__c == null){
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
	    		tempPTNew.Project__c.addError( 'You can not modify project.');
			}
			
			if( parentTasks.size() > 0 ){
		    	//if(tempPTOld.Project__c != parentTasks.get(k).Project__c ){
		    		//tempPTNew.addError( 'Invalid parent task value.');
		    	//}
		    	
			}
	   	 	AuxMap.put( tempPTOld.id, tempPTOld ); 
			
			//ParentTask parent = new ParentTask(); 
			//parent.setProjectId(tempPTNew.Project__c);
			System.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ task ID: '+tempPTNew.Id +'  tamano:   '+childTasks.size());
			//if(childTasks.size() == 0){
				System.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ ENTRO CHECK 1');
				if( tempPTNew.ParentTask__c != null ){ 
					//if(tempPTOld.EndDate__c != tempPTNew.EndDate__c || tempPTOld.StartDate__c != tempPTNew.StartDate__c ||
					//tempPTOld.DurationUI__c != tempPTNew.DurationUI__c ||
					//tempPTOld.PercentCompleted__c != tempPTNew.PercentCompleted__c ||
					//tempPTOld.ParentTask__c != tempPTNew.ParentTask__c){
						if(ProjectUtil.getFlagValidationParentTask()){
							System.debug('UPDATE@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ ENTRO CHECK 2');
							parent.checkParentTask(tempPTNew);
						}
					//}
				}
			//}
			if(ProjectUtil.getParentTaskUpdateIndent()){
				tempPTNew.Indent__c = parent.setTaskIndent(tempPTNew);
				System.debug(' Vaolres de indet al finalizar update : ' + tempPTNew.Id+'   '+tempPTNew.Indent__c);
			}
			
	  }	
	  
    } 
    ProjectUtil.BaseMap=AuxMap;    
}