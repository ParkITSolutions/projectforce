@isTest private class ProjectDetailMilestoneControllerTest {
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
    	
    	
    	
    	ProjectDetailMilestoneController mile = new ProjectDetailMilestoneController();
    	
    	
    	mile.setTeamId( GenerateEnvironmentTest.project.Id );
    	mile.setSidebar( false );

    	mile.genAllProjectTasks();
    	mile.getAllProjectTasks();
    	mile.getUserPermissions();
    	mile.getListSize();
    	mile.getSidebar();
    	mile.getTeamId();
    	
    	
    	// Inner class
    	ProjectDetailMilestoneController.ProjectTasks inn = new ProjectDetailMilestoneController.ProjectTasks();
    	
    	
    	
    	inn.setDayPercent( Date.today(), 2 );
    	inn.setDayPercentRight( Date.today(), 2 );
    	inn.setEndDate( Date.today(), 2 );
    	inn.setEndDateRight( Date.today(), 2 );
    	inn.setIsToLate( Date.today() );
    	inn.setDaysCount( Date.today(), 2 );
    	inn.setUser( GenerateEnvironmentTest.us );
    	inn.setTaskId( GenerateEnvironmentTest.task.Id );
    	inn.setPriority( 'high' );
    	inn.setTaskName( 'task name' );

    	inn.getTaskName();
    	inn.getPriority();
    	inn.getTaskId();
    	inn.getUserName();
    	inn.getUserId();
    	inn.getDaysCount();
    	inn.getEndDateRight();
    	inn.getIsToLate();
    	inn.getEndDate();
    	inn.getPicture();
    	inn.getDayPercentRight();
    	inn.getDayPercent();
    	
    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    }     	
}