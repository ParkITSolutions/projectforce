trigger TaskCommentBeforeDelete on TaskComment__c (before delete) {
	
	//Logging changes to Task Comments
	TaskComment__c tskComment = Trigger.new.get(0);
	TaskCommentActivity commentActivity = new TaskCommentActivity( tskComment.Task__r.Project__c, DateTime.now(), UserInfo.getUserId(), 'delete', tskComment );	
	commentActivity.log();
}