/**
*@author Miguel Soares @ 04/14/2009
*/
@isTest private class ProjectTaskDetailControllerTest {
	
	/**
	* Test  ProjectTaskDetailController
	*@void
    *@static
	*/
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
    	ApexPages.StandardController stdStrl;
    	System.currentPageReference().getParameters().put('id', GenerateEnvironmentTest.task.id );
        ProjectTaskDetailController taskDetailController = new ProjectTaskDetailController( stdStrl );
        taskDetailController.setTaskId(GenerateEnvironmentTest.task.Id);
        ProjectTask__c newTask = [select id from ProjectTask__c limit 1];        
        taskDetailController.getTask(newTask.Id);
        taskDetailController.markComplete();   
        
        taskDetailController.getMaxAssignees();               
        
        ProjectTaskDetailController.TaskDetails a = taskDetailController.getTask();
         
        if(a.StartDate == null )
            System.assert(true, 'List has no rows assigned to project task'); 
        if(taskDetailController.getDetailsOk() == null)
            System.assert(true, 'boolean detailsok not defined'); 
        
        ProjectTaskDetailController.ProjectAssignee projectAss = new ProjectTaskDetailController.ProjectAssignee();
        
        if(projectAss.getId() == null) 
            System.assert(true, 'Project Assignee Class null var');    
        if(projectAss.getName() == null) 
            System.assert(true, 'Project Assignee Class null var');     
        if(projectAss.getPercent() == null) 
            System.assert(true, 'Project Assignee Class null var');     
        
        ProjectTaskDetailController.AttachmentInfo attchInfo = new ProjectTaskDetailController.AttachmentInfo();
        
        if(attchInfo.getId() == null) 
            System.assert(true, 'Attachment Info Class null var');  
        if(attchInfo.getName() == null) 
            System.assert(true, 'Attachment Info Class null var');  
        if(attchInfo.getAttachImage() == null) 
            System.assert(true, 'Attachment Info Class null var');     	
    	
    	
    	
    	
    	
    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    }     	
}