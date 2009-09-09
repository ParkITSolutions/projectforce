trigger ProjectTaskAfterUpdate on ProjectTask__c (after update) 
{
	// Send email to subscribers members
	ProjectSubscribersEmailServices pEmail = new ProjectSubscribersEmailServices();
	List<String> lstPTId = new List<String>();
    
    ParentTask parent = new ParentTask(); 
    System.debug('IDDD de projecto a setear en after update :' + Trigger.old.get(0).Project__c);
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
    
    if(tempPTOld.ParentTask__c != tempPTNew.ParentTask__c){
			ProjectTask__c tsk = parent.getParentTask(tempPTNew);
			System.debug('--------------- Tarea para el checkparent : ' + tsk.Id);
			parent.checkParentTask(tempPTNew);
			
			System.debug('--------------- Tarea para el update children indent : ' + tsk.Id);
			parent.updateAllChildrensIndent(tsk);
			
			ProjectUtil.setFlagValidationParentTask(false);
			ProjectUtil.setParentTaskUpdateIndent(false);
			System.debug('TAmano de MAPA de UPDATE' + parent.indentUpdateTasks.size());
			System.debug(parent.indentUpdateTasks.values());
			update parent.indentUpdateTasks.values(); 
			ProjectUtil.setParentTaskUpdateIndent(true);
			ProjectUtil.setFlagValidationParentTask(true);
    }
    	
    //pEmail.sendMailForTaskChanged( lstPTId );
    //TODO correct trigger too many SOQL
   	ProjectSubscribersEmailServices pEmail2 = new ProjectSubscribersEmailServices();
    
    if(lstPTId.size() > 0){
    	//TODO correct trigger too many SOQL
    	//pEmail2.sendMailForTaskPercentChanged( lstPTId );
    }
    
    
    
}