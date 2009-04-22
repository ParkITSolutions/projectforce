/**
*@author: Miguel Soares @ 15-04-2009
*/
@isTest private  class CustomExceptionTest {
	
	/**
    * Test customException
    */
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
    	CustomException ce = new CustomException();
    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    }     	
}