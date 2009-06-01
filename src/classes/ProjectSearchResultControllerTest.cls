/**
*@author Miguel Soares @ 04/14/2009
*/

@isTest private class ProjectSearchResultControllerTest {
	
	/**
	* Test  ProjectRedirectController
	*@void
    *@static
	*/
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
    	//asas
    	            
	    Id[] fixedSearchResultsList = new Id[1];
	
	    fixedSearchResultsList.add(GenerateEnvironmentTest.project.Id); 
	    Test.setFixedSearchResults(fixedSearchResultsList);

		System.currentPageReference().getParameters().put( 'id', GenerateEnvironmentTest.project.Id );            
        ProjectSearchResultController team = new ProjectSearchResultController();
        
        team.setTeamId(  GenerateEnvironmentTest.project.Id );
        team.setCriteria('ta');
        team.search();
        String criteria = team.getCriteria();
                        
        ProjectMember__c tm = GenerateEnvironmentTest.member;
        
        ProjectSearchResultController.SearchResult srch = new ProjectSearchResultController.SearchResult();
        srch.setName('Team', 'Tea');
        srch.setMatches('Tea', 'Tea');

        String matches = srch.getMatches();
        
        team.setTeamId(tm.Project__c);
        team.getTeamId();
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

		team.getSearchResultList();
		
    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    }     	
}