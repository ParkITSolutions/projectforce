trigger ProjectAssigneeAfterInsert on ProjectAssignee__c (after insert) 
{
	// Send email to subscribers members
	ProjectSubscribersEmailServices pEmail = new ProjectSubscribersEmailServices();
	List<String> lstPAId = new List<String>();
    for ( ProjectAssignee__c pA : Trigger.new){
    	lstPAId.add(pA.id);
    }
    pEmail.sendMailForTaskAssigned( lstPAId );
}