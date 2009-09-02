public class TaskQuickAccessControllerTest {
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();

		TaskQuickAccessController taq = new TaskQuickAccessController();
		
		taq.setTaskId( '#' + GenerateEnvironmentTest.task.Id__c );
		taq.getTaskId();
		taq.setError( true );
		taq.getError();
		taq.go();
 
    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    }    	
}