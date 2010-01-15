trigger ProjectMemberBeforeInsert on ProjectMember__c (before insert) {
	
	ProjectMember__c prjMember = Trigger.new.get(0);
	//Logging Changes for Project Members
    MemberActivity memberActivity = new MemberActivity( prjMember.Project__c, DateTime.now(), UserInfo.getUserId(), 'insert', prjMember );	
	memberActivity.log();
}