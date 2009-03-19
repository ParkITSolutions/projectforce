trigger ProjectTaskAfterUpdate on ProjectTask__c (after update) 
{
	// Send email to subscribers members
	ProjectSubscribersEmailServices pEmail = new ProjectSubscribersEmailServices();
    for ( ProjectTask__c pT : Trigger.new )
    pEmail.sendMailForTaskChaged( pT.Id );
}