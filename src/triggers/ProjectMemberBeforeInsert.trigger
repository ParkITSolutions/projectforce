trigger ProjectMemberBeforeInsert on ProjectMember__c (before insert) {
	
	for( ProjectMember__c m : trigger.new ){
		if( m.Project__c == null ){
			m.addError('Error. Select a Project for the bew Member');
		}
	}
}