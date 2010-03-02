/**
* @author Matias Menafra 
* @createdDate 02/26/2010
*/
@isTest private class ProjectSubscriptionControllerTest {
	/**
	* Test ProjectSubscribers Email Services
	*/
    public static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
    	
    	System.currentPageReference().getParameters().put( 'id', GenerateEnvironmentTest.project.id );
    	ProjectSubscriptionController ps = new ProjectSubscriptionController();
    	
    	ps.loadProjectSubscription();
    	ps.saveSubscription();
		ps.deleteSubscription();
		
		Pagereference ref = ps.cancelSubscription();
    	
    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    }     	
}