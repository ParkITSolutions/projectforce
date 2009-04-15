@isTest private class ProjectSearchResultControllerTest {
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
    	            
	    Id[] fixedSearchResultsList = new Id[1];
	
	    fixedSearchResultsList.add(GenerateEnvironmentTest.project.Id); 
	    Test.setFixedSearchResults(fixedSearchResultsList);

            
        ProjectSearchResultController team = new ProjectSearchResultController();
        
        team.setCriteria('Foo');
        team.search();
        String criteria = team.getCriteria();
                        
        ProjectMember__c tm = GenerateEnvironmentTest.member;
        
        ProjectSearchResultController.SearchResult srch = new ProjectSearchResultController.SearchResult();
        srch.setName('Team', 'Tea');
        srch.setMatches('Tea', 'Tea');

        String matches = srch.getMatches();
        
        team.setTeamId(tm.Project__c);
        team.genCntPagination();
        team.nextPage();
        team.prevPage();
        team.lastPage();
        team.firstPage();
            
        Boolean b1 = team.getPrevPageLinkShow();
        Boolean b2 = team.getPrevPageShow();
        Boolean b3 = team.getNextPageLinkShow();
        Boolean b4 = team.getNextPageShow();
        Boolean b5 = team.getNoMatches();
        team.getLastItem();
        team.getFirstItem();
        Integer totalNumers = team.getTotalItemsNumber();
        Integer firstRow = team.getFirstRow();
        
        team.setJumpPage(1);
        team.JumpToPage();

    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    }     	
}