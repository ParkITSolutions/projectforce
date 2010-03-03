public with sharing class TaskPdfExportControllerTest {
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
    	
    	System.currentPageReference().getParameters().put( 'id', GenerateEnvironmentTest.project.id );
    	TaskPdfExportController pdf = new TaskPdfExportController();
    	
    	pdf.getUserPermissions();
    	pdf.setTaskId( GenerateEnvironmentTest.task.id );
    	Boolean parent = pdf.getIsTaskParent();
    	Attachment att = GenerateEnvironmentTest.avatar.clone();
    	att.ParentId = GenerateEnvironmentTest.task.id;
    	insert att;
    	pdf.getTask( GenerateEnvironmentTest.task.id );
    	
    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    }	
}