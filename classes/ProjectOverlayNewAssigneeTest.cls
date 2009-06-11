public class ProjectOverlayNewAssigneeTest {
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();

		System.currentPageReference().getParameters().put( 'id', GenerateEnvironmentTest.task.Id );
		ProjectOverlayNewAssigneeController po = new ProjectOverlayNewAssigneeController();
		
		
		po.setProjectId( GenerateEnvironmentTest.project.Id );
		po.getProjectId();
		po.setTaskId( GenerateEnvironmentTest.task.Id );
		po.getTaskId();
		po.getMemberList();
		po.setMemberSelected( GenerateEnvironmentTest.member.User__c );
		po.getMemberSelected();


		po.getTaskName();
		po.setPercentSelected( 10 );
		po.getPercentSelected();
		po.getScale();


		po.saveAssignee();







    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    } 
}