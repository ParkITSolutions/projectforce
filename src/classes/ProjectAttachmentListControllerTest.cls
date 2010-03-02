/**
* @author Matias Menafra
* @createdDate 02/02/2010
*/
@isTest private class ProjectAttachmentListControllerTest {
    
    /*
    * Test Project Attachment List Controller
    */
    public static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
    	
    	System.currentPageReference().getParameters().put( 'id', GenerateEnvironmentTest.project.Id );
    	ProjectAttachmentListController prjAtt = new ProjectAttachmentListController();
    	
		prjAtt.loadAttachmentList();
		String prjName = prjAtt.getProjectName();
    	UserPermissions permissions = prjAtt.getUserPermission();
    	permissions = prjAtt.getUserPermissions();
    	prjAtt.genPermissions();
    	
    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    }     	
}