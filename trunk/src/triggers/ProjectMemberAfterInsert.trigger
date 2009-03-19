trigger ProjectMemberAfterInsert on ProjectMember__c (after insert) 
{
	// Send email to subscribers members
	ProjectSubscribersEmailServices pEmail = new ProjectSubscribersEmailServices();
    for ( ProjectMember__c pM : Trigger.new)
    pEmail.sendMemberJoinLeave( pM.Id, 'join' );
}