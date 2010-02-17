trigger ProjectBeforeDelete on Project2__c (before delete) {
             
            Project2__c[] p = Trigger.old;      
                
            //Remove Members from the Project
            List<ProjectMember__c> members = new List<ProjectMember__c>(); 
            for( ProjectMember__c pm : [SELECT Id FROM ProjectMember__c WHERE Project__c in :Trigger.old limit 1000])
                members.add( pm );
            delete members;     
            
            //Remove tasks from the project
             List<ProjectTask__c> tasks = new List<ProjectTask__c>(); 
             for( ProjectTask__c pt : [SELECT Id FROM ProjectTask__c WHERE Project__c in :Trigger.old limit 1000])
                tasks.add( pt );
             delete tasks; 
             
             //Remove all attachments from the project
             List<Attachment> attachs = new List<Attachment>(); 
             for(Attachment a : [SELECT Id FROM Attachment WHERE ParentId in : Trigger.old limit 1000])
                attachs.add( a );
             delete attachs;   
        
}