trigger ProjectTaskAfterUpdate on ProjectTask__c (after update) 
{
	TaskDependencies td = new TaskDependencies(Trigger.new[0].project__c);
	
	List<String> lstPTId = new List<String>();
	
	List<String> mailingList = new List<String>();
	
	if(Trigger.old.get( 0 ).ParentTask__c == Trigger.new.get( 0 ).ParentTask__c){
		BigListOfTasks bigListOfTask = new BigListOfTasks(Trigger.new.get(0).Project__c);
	}
    ParentTask parent = new ParentTask(); 
  	
    ProjectTask__c tempPTOld = new ProjectTask__c();
    ProjectTask__c tempPTNew = new ProjectTask__c();
    
    for( Integer k = 0; k < Trigger.old.size(); k++ ){
    	
    	tempPTOld = Trigger.old.get( k );
    	tempPTNew = Trigger.new.get( k );
    		
    	if(tempPTOld.PercentCompleted__c != tempPTNew.PercentCompleted__c){
    		lstPTId.add(tempPTNew.Id);
    	}
    	
    	mailingList.add(Trigger.new.get( k ).Id);    	
    
	    //If parentTask changed Recalculate all Parents
	    if(tempPTOld.ParentTask__c != tempPTNew.ParentTask__c){
			ProjectTask__c tsk = ParentTask.getParentTask(tempPTNew).clone();
			if(tsk.Milestone__c == true){
			    tsk.EndDate__c = tsk.StartDate__c;
			    tsk.Milestone__c = false;
			    BigListOfTasks.setById(tsk);
			    ProjectUtil.setFlagValidationParentTask(false);
			    ProjectUtil.setTaskDependenciesFlag(false);
			    ProjectUtil.flags.put('exeParentTaskUpdate', false);
				update tsk;
				ProjectUtil.setFlagValidationParentTask(true);
			}
			
			//ProjectTask__c tsk = parent.getParentTask(tempPTNew); 
			td.delAllRelsFromMe( tsk ); 
			//updating parents
			List<Id> modsIds = new List<Id>();
			List<String> modsStarDate = new List<String>(); 		
			List<String> modsEndDate = new List<String>(); 	
			ParentTask.updateParentTasks(tempPTNew.Id, modsIds, modsStarDate, modsEndDate);
			
			//TODO refactor Child indent
			ParentTask.callUpdateAllChildrenIndent(tempPTNew.Id, tempPTNew.Project__c); 
			
	    }
    }

	ProjectSubscribersEmailServices mail = new ProjectSubscribersEmailServices();
    mail.sendMailForTaskChanged( mailingList );
    
    if(lstPTId.size() > 0){
    	mail.sendMailForTaskPercentChanged( lstPTId );
    }
    
}