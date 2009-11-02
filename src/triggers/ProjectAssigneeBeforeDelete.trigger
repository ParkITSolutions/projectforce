trigger ProjectAssigneeBeforeDelete on ProjectAssignee__c (before delete) {

	List<String> lstAssId = new List<String>(); 
    for ( ProjectAssignee__c pA : Trigger.old )
    lstassId.add(pA.id);

	// Send email to subscribers members
	ProjectSubscribersEmailServices mail = new ProjectSubscribersEmailServices();
    mail.sendMailForAssDeleted( lstassId );
    

}