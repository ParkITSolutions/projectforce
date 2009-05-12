trigger ProjectTaskAfterUpdate on ProjectTask__c (after update) 
{
	// Send email to subscribers members
	ProjectSubscribersEmailServices pEmail = new ProjectSubscribersEmailServices();
	List<String> lstPTId = new List<String>();
    for ( ProjectTask__c pT : Trigger.new ){
    	lstPTId.add(pT.Id);
    	
    }
    
         System.debug('\n\n//////////////////////////\n lstPTId: ' + lstPTId + '\n//////////////////////////\n\n');
    
     System.debug('\n\n//////////////////////////\n INICIO: ' + + '\n//////////////////////////\n\n');
    
    pEmail.sendMailForTaskChanged( lstPTId );
         System.debug('\n\n//////////////////////////\n MEDIO: ' + + '\n//////////////////////////\n\n');
    
    
    	ProjectSubscribersEmailServices pEmail2 = new ProjectSubscribersEmailServices();
    
    pEmail2.sendMailForTaskPercentChanged( lstPTId );
         System.debug('\n\n//////////////////////////\n FINAL: ' + + '\n//////////////////////////\n\n');
    
    
    
    
}