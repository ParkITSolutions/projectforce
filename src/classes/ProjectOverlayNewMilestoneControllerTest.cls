/**
*@author Miguel Soares @ 04/14/2009
*/
@isTest private class ProjectOverlayNewMilestoneControllerTest {
	
	/**
	* Test  ProjectOverlayNewMilestoneController
	*@void
    *@static
	*/
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
		
		System.currentPageReference().getParameters().put( 'id', GenerateEnvironmentTest.project.Id );
		ProjectOverlayNewMilestoneController mileC = new ProjectOverlayNewMilestoneController();
    	
    	mileC.setCurrentProjectId( GenerateEnvironmentTest.project.Id );
    	
    	ProjectTask__c newTask = new ProjectTask__c();
    	newTask.StartDate__c = Date.today();
    	newTask.DurationUI__c = '1';
    	mileC.setNewProyect( newTask );
    	
    	mileC.insertMilestone();

    	mileC.dummyRefresh();

    	mileC.getUserLocale();
    	mileC.getCurrentProject();
    	mileC.getProjectMembers();
    	mileC.getProjectMember();
    	mileC.getTask();
    	mileC.getCurrentProjectId();
    	
    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    } 
}