@isTest private class ProjectRedirectControllerTest {
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