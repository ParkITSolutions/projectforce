@isTest private class ProjectDeleteTaskOverlayControllerTest {
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