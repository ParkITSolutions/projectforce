trigger ProjectBeforeUpdate on Project2__c (before update) {
	for (Project2__c project : Trigger.new) {
        //Set Profile according Project Access
        if(project.Access__c != null){
	        if(project.Access__c.equals('Open')){
	            project.PublicProfile__c = [SELECT id FROM ProjectProfile__c WHERE Name =: 'Public Profile' limit 1].Id;
	            project.Type__c = 'open';            
	        }else if (project.Access__c.equals('Close')) {
	            project.NewMemberProfile__c = [SELECT id FROM ProjectProfile__c WHERE Name =: 'Member Profile' limit 1 ].Id;
	            project.PublicProfile__c = null;
	            project.Type__c = 'close';           
	        }else if (project.Access__c.equals('Private')){
	            project.Type__c = 'private';
	            project.PublicProfile__c = null;
	            project.NewMemberProfile__c = null;
	        }
		}  	
	}
}