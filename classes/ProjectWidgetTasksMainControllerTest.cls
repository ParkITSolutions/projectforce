/**
*@author Miguel Soares @ 04/14/2009
*/
@isTest private class ProjectWidgetTasksMainControllerTest {
	/**
	* Test  ProjectWidgetTasksMainController
	*/
    static testMethod void myUnitTest(){
        
        GenerateEnvironmentTest.gen();
        ProjectUtil.setIsTest( true );
        Test.startTest();

        System.currentPageReference().getParameters().put( 'id', GenerateEnvironmentTest.project.Id );
        ProjectWidgetTasksMainController pw = new ProjectWidgetTasksMainController();
        
        pw.setTeamId( GenerateEnvironmentTest.project.Id );
        pw.setSidebar( true );
        pw.setTaskResults( pw.getTaskResults());

        pw.getProjectTaskbuild();
        pw.getMyProjectTasks();
        pw.getAllProjectTasks();
        pw.getUserPermissions();
        pw.getTaskResults();
        pw.getSidebar();
        pw.getTeamId();

        ProjectWidgetTasksMainController.ProjectTask pt = new ProjectWidgetTasksMainController.ProjectTask();
        pt.setUser( GenerateEnvironmentTest.us );
        pt.setEndDate( Date.toDay());
        pt.setIsToLate( Date.toDay());
        pt.setTaskId( GenerateEnvironmentTest.task.Id );
        pt.setPriority( 'hight' );
        pt.setPercent( 10 );
        pt.setTaskName( 'task name');

        pt.getTaskName();
        pt.getPercent();
        pt.getPriority();
        pt.getTaskId();
        pt.getUserName();
        pt.getUserId();
        pt.getIsToLate();
        pt.getEndDate();
        pt.getPicture();

        Test.stopTest();
        ProjectUtil.setIsTest( false );
    } 
}