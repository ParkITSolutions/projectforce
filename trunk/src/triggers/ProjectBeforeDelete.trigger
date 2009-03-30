trigger ProjectBeforeDelete on Project2__c (before delete) {
			 
		    Project2__c[] p = Trigger.old;      
		        
		    //Remove Members from the Project
		    List<ProjectMember__c> members = [SELECT Id FROM ProjectMember__c WHERE Project__c in :Trigger.old];
		    delete members;     
			
			
		    
		    
		    //Remove tasks from the project
			 List<ProjectTask__c> tasks = [SELECT Id FROM ProjectTask__c WHERE Project__c in :Trigger.old];
		     delete tasks;  
		    
			
}