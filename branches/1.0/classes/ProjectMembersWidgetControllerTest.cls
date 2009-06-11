/**
*@author Miguel Soares @ 04/08/2009
*/
@IsTest private class ProjectMembersWidgetControllerTest {
	
	/**
	* Test ProjectMembersWidgetController
	*@void
    *@static
	*/
    public static testMethod void testTeam() {
        try{ 
            
            GenerateEnvironmentTest.gen();
            Test.startTest();            
                    
            ProjectMembersWidgetController team = new ProjectMembersWidgetController();
            String curUser = team.getCurrentUser(); 
            team.setEmailNotifications( true );
            team.getIsManager();
            team.getEmailNotifications();
            team.setIsAdministrator( true );
            team.getIsAdministrator();
            team.getTeamspaceMembersIds();
            team.getAlready();
			team.getInitAddMembers();
			
            team.getNamespace();
            Project2__c t = GenerateEnvironmentTest.project;
            team.setIdTeam(t.Id);
            team.setTeam(t.Id);
            team.setTypeList('test');
            String result = team.getComponentHeader ();
            team.setTypeList('adminList');
            result = team.getComponentHeader ();
            Boolean render = team.getRenderLinkAction ();
            String teamName = team.getTeam();
            String teamId = team.getTeamId();
            team.getIsTeamAdmin();
            String typeList = team.getTypeList();
            team.getUserPermissions();
            
            ProjectMember__c m = GenerateEnvironmentTest.member;
            ProjectMembersWidgetController.TeamMember teamMember= new ProjectMembersWidgetController.TeamMember(m, null);
            m = teamMember.getMember();
            String userName = teamMember.getUsername();
            String yahoo = teamMember.getYahoo();
            String skype = teamMember.getSkype();
            String status = teamMember.getStatus();
            String pic = teamMember.getImage();
            teamMember.getId(); 
            teamMember.getIsPrivate(); 
            teamMember.getProfile(); 
            
            ProjectMembersWidgetController.Member member = new ProjectMembersWidgetController.Member();
            member = team.getNewMemberVars();
            member.getColleagueNames();
            member.getProfileId();
            member.setProfileId('');
            member.getMessage();
            member.setMessage('');
            member.getTeamRole();
            member.setTeamRole('');
            /*            
            Profile p = [select id from profile where name='System Administrator'];
            User newUser1 = new User(alias = 'test1', email='test1@testorg.com', 
                                    emailencodingkey='UTF-8', lastname='Testing2', languagelocalekey='en_US', 
                                    localesidkey='en_US',  profileid = p.Id,
                                    timezonesidkey='America/Los_Angeles', username='test1@testorg.com');
            insert newUser1;
            
            User newUser2 = new User(alias = 'test2', email='test2@testorg.com', 
                                    emailencodingkey='UTF-8', lastname='Testing2', languagelocalekey='en_US', 
                                    localesidkey='en_US', profileid = p.Id,
                                    timezonesidkey='America/Los_Angeles', username='test2@testorg.com');
            
            insert newUser2;
            
            User newUser3 = new User(alias = 'test3', email='test3@testorg.com', 
                                    emailencodingkey='UTF-8', lastname='Testing3', languagelocalekey='en_US', 
                                    localesidkey='en_US', profileid = p.Id,
                                    timezonesidkey='America/Los_Angeles', username='test3@testorg.com');
            
            insert newUser3;
            */
            List<User> users = new User[3];
            users[0] = GenerateEnvironmentTest.us;
            users[1] = GenerateEnvironmentTest.us;
            users[2] = GenerateEnvironmentTest.us;
            
            
            String names = null;
            for (User u : users){
                names += u.Name + ',';  
            }
    
            member.setColleagueNames(names);
            team.setNewMemberVars(member);
            
            team.setTypeList('test');
            team.getTeamspaceMembers();
            team.setTypeList('adminList');
            team.getTeamspaceMembers();
            
            List<SelectOption> options = team.getProfilesOptions();
            List<ProjectMember__c> members = team.getMemberListToolkit();
            Integer cnt = team.getMemberListToolkitCount();
            
            team.saveMembers();            
            
            team.syncSaveMembers();
            User user = [select Name, Email from User limit 1];
            team.SendMail(user, 'Message');

            Test.stopTest();
        }catch(Exception e){
            throw e;
        }
    }
}