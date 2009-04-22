/**
*@author Miguel Soares @ 04/14/2009
*/
@isTest private class ProjectOverlayNewTaskControllerTest {
	
	/**
	* Test  ProjectOverlayNewTaskController
	*/
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
    	

		System.currentPageReference().getParameters().put( 'id', GenerateEnvironmentTest.project.Id );
		ProjectOverlayNewTaskController mileC = new ProjectOverlayNewTaskController();
    	
    	mileC.setProject( GenerateEnvironmentTest.project.Id );
    	
    	ProjectTask__c newTask = new ProjectTask__c();
    	mileC.setTask( newTask );
    	
    	mileC.insertTask();

    	mileC.dummyRefresh();

    	mileC.getCurrentProject();
    	mileC.getProjectMembers();
    	mileC.getProjectMember();
    	mileC.getTask();
    	mileC.getCurrentProjectId();

    	
    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    }     	
}