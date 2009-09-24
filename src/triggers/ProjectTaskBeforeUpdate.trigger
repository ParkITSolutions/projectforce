trigger ProjectTaskBeforeUpdate on ProjectTask__c (before update) {
	Map<String,ProjectTask__c> AuxMap = new Map<String,ProjectTask__c>();
	ProjectTaskDuration duration = new ProjectTaskDuration();
	Map<Id, Project2__c> projectMap = new Map<Id, Project2__c>();
	
	/*
	TaskDependencies tD = new TaskDependencies();
	Integer count;
	for( count = 0; count < Trigger.new.size(); count++ ){
		if(ProjectUtil.getTaskDependenciesFlag()){
			tD.setProps( Trigger.old[count].Project__c );
			tD.modifyStartOrEndDate( Trigger.old[count], Trigger.new[count]);
		}
	}
	*/

	if( ProjectUtil.getTaskDependenciesFlag()){
		TaskDependencies td = new TaskDependencies();
		Integer cc = 0;
		for(ProjectTask__c p :  Trigger.new  ){
			td.movingTask( Trigger.old.get(cc), p);
			cc++;
		}	
		td.updateNow();
	} 
	
	Project2__c project1;
	Project2__c project;
	for( Project2__c p :[select Id, DisplayDuration__c, WorkingHours__c, DaysInWorkWeek__c from Project2__c limit 1000])
		projectMap.put( p.Id, p );
	
	ParentTask parent = new ParentTask(); 
	BigListOfTasks bigListOfTasks = new BigListOfTasks(Trigger.new.get(0).Project__c);
	
 	for( ProjectTask__c task : Trigger.new){
 		
 		if(task.Milestone__c){
 			project1 = projectMap.get(task.Project__c);
			duration.verifyStartDate(task, project1);
			task.EndDate__c = null;
			task.DurationUI__c = '1.0';
			task.Duration__c = 1.0; 
 		}
    }
	
			
    ProjectTask__c tempPTOld = new ProjectTask__c();
    ProjectTask__c tempPTNew = new ProjectTask__c();
    for( Integer k = 0; k < Trigger.old.size(); k++ ){
    	
    	tempPTOld = Trigger.old.get( k );
    	tempPTNew = Trigger.new.get( k );	
    	
    	project = projectMap.get(tempPTNew.Project__c);
		
		if( tempPTNew.StartDate__c > tempPTNew.EndDate__c ){
			tempPTNew.StartDate__c.addError('Start date should not be greater than End Date');
			tempPTNew.EndDate__c.addError('End date should not be smaller than Start Date');
		}
		else{
		//TODO not working validation for parentTask children always zero
		List<ProjectTask__c> childTasks = new List<ProjectTask__c>();
		List<ProjectTask__c> allChildTasks = new List<ProjectTask__c>();
		ProjectTask__c tskk = parent.getParentTask(tempPTNew);
		allChildTasks = ParentTask.getTaskChildren(tskk, tempPTNew);
		for(ProjectTask__c task : allChildTasks ){
			if(task.ParentTask__c == tempPTNew.Id){
				childTasks.add(task);
			}
		}
		
		System.debug('-------------CHILDREN ::' +childTasks.size() );
		System.debug(childTasks);
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
				if(tempPTOld.Milestone__c != tempPTNew.Milestone__c){
					tempPTNew.Milestone__c.addError( 'You cant change a Parent Task into a Milestone');
				}
				
				if(tempPTOld.ParentTask__c != tempPTNew.ParentTask__c){
					parent.checkParentTaskRedundancy(tempPTNew, tempPTNew.ParentTask__c);
					if( !parent.validParentTask ){
						tempPTNew.ParentTask__c.addError('Parent Task cannot be a descendant child or milestone');
					}
				}
			}
		}
		else{
		
    	duration.verifyStartDate(tempPTNew, project);
    	
		if(!tempPTNew.Milestone__c){
			//TODO move validation to duration Class
			String regex = tempPTNew.DurationUI__c;
			regex = regex.replaceAll('\\d[0-9]*[\\\\.\\d{0,2}]?[h,d,H,D]?','');
			if(regex != ''){
				tempPTNew.DurationUI__c.addError('Invalid format for Hours / Days convention!');
			}
			else{
				duration.verifyStartDate(tempPTNew, project);
				duration.verifyEndDate(tempPTNew, project);
				
		    	//Recalculate Duration when EndDate or StartDate was changed
		    	if(tempPTNew.EndDate__c != null && tempPTOld.EndDate__c != null){
		    		if(tempPTOld.EndDate__c != tempPTNew.EndDate__c || tempPTOld.StartDate__c != tempPTNew.StartDate__c){
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
			
	   	 	AuxMap.put( tempPTOld.id, tempPTOld ); 
			
			if( tempPTNew.ParentTask__c != null && tempPTOld.ParentTask__c == tempPTNew.ParentTask__c){ 
				if(ProjectUtil.getFlagValidationParentTask()){
					ParentTask.updateParentTasks(tempPTNew.id);
				}
			}
			if(ProjectUtil.getParentTaskUpdateIndent()){
				tempPTNew.Indent__c = parent.setTaskIndent(tempPTNew);
			}
	  }	
    }
    } 
    ProjectUtil.BaseMap=AuxMap;  
}