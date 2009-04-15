@isTest private class SearchControllerTest {
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
    	
    	System.currentPageReference().getParameters().put( 'id', GenerateEnvironmentTest.project.id );
    	SearchController sc = new SearchController();
    	
    	sc.setModule('project');
    	sc.getDefaultText();
    	sc.getLabel();
    	sc.setModule('task');
    	sc.getDefaultText();
    	sc.getLabel();
    	    	
    	sc.setKey( 'kkey' );
    	sc.setTeamId(GenerateEnvironmentTest.project.id );
    	sc.getTeamId();
    	sc.getKey();
    	sc.getModule();

    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    } 
}