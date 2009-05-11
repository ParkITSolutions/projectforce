/**
*@author Miguel Soares @ 04/14/2009
*/
@isTest private class ProjectSubscribeControllerTest {
	
	/**
	* Test  ProjectRedirectController
	*@void
    *@static
	*/
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