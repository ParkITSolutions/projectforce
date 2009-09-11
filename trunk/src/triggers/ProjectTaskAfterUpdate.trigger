trigger ProjectTaskAfterUpdate on ProjectTask__c (after update) 
{
	// Send email to subscribers members
	ProjectSubscribersEmailServices pEmail = new ProjectSubscribersEmailServices();
	List<String> lstPTId = new List<String>();
    ParentTask parent = new ParentTask(); 
    parent.setProjectId(Trigger.old.get(0).Project__c);
    
    ProjectTask__c tempPTOld = new ProjectTask__c();
    ProjectTask__c tempPTNew = new ProjectTask__c();
    for( Integer k = 0; k < Trigger.old.size(); k++ ){
    	
    	tempPTOld = Trigger.old.get( k );
    	tempPTNew = Trigger.new.get( k );	
    	if(tempPTOld.PercentCompleted__c != tempPTNew.PercentCompleted__c){
    		lstPTId.add(tempPTNew.Id);
    	}
    	
    }
    
    //If parentTask changed Recalculate all Parents
    if(tempPTOld.ParentTask__c != tempPTNew.ParentTask__c){
			ProjectTask__c tsk = parent.getParentTask(tempPTNew);
			//updating parents
			parent.checkParentTask(tempPTNew);
			//updating childs Indent Value
			parent.updateAllChildrensIndent(tsk);
			
			ProjectUtil.setFlagValidationParentTask(false);
			ProjectUtil.setParentTaskUpdateIndent(false);
			update parent.indentUpdateTasks.values(); 
			ProjectUtil.setParentTaskUpdateIndent(true);
			ProjectUtil.setFlagValidationParentTask(true);
    }
   	
   	//TODO correct trigger too many SOQL
    //pEmail.sendMailForTaskChanged( lstPTId );
   	ProjectSubscribersEmailServices pEmail2 = new ProjectSubscribersEmailServices();
    
    if(lstPTId.size() > 0){
    	//TODO correct trigger too many SOQL
    	//pEmail2.sendMailForTaskPercentChanged( lstPTId );
    }
}