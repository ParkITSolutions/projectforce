trigger ProjectTaskAfterUpdate on ProjectTask__c (after update) 
{
	// Send email to subscribers members
	ProjectSubscribersEmailServices pEmail = new ProjectSubscribersEmailServices();
	List<String> lstPTId = new List<String>();
    for ( ProjectTask__c pT : Trigger.new ){
    	lstPTId.add(pT.Id);
    	
    }
    
    pEmail.sendMailForTaskChanged( lstPTId );
   	ProjectSubscribersEmailServices pEmail2 = new ProjectSubscribersEmailServices();
    
    pEmail2.sendMailForTaskPercentChanged( lstPTId );


   
    
}