/**
*@author Miguel Soares @ 04/14/2009
*/
@isTest private class ProjectSubscriptionControllerTest {
	/**
	* Test  ProjectSubscribersEmailServices
	*@void
    *@static
	*/
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
    	/*
    	System.currentPageReference().getParameters().put( 'id', GenerateEnvironmentTest.project.id );
    	ProjectSubscriptionController ps = new ProjectSubscriptionController();
    	
    	ps.setIdProject( GenerateEnvironmentTest.project.id );
    	ps.subscription.ProjectTaskChanged__c = true;
    	ps.saveSubscription();
    	ps.deleteSubscription();
    	ps.getIdProject();
    	ps.getSubscription();
    	ps.getSubscriptionCount();

    	System.currentPageReference().getParameters().put( 'id', GenerateEnvironmentTest.project.id );
    	ps = new ProjectSubscriptionController();
    	ProjectSubscription__c newS = new  ProjectSubscription__c();
    	newS.Project__c = GenerateEnvironmentTest.project.id;
    	newS.ProjectMemberJoinLeave__c = true;
    	newS.ProjectTaskAssignedToMe__c = true;
    	newS.ProjectTaskAssignToMeChanged__c = true;
    	newS.ProjectTaskChanged__c = true;
    	newS.ProjectTaskDeleted__c = true;
    	newS.User__c  = GenerateEnvironmentTest.us.id;
		insert newS;
    	ps.saveSubscription();

    	System.currentPageReference().getParameters().put( 'id', GenerateEnvironmentTest.project.id );
    	ps = new ProjectSubscriptionController();
    	ps.cancelSubscription();
*/
    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    }     	
}