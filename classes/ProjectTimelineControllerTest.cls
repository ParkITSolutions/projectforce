/**
*@author Miguel Soares @ 04/14/2009
*/
@isTest private class ProjectTimelineControllerTest {
	
	/**
	* Test  ProjectTaskListController
	*/
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