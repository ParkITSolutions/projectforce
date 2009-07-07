/**
*@author Miguel Soares @ 04/08/2009
*/
@isTest private class ProjectDeleteTaskOverlayControllerTest {
	
	/**
	* Test ProjectDeleteTaskOverlayController
	*@void
    *@static
	*/
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
    	
    	ProjectDeleteTaskOverlayController t = new ProjectDeleteTaskOverlayController();
    	
    	t.setIdDeletes( GenerateEnvironmentTest.task.Id + ':' + GenerateEnvironmentTest.mile.Id );
    	t.getIdDeletes();
    	t.deleteTaskFromList();
    	t.deleteTaskFromDetail();
    	
    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    }     	
}