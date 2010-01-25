trigger TaskCommentBeforeInsert on TaskComment__c (before insert) {
	
	//Logging changes to Task Comments
	TaskComment__c tskComment = Trigger.new.get(0);
	TaskCommentActivity commentActivity = new TaskCommentActivity( '', DateTime.now(), UserInfo.getUserId(), 'insert', tskComment );	
	commentActivity.log();
}