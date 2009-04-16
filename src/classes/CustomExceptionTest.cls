@isTest private  class CustomExceptionTest {
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
    	CustomException ce = new CustomException();
    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    }     	
}