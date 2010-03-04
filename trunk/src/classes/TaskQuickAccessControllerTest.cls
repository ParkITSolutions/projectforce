@isTest
private class TaskQuickAccessControllerTest {
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();

		TaskQuickAccessController taq = new TaskQuickAccessController();
		
		taq.setTaskCustomId( GenerateEnvironmentTest.task.id );
		taq.getTaskCustomId();
		taq.goToTaskDetail();

    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    }    	
}