@isTest private class ProjectAttachmentListControllerTest {
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
    	System.currentPageReference().getParameters().put( 'id', GenerateEnvironmentTest.project.Id );
    	
    	ProjectAttachmentListController prjAtt = new ProjectAttachmentListController();
    	
    	prjAtt.getTeamIdParam();
    	prjAtt.getIsManager();
    	prjAtt.getProjectName();
    	prjAtt.getUserPermission();
    	ProjectAttachmentListController.getUserPermissions();
    	prjAtt.genPermissions();
    	prjAtt.getTeamspace();
    	
    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    }     	
}