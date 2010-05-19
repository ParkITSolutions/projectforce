trigger ProjectBeforeInsert on Project2__c (before insert) {
	
	for( Project2__c project : Trigger.new ){
		
		project.ProjectCreatedDate__c 	= System.now();
		project.ProjectCreatedBy__c 	= UserInfo.getUserId();
	
        //Set Profile according Project Access
        if( project.Access__c.equals( 'Open' ) ){
            project.PublicProfile__c 	= [SELECT id FROM ProjectProfile__c WHERE Name =: 'Public Profile' limit 1].Id;
            project.Type__c 			= 'open';            
        }
        else if( project.Access__c.equals( 'Closed' ) ){
            project.NewMemberProfile__c = [SELECT id FROM ProjectProfile__c WHERE Name =: 'Member Profile' limit 1 ].Id;
            project.PublicProfile__c 	= null;
            project.Type__c 			= 'closed';           
        }
        else if( project.Access__c.equals( 'Private' ) ){
            project.Type__c 			= 'private';
            project.PublicProfile__c 	= null;
            project.NewMemberProfile__c = null;
        }  	
	}
}