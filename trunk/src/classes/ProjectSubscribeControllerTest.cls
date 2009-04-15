@isTest private class ProjectSubscribeControllerTest {
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();

		System.currentPageReference().getParameters().put( 'id', GenerateEnvironmentTest.project.Id );
		ProjectSubscribeController ps = new ProjectSubscribeController();
		
		ps.setIdProject( GenerateEnvironmentTest.project.Id );
    	
    	ps.getSubscriptionCount();
    	ps.getIdProject();
    	
    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    }     	
}