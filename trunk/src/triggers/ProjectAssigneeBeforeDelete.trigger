trigger ProjectAssigneeBeforeDelete on ProjectAssignee__c (before delete) {

	// Send email to subscribers members
	ProjectSubscribersEmailServices pEmail = new ProjectSubscribersEmailServices();
	List<String> lstAssId = new List<String>(); 
    for ( ProjectAssignee__c pA : Trigger.old )
    lstassId.add(pA.id);
    System.debug('\n\n//////////////////////////\n ProjectAssigneeBeforeDelete lstassId: ' + lstassId + '\n//////////////////////////\n\n');
    
    pEmail.sendMailForAssDeleted( lstassId );
    

}