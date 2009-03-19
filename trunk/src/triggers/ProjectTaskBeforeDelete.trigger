trigger ProjectTaskBeforeDelete on ProjectTask__c (before delete) 
{
	// Send email to subscribers members
	ProjectSubscribersEmailServices pEmail = new ProjectSubscribersEmailServices();
    for ( ProjectTask__c pT : Trigger.old )
    pEmail.sendMailForTaskDeleted( pT.Id );
}