trigger ProjectTaskBeforeUpdate on ProjectTask__c (before update) {
	
	Map<String,ProjectTask__c> AuxMap = new Map<String,ProjectTask__c>();
	ProjectTaskDuration duration = new ProjectTaskDuration(Trigger.new.get(0));
	ParentTask parent = new ParentTask(); 
	BigListOfTasks bigListOfTasks = new BigListOfTasks(Trigger.new.get(0).Project__c);
		
    ProjectTask__c tempPTOld = new ProjectTask__c();
    ProjectTask__c tempPTNew = new ProjectTask__c();
    
    for( Integer k = 0; k < Trigger.old.size(); k++ ){
    	
    	Boolean triggerValidation = true;
    	tempPTOld = Trigger.old.get( k );
    	tempPTNew = Trigger.new.get( k );	
    	
    	if( tempPTOld.Project__c != tempPTNew.Project__c){
	    		tempPTNew.Project__c.addError( 'You can not modify project.');
	    		triggerValidation = triggerValidation && false;
		}
			
		if( tempPTNew.StartDate__c > tempPTNew.EndDate__c ){
			tempPTNew.StartDate__c.addError('Start date should not be greater than End Date');
			tempPTNew.EndDate__c.addError('End date should not be smaller than Start Date');
			triggerValidation = triggerValidation && false;
		}
		
		//duration validation
		if(duration.validateDurationInput(tempPTNew) == false){
			tempPTNew.DurationUI__c.addError('Invalid format for Hours / Days convention!');
			triggerValidation = triggerValidation && false;
		}
		
		//If task is a parent task ONLY execute these validations
		if(parent.taskHasChildren(tempPTNew) && ProjectUtil.getFlagValidationParentTask()){
			if(ProjectUtil.getFlagValidationParentTask()){
				if(tempPTOld.StartDate__c != tempPTNew.StartDate__c){
					tempPTNew.StartDate__c.addError( 'You cant modify Parent Tasks Start Date');
					triggerValidation = triggerValidation && false;
				}
				if(tempPTOld.EndDate__c != tempPTNew.EndDate__c){
					tempPTNew.EndDate__c.addError( 'You cant modify Parent Tasks End Date');
					triggerValidation = triggerValidation && false;
				}
				if(tempPTOld.DurationUI__c != tempPTNew.DurationUI__c){
					tempPTNew.DurationUI__c.addError( 'You cant modify Parent Tasks Duration');
					triggerValidation = triggerValidation && false;
				}
				if(tempPTOld.PercentCompleted__c != tempPTNew.PercentCompleted__c){
					tempPTNew.PercentCompleted__c.addError( 'You cant modify Parent Tasks Percentage value');
					triggerValidation = triggerValidation && false;
				}
				if(tempPTOld.Milestone__c != tempPTNew.Milestone__c){
					tempPTNew.Milestone__c.addError( 'You cant change a Parent Task into a Milestone');
					triggerValidation = triggerValidation && false;
				} 
				
				if( tempPTOld.ParentTask__c != tempPTNew.ParentTask__c ){
					parent.checkParentTaskRedundancy(tempPTNew, tempPTNew.ParentTask__c);
					if( !parent.validParentTask ){
						tempPTNew.ParentTask__c.addError('Parent Task cannot be a descendant child');
						triggerValidation = triggerValidation && false;
					}
				}
			}
		}
		
		//if all validations passed
		if(triggerValidation){

			tempPTNew = duration.calculateTaskUpdate(tempPTOld, tempPTNew);
			parent.parentTaskUpdate(tempPTOld, tempPTNew);
			
			if( ProjectUtil.getTaskDependenciesFlag()){
				TaskDependencies td = new TaskDependencies(Trigger.new[0].project__c);
				Integer cc = 0;
				for(ProjectTask__c p :  Trigger.new  ){
					td.movingTask( Trigger.old.get(cc), p);
					cc++;
				}	
				td.updateNow();
			} 
			
		}
		AuxMap.put( tempPTOld.id, tempPTOld ); 
    }
     
    ProjectUtil.BaseMap=AuxMap;  
}