/**
*@author Miguel Soares @ 04/14/2009
*/
@isTest private class ProjectOverlayNewTaskControllerTest {
	
	/**
	* Test  ProjectOverlayNewTaskController
	*@void
    *@static
	*/
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
    	

		System.currentPageReference().getParameters().put( 'id', GenerateEnvironmentTest.project.Id );
		ProjectOverlayNewTaskController mileC = new ProjectOverlayNewTaskController();
    	
    	mileC.setProject( GenerateEnvironmentTest.project.Id );
    	
    	ProjectTask__c newTask = new ProjectTask__c();
    	newTask.StartDate__c = Date.today();
    	newTask.DurationUI__c = '1';
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