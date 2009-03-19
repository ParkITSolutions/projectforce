trigger ProjectBeforeDelete on Project2__c (before delete) {
			
		    Integer mySoql = 0;
		    Integer mySoqlLimit = Limits.getLimitQueries();    
		   
		    mySoql = Limits.getQueries();
		    
		    Project2__c[] p = Trigger.old;      
		        
		    //Remove Members from the Project
		    List<ProjectMember__c> members = [SELECT Id FROM ProjectMember__c WHERE Project__c in :Trigger.old];
		    delete members;     
			
			
		    
		    mySoql = Limits.getQueries();
		    
		    //Remove tasks from the project
			 List<ProjectTask__c> tasks = [SELECT Id FROM ProjectTask__c WHERE Project__c in :Trigger.old];
		     delete tasks;  
		     
		     
            List<String> idsProject = new List<String>();
            for (Project2__c iterProj : Trigger.old) {
                idsProject.add(iterProj.Id); 
            }
		     
		     
		    String grName = 'Project' + idsProject[ 0 ];
            
            List<String> grs = new List<String>(); 
            for ( Group gr : [ SELECT Id FROM Group WHERE Name =: grName ])
            grs.add( gr.id );
            
            List<String> grMembers = new List<String>();
            for( GroupMember gm : [ SELECT Id FROM GroupMember WHERE GroupId in: grs ])
            grMembers.add( gm.id );
        
        	//TeamUtil.deleteGroupMembers( grMembers );
        	//TeamUtil.deleteGroup( grs );   
			
}