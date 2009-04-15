@isTest private class ProjectTimelineControllerTest {
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
    	
    	System.currentPageReference().getParameters().put( 'id', GenerateEnvironmentTest.project.Id );
    	ProjectTimelineController pt = new ProjectTimelineController();
    	
    	pt.getProject();
    	
    	
    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    }    	
}