/**
*@author Miguel Soares @ 04/14/2009
*/
@isTest private class SearchControllerTest {
	/**
	* Test  SearchController
	*@void
    *@static
	*/
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
    	
    	System.currentPageReference().getParameters().put( 'id', GenerateEnvironmentTest.project.id );
    	SearchController sc = new SearchController();
    	
    	sc.setModule('project');
    	sc.getDefaultText();
    	sc.setModule('task');
    	sc.getDefaultText();
    	    	
    	sc.setKey( 'kkey' );
    	sc.setTeamId(GenerateEnvironmentTest.project.id );
    	sc.getTeamId();
    	sc.getKey();
    	sc.getModule();
    	sc.setLabelName('Projects');
    	String retVal = sc.getDefaultText();
    	sc.setKey( 'kkey' );
    	//TODO Pagereference pr = sc.searchKey();
    	//myUnitTest();
		Boolean retVal1 = sc.getIsCriteriaLengthProperly();
   		
    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    } 
}