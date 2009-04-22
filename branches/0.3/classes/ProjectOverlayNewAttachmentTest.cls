/**
*@author Miguel Soares @ 04/14/2009
*/
@isTest private class ProjectOverlayNewAttachmentTest {
	
	/**
	* Test ProjectOverlayNewAttachment
	*/
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