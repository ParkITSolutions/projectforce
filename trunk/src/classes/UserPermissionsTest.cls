/**
*@author Miguel Soares @ 04/15/2009
*/
@IsTest private class UserPermissionsTest {
    
    /**
    * Run code coverage for UserPermissions class
    *@static
    *@void
    *@testMethod
    */ 
    public static testMethod void UserPermissionsTest(){
		/*
		GenerateEnvironmentTest.gen();
		*/
		Test.startTest();
		
        List<User> NOTteamAdmin = [Select id, Profile.PermissionsModifyAllData, ProfileId, Name From User where Profile.Name = 'Read Only' limit 1];
        //Set non Admin user
        String userId;
        if (NOTteamAdmin.size() > 0) {
            userId = NOTteamAdmin[0].Id;
        }else {
            userId = UserInfo.getUserId();
        }
		
		UserPermissions up = new UserPermissions();
        up.setId(userId);
        
        //Get one TeamMember & Team for non Admin user.
        List<Project2__c> teamList = new List<Project2__c>();
        teamList = [SELECT id FROM Project2__c];
        if (teamList.size() > 0 ) {
            ProjectMember__c teamMember = [select Id, Project__c from ProjectMember__c where User__c !=: userId limit 1];
    		
            //Test Team Permissions
            up.setProject(teamMember.Project__c);
            up.setObjectType('Team');
            up.setPermissions();
            
            //Test ProjectTask Permissions
            ProjectTask__c pt = [select Id from ProjectTask__c limit 1];
            up.setObjectType('Project');
            up.setPermissions();
            
            //Test getters
            userId = up.getId();        
            String objectType = up.getObjectType();
            String teamId = up.getProject();      
            Boolean canMange = up.getCanManage();
            Boolean canCreate = up.getCanCreate();
            Boolean canComment = up.getCanComment();
            Boolean canView = up.getCanView();
        }
        
        //Test Admin User (current user should be App Admin for this)
        up = new UserPermissions();
        up.setId(UserInfo.getUserId());
        up.setPermissions(); 
       	
       	Test.stopTest();
    }
    
}