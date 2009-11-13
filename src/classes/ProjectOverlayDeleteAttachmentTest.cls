@isTest private class ProjectOverlayDeleteAttachmentTest {

    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
    	System.currentPageReference().getParameters().put( 'id', GenerateEnvironmentTest.project.Id );
    
    	ProjectOverlayDeleteAttachmentController prj = new ProjectOverlayDeleteAttachmentController();
    
    	Test.stopTest();
		ProjectUtil.setIsTest( false ); 
    }
}