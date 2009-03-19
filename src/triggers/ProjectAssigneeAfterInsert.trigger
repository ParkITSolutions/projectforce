trigger ProjectAssigneeAfterInsert on ProjectAssignee__c (after insert) 
{
	// Send email to subscribers members
	ProjectSubscribersEmailServices pEmail = new ProjectSubscribersEmailServices();
    for ( ProjectAssignee__c pA : Trigger.new)
    pEmail.sendMailForTaskAssifned( pA.Id );
}