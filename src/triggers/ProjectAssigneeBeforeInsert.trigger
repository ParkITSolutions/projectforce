trigger ProjectAssigneeBeforeInsert on ProjectAssignee__c (before insert) {
	
	//Logging for Task assignees
	ProjectAssignee__c assignee = Trigger.new.get(0);
	TaskAssigneeActivity asigneeActivity = new TaskAssigneeActivity( assignee.Project__c, DateTime.now(), UserInfo.getUserId(), 'insert', assignee );
	asigneeActivity.log();
}