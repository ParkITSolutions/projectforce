trigger TaskCommentBeforeInsert on TaskComment__c (before insert) {
	
	//Logging changes to Task Comments
	TaskComment__c tskComment = Trigger.new.get(0);
	ProjectTask__c tskAux = DAOFactory.getInstance().getTask( tskComment.Task__c );
	TaskCommentActivity commentActivity =  new TaskCommentActivity( tskAux.Project__c, DateTime.now(), UserInfo.getUserId(), 'insert', tskComment.Id, tskAux.Id );	
}