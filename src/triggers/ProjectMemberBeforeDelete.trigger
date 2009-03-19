trigger ProjectMemberBeforeDelete on ProjectMember__c (before delete) 
{
	// Send email to subscribers members
	ProjectSubscribersEmailServices pEmail = new ProjectSubscribersEmailServices();
    for ( ProjectMember__c pM : Trigger.old )
    pEmail.sendMemberJoinLeave( pM.Id, 'leave' );
}