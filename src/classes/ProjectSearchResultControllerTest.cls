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
		
		team.refreshPages();
		Integer page = team.getCurrentPagination();
		Integer page1 = team.getCntPagination();
		Integer page2 = team.getNumberOfItemsToShow();
		Integer page3 = team.getJumpPage();
		String user = team.getCurrentUser();
		
		Id num = '3';
		srch.setId(num);
		Id retvalue1 = srch.getId();
		String retValue2 = srch.getName();
		String retValue3 = srch.getRealName();
		String retValue4 = srch.getResultType();
		String retValue5 = srch.getMatches();
		
		srch.setResultType('dde');
		srch.setRealName('miguel');
		srch.setName('ted', 'de');
		
		
    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    }     	
}