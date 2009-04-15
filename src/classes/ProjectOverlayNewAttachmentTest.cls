@isTest private class ProjectOverlayNewAttachmentTest {
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
    	
    	ProjectOverlayNewAttachmentController po = new ProjectOverlayNewAttachmentController();
    	
    	po.setParentId( GenerateEnvironmentTest.project.Id );
    	po.getParentId();
    	
    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    }     	
}