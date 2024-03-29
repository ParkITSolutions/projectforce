@isTest private class ProjectMembersListControllerTest {
    

    public static String idTeam = System.currentPageReference().getParameters().get('id');
    public static Boolean sortByDesc = false;
    public static String sortBy = 'User__r.Name';
    User newUser = [select id from User where id !=: UserInfo.getUserId() limit 1];
    

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
            member.setRole( 'Admin');
            member.getRole();
            member.setUserId(GenerateEnvironmentTest.user.Id );
            member.setCompany('');
            member.setName('');
            member.setMemberImg(GenerateEnvironmentTest.user.Id );
            member.getProfile();
            member.getProjectMemberId();
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
 
            team.getRemoveMessage();
            team.getDelName();
            team.getEditMember();
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
            
            
            team.setSortBy('User__r.Name');
            team.getSortBy();
            team.setSortBy('User__r.CompanyName');
            team.getSortBy();
            team.setSortBy('User__r.Title');
            team.getSortBy();
            team.setSortBy('Profile__r.Name');
            team.getSortBy();

            
            // Methods WITH SOQL queries
            team.getAdminCount(); // 1 SOQL
            team.getUserMemberId(); // 1 SOQL 
            System.currentPageReference().getParameters().put('delId',GenerateEnvironmentTest.member.User__c);
            team.assignRemoveId();// 1 SOQL 
            team.getProfilesOptions(); // 1 SOQL
            team.getProfilesOptionsFilter(); // 1 SOQL
            team.genMembers(); // 1 SOQL
           
            System.currentPageReference().getParameters().put('ltr', UserInfo.getName().substring( 0, 1 ));
            team.genMembers(); // 1 SOQL
            team.getLetterFilter();

            
            // Methods WITH more than 1 SOQL query
            System.currentPageReference().getParameters().put('editId',GenerateEnvironmentTest.member.User__c);
            team.assignEditId(); // 4 SOQL
            team.editMemberAction();
            
            team.refresh();
            
            team.removeMember(); // 1 SOQL
            
            team.setError( true );
            team.getFinish();
            team.setFinish( true );
            team.resetErrorAndFinish();
            team.setProjectId( GenerateEnvironmentTest.project.id );
            team.setIdProject( GenerateEnvironmentTest.project.id );
            team.getProjectId();
            team.joinProject();
            team.unjoinProject();
            team.isLastMemberAdmin();
            team.getRemoveMemberId();
            //////////////////////////////
            //      92 SOQL AND 74%     //
            //////////////////////////////
            
            Test.stopTest();
        }
        catch(Exception e){
            throw e;
        }
    }

    /**
    * Test ProjectMembersListController
    *@void
    *@static
    */
    public static testMethod void testTeam2() {
        try{
            GenerateEnvironmentTest.gen();
            Test.startTest();
            System.currentPageReference().getParameters().put( 'id', GenerateEnvironmentTest.project.id );
            ProjectMembersListController team = new ProjectMembersListController();
            
            team.getDeletingAllAmdsErr();
            
            String memToDel = GenerateEnvironmentTest.member.Id;
            team.setMassiveRemoveMemIds( memToDel );
            team.getMassiveRemoveMemIds();
            team.massiveRemove();
            
            team.getError();
            
            
            Test.stopTest();
        }
        catch(Exception e){
            throw e;
        }
    }   
}