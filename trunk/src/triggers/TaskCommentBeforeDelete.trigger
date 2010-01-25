trigger TaskCommentBeforeDelete on TaskComment__c (before delete) {
	
	for ( TaskComment__c comment : Trigger.old ){
    	
    	//Logging changes to Task Comments
		//TaskCommentActivity commentActivity = new TaskCommentActivity( '', DateTime.now(), UserInfo.getUserId(), 'delete', comment );	
		//commentActivity.log();
    }
	
}