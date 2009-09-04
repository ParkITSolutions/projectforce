trigger ProjectTaskAfterUpdate on ProjectTask__c (after update) 
{
	// Send email to subscribers members
	ProjectSubscribersEmailServices pEmail = new ProjectSubscribersEmailServices();
	List<String> lstPTId = new List<String>();
    /*for ( ProjectTask__c pT : Trigger.new ){
    	
		lstPTId.add(pT.Id);
		
    }*/
    
    ProjectTask__c tempPTOld = new ProjectTask__c();
    ProjectTask__c tempPTNew = new ProjectTask__c();
    for( Integer k = 0; k < Trigger.old.size(); k++ ){
    	
    	tempPTOld = Trigger.old.get( k );
    	tempPTNew = Trigger.new.get( k );	
    	if(tempPTOld.PercentCompleted__c != tempPTNew.PercentCompleted__c){
    		lstPTId.add(tempPTNew.Id);
    	}
    	
    }
    
    //pEmail.sendMailForTaskChanged( lstPTId );
    //TODO correct trigger too many SOQL
   	//ProjectSubscribersEmailServices pEmail2 = new ProjectSubscribersEmailServices();
    
    if(lstPTId.size() > 0){
    	//TODO correct trigger too many SOQL
    	//pEmail2.sendMailForTaskPercentChanged( lstPTId );
    }
    
    
    
}