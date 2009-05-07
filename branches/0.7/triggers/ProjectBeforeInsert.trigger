trigger ProjectBeforeInsert on Project2__c (before insert) {
		for (Project2__c p : Trigger.new) {
				
				p.ProjectCreatedDate__c = System.now();
				p.ProjectCreatedBy__c = UserInfo.getUserId();
				
		}
}