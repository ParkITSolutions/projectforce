trigger ProjectBeforeDelete on Project2__c (before delete) {
			 
		    Project2__c[] p = Trigger.old;      
		        
		    //Remove Members from the Project
		    List<ProjectMember__c> members = [SELECT Id FROM ProjectMember__c WHERE Project__c in :Trigger.old limit 1000];
		    delete members;     
			
		    //Remove tasks from the project
			 List<ProjectTask__c> tasks = [SELECT Id FROM ProjectTask__c WHERE Project__c in :Trigger.old limit 1000];
		     delete tasks; 
		     
		     //Remove all attachments from the project
			 List<Attachment> attachs = [SELECT Id FROM Attachment WHERE ParentId in : Trigger.old limit 1000];
		     delete attachs;   
		
}