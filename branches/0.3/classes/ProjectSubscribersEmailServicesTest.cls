/**
*@author Miguel Soares @ 04/14/2009
*/
@isTest private class ProjectSubscribersEmailServicesTest {
	
	/**
	* Test  ProjectSubscribersEmailServices
	*/
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
    	
    	ProjectSubscribersEmailServices es = new ProjectSubscribersEmailServices();
    	
    	
    	es.setIsTaskEdit( true );
    	
    	List<String> lPM = new List<String>();
    	lPM.add( GenerateEnvironmentTest.member.Id );
    	lPM.add( GenerateEnvironmentTest.member2.Id );
    	es.sendMemberJoinLeave( lPM, 'join' );
    	es.sendMemberJoinLeave( lPM, 'leave' );
    	
    	es.setIsTest( true );
    	es.setIsTaskEdit( true );
		List<String> lPA = new List<String>();
		lPA.add( GenerateEnvironmentTest.assi.Id );    	
		lPA.add( GenerateEnvironmentTest.assi2.Id );    	
		lPA.add( GenerateEnvironmentTest.assi3.Id );    	
    	es.sendMailForTaskAssigned( lPA );
    	
    	List<String> lPT = new List<String>();
    	lPT.add( GenerateEnvironmentTest.task.Id );
    	lPT.add( GenerateEnvironmentTest.task2.Id );
    	es.sendMailForTaskChanged( lPT );
    	es.sendMailForTaskDeleted( lPT );


		ProjectSubscription__c sub = new ProjectSubscription__c();
		sub.Project__c = GenerateEnvironmentTest.project.Id;
		sub.ProjectMemberJoinLeave__c = true;
		sub.ProjectTaskAssignedToMe__c = true;
		sub.ProjectTaskAssignToMeChanged__c = true;
		sub.ProjectTaskChanged__c = true;
		sub.ProjectTaskDeleted__c = true;
		sub.User__c = GenerateEnvironmentTest.us.Id;
		List<ProjectSubscription__c> psb = new List<ProjectSubscription__c>();
		psb.add( sub );
		psb.add( sub );
		psb.add( sub );
		psb.add( sub );
		psb.add( sub );
		psb.add( sub );
		psb.add( sub );
		psb.add( sub );
		psb.add( sub );
		psb.add( sub );
		psb.add( sub );
		ProjectSubscribersEmailServices.alreadySent = true;
		es.genAddress( psb, '', '' );    	
    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    } 
}