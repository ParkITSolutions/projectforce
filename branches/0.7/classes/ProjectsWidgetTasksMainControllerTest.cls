@isTest private class ProjectsWidgetTasksMainControllerTest {
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();

		System.currentPageReference().getParameters().put( 'id', GenerateEnvironmentTest.project.Id );
		ProjectsWidgetTasksMainController pw = new ProjectsWidgetTasksMainController();
		
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

		ProjectsWidgetTasksMainController.ProjectTask pt = new ProjectsWidgetTasksMainController.ProjectTask();
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