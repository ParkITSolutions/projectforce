/**
*@author Miguel Soares @ 04/14/2009
*/
@isTest private class ProjectRedirectControllerTest {
	
	/**
	* Test  ProjectRedirectController
	*/
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
    	
    	ProjectRedirectController pr = new ProjectRedirectController();
    	
    	pr.getNamespace();
    	pr.isAdmin();
    	
    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    }    	
}