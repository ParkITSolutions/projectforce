trigger ProjectAssigneeBeforeDelete on ProjectAssignee__c (before delete) {

	List<String> lstAssId = new List<String>(); 
	List<String> tasksIdList = new List<String>(); 
	List<String> usersIdList = new List<String>(); 
	
    for ( ProjectAssignee__c pA : Trigger.old ){
    	lstassId.add(pA.id);
    	tasksIdList.add( pA.ProjectTask__c );
    	usersIdList.add( pA.User__c );
    	
    	//Logging for Task assignees
		ProjectAssignee__c assignee = Trigger.new.get(0);
		TaskAssigneeActivity asigneeActivity = new TaskAssigneeActivity( assignee.Project__c, DateTime.now(), UserInfo.getUserId(), 'delete', assignee );
		asigneeActivity.log();
    }

	// Send email to subscribers members
	//ProjectSubscribersEmailServices mail = ProjectSubscribersEmailServices.getInstance();
    ProjectSubscribersEmailServices.sendMailForAssDeletedFuture( lstassId, tasksIdList, usersIdList );
    
	
}