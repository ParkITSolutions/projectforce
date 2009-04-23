/**
*@author Miguel Soares @ 04/14/2009
*/
@isTest private class ProjectWidgetMyTasksAndMilControllerTest {
	/**
	* Test  ProjectWidgetMyTasksAndMilController
	*@void
    *@static
	*/
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
    	
    	ProjectWidgetMyTasksAndMilController pw = new ProjectWidgetMyTasksAndMilController();
 
    	pw.loadAllProjectTasksAndMilestones(); 
    	pw.getOverdueAlreadyShow(); 
    	pw.getMilestonesList(); 
    	pw.getTasksList();    	
    	
    	ProjectWidgetMyTasksAndMilController.ProjectTasks pwp = new ProjectWidgetMyTasksAndMilController.ProjectTasks();
    	String strAux;
    	Boolean boolAux;
    	
    	pwp.TaskId = GenerateEnvironmentTest.task.id; 
    	strAux = pwp.TaskId;
    	 
    	pwp.Priority = 'medium'; 
    	strAux = pwp.Priority; 
    	
    	pwp.TaskName = 'Loooooong Taaaaaask Naaaaaaameeeeee'; 
    	strAux = pwp.TaskName; 
    	
    	pwp.TaskName = 'ShortTaskName'; 
    	strAux = pwp.TaskName; 
    	
    	pwp.IsMilestone = true; 
    	boolAux = pwp.isMilestone; 
    	
    	pwp.TaskDateClass = '--/--/--'; 
    	strAux = pwp.TaskDateClass; 
    	
    	pwp.OverDue = true; 
    	boolAux = pwp.OverDue; 
    	
    	pwp.DisplayTitle = true ; 
    	boolAux = pwp.DisplayTitle; 
    	
    	pwp.EndDate = '--/--/--'; 
    	strAux = pwp.EndDate;   
    	
    	pwp.setIsToLate( Date.toDay()); 
    	pwp.setIsToLate( Date.toDay().addMonths( 1 ));  
    	pwp.getIsToLate();
    	 
    	pwp.setDaysCount(Date.toDay(), 2);
    	pwp.setDaysCount( Date.toDay().addDays( 1 ), 2); 
    	pwp.setDaysCount(Date.toDay().addDays( 2 ), 2); 
    	pwp.getDaysCount(); 


    	
    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    }     	
}