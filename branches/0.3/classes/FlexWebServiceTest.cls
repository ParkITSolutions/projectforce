/**
*@author: Miguel Soares @ 15-04-2009
*/
@isTest private class FlexWebServiceTest {
	
	/**
    * Test FlexWebService
    */
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
    	
    	FlexWebService  fw = new FlexWebService();
    	
    	fw.genPermissions( GenerateEnvironmentTest.project.id, GenerateEnvironmentTest.us.id );
    	FlexWebService.generatePermissions( GenerateEnvironmentTest.us.id, GenerateEnvironmentTest.project.id );
    	
    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    }     	
}