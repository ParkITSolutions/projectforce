/**
*@author Miguel Soares @ 04/08/2009
*/
@isTest private class ProjectMembersListControllerTest {
	

    public static String idTeam = System.currentPageReference().getParameters().get('id');
    public static Boolean sortByDesc = false;
    public static String sortBy = 'User__r.Name';
    User newUser = [select id from User where id !=: UserInfo.getUserId() limit 1];
    
    /**
	* Test ProjectMembersListController
	*/
    public static testMethod void testTeam() {
        try{
            GenerateEnvironmentTest.gen();
            Test.startTest();
			System.currentPageReference().getParameters().put( 'id', GenerateEnvironmentTest.project.id );
            ProjectMembersListController team = new ProjectMembersListController();
            
            team.getNamespace();
            team.getProjectName();
            team.getIsLastAdmin();
            team.setEditMemberId( GenerateEnvironmentTest.member.id);
            team.getEditMemberProfile();
            team.setEditMemberProfile(team.getEditMemberProfile());
            team.getProjectEditProfiles(); 
            team.setLetter( 'ALL' );
            
            
            // Team Inner Class
            ProjectMembersListController.Member member = new ProjectMembersListController.Member();
            member.getYahoo();
            member.getSkype();
            member.getUserId();

            member.getName();
            member.getMemberImg();
            member.getCompany();
            member.getTitle();
            //member.getProfile();
            //member.getRole();
            member.setUserId(GenerateEnvironmentTest.us.Id );
            member.setCompany('');
            member.setName('');
            member.setMemberImg(GenerateEnvironmentTest.us.Id );
            //member.setProfile('');
            //member.setRole('');
            member.setTitle('');
            member.setAdmin(true);
            member.getAdmin();
            
            // Letters Inner Class
            ProjectMembersListController.Letters letter = new ProjectMembersListController.Letters();
            letter.setLetter('ALL');
            letter.getLetter();
            letter.setContainMembers(0);
            letter.getContainMembers();
            
            // Pagination Methods
            team.genCntPagination();
            team.nextPage();
            team.prevPage();
            team.getCurrentPagination();
            team.getNumberOfItemsToShow();
            team.getFirstRow();
            team.getLastItem();
            team.getTotalItemsNumber();
            
            Boolean b1 = team.getPrevPageLinkShow();
            Boolean b2 = team.getPrevPageShow();
            Boolean b3 = team.getNextPageLinkShow();
            Boolean b4 = team.getNextPageShow();
            
            // Methods without SOQL queries
            team.setRemoveMemberId(GenerateEnvironmentTest.member.User__c);
            //team.getTeamId();
            //team.getCurrentUser();
            team.getRemoveMessage();
            team.getDelName();
            //team.getItsLastAdmin();
            //team.setEditMemberId(GenerateEnvironmentTest.member.User__c);
            //team.getEditMemberRole();
            //team.setEditMemberRole('Foo Role');
            //team.getEditMemberProfile();
            //team.setEditMemberProfile('Foo Profile');
            team.getEditMember();
            //team.getImgEditMember();
            team.getUserPermissions();
            List<ProjectMembersListController.Member> mem = team.getMembers();
            team.getFirstItem();
            team.getCntPagination();
             
            // Sort Methods
            team.getSortByDesc();
            team.setSortBy('User__r.Name');
            team.getSortBy();
            System.currentPageReference().getParameters().put( 'sb', 'User__r.Name' );
            team.sortList(); // 1 SOQL
            System.currentPageReference().getParameters().put( 'sb', 'User__r.Name' );
            team.sortList(); // 1 SOQL
			team.setLetter( 'A' );
            System.currentPageReference().getParameters().put( 'sb', 'User__r.Name' );
            team.sortList(); // 1 SOQL
            System.currentPageReference().getParameters().put( 'sb', 'User__r.Name' );
            team.sortList(); // 1 SOQL
            
			team.setLetter( 'All' );
            System.currentPageReference().getParameters().put( 'sb', 'User__r.CompanyName' );
            team.sortList(); // 1 SOQL
            System.currentPageReference().getParameters().put( 'sb', 'User__r.CompanyName' );
            team.sortList(); // 1 SOQL
			team.setLetter( 'A' );
            System.currentPageReference().getParameters().put( 'sb', 'User__r.CompanyName' );
            team.sortList(); // 1 SOQL
            System.currentPageReference().getParameters().put( 'sb', 'User__r.CompanyName' );
            team.sortList(); // 1 SOQL


			team.setLetter( 'All' );
            System.currentPageReference().getParameters().put( 'sb', 'User__r.Title' );
            team.sortList(); // 1 SOQL
            System.currentPageReference().getParameters().put( 'sb', 'User__r.Title' );
            team.sortList(); // 1 SOQL
			team.setLetter( 'A' );
            System.currentPageReference().getParameters().put( 'sb', 'User__r.Title' );
            team.sortList(); // 1 SOQL
            System.currentPageReference().getParameters().put( 'sb', 'User__r.Title' );
            team.sortList(); // 1 SOQL

			team.setLetter( 'All' );
            System.currentPageReference().getParameters().put( 'sb', 'Profile__r.Name' );
            team.sortList(); // 1 SOQL
            System.currentPageReference().getParameters().put( 'sb', 'Profile__r.Name' );
            team.sortList(); // 1 SOQL
			team.setLetter( 'A' );
            System.currentPageReference().getParameters().put( 'sb', 'Profile__r.Name' );
            team.sortList(); // 1 SOQL
            System.currentPageReference().getParameters().put( 'sb', 'Profile__r.Name' );
            team.sortList(); // 1 SOQL

            
            // Methods WITH SOQL queries
            team.getAdminCount(); // 1 SOQL
            //team.getTeamName(); // 1 SOQL
            team.getUserMemberId(); // 1 SOQL 
            System.currentPageReference().getParameters().put('delId',GenerateEnvironmentTest.member.User__c);
            team.assignRemoveId();// 1 SOQL 
            team.getProfilesOptions(); // 1 SOQL
            team.getProfilesOptionsFilter(); // 1 SOQL
            //team.getTeamEditProfiles(); // 1 SOQL
            team.genMembers(); // 1 SOQL
            //team.getIsTeamAdmin(); // 1 SOQL
           
           	System.currentPageReference().getParameters().put('ltr','true');
           	team.genMembers(); // 1 SOQL
            team.getLetterFilter();

            
            // Methods WITH more than 1 SOQL query
            System.currentPageReference().getParameters().put('editId',GenerateEnvironmentTest.member.User__c);
            team.assignEditId(); // 4 SOQL
            team.editMemberAction();
            
            team.refresh();
            
            team.removeMember(); // 1 SOQL
            
            //////////////////////////////
            //      92 SOQL AND 74%     //
            //////////////////////////////
            
            Test.stopTest();
        }
        catch(Exception e){
            throw e;
        }
    }
   
}