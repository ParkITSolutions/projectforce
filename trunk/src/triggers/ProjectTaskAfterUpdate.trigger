trigger ProjectTaskAfterUpdate on ProjectTask__c (after update) 
{
	// Send email to subscribers members
	ProjectSubscribersEmailServices pEmail = new ProjectSubscribersEmailServices();
	ProjectSubscribersEmailServices pEmail2 = new ProjectSubscribersEmailServices();
	TaskDependencies td = new TaskDependencies(Trigger.new[0].project__c);
	
	List<String> lstPTId = new List<String>();
    ParentTask parent = new ParentTask(); 
  	
    ProjectTask__c tempPTOld = new ProjectTask__c();
    ProjectTask__c tempPTNew = new ProjectTask__c();
    
    for( Integer k = 0; k < Trigger.old.size(); k++ ){
    	
    	tempPTOld = Trigger.old.get( k );
    	tempPTNew = Trigger.new.get( k );
    		
    	if(tempPTOld.PercentCompleted__c != tempPTNew.PercentCompleted__c){
    		lstPTId.add(tempPTNew.Id);
    	}
    	
    
	    //If parentTask changed Recalculate all Parents
	    if(tempPTOld.ParentTask__c != tempPTNew.ParentTask__c){

			
			ProjectTask__c tsk = parent.getParentTask(tempPTNew);
			td.delAllRelsFromMe( tsk ); 
			//updating parents
			ParentTask.updateParentTasks(tempPTNew.Id);
			
			//Reset big list with new taskList
			BigListOfTasks bigListOfTasks = new BigListOfTasks(tempPTNew.Project__c);
			
			//updates all childs Indent Value
			parent.updateAllChildrensIndent(tsk);
			//sets flags and updates the list of modified tasks
			ProjectUtil.setFlagValidationParentTask(false);
			//ProjectUtil.setParentTaskUpdateIndent(false);
			ProjectUtil.setTaskDependenciesFlag( false );
				update parent.indentUpdateTasks.values(); 
			//ProjectUtil.setParentTaskUpdateIndent(true);
			ProjectUtil.setTaskDependenciesFlag( true );
			ProjectUtil.setFlagValidationParentTask(true);
			
	    }
    }
    
    pEmail.sendMailForTaskChanged( lstPTId );
    
    if(lstPTId.size() > 0){
    	pEmail2.sendMailForTaskPercentChanged( lstPTId );
    }
}