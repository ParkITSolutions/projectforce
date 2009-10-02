/**
*@author Miguel Soares @ 04/15/2009
*/
@isTest private class UploadAttachmentControllerTest {
	/**
	* Test UploadAttachmentController
	*@void
    *@static
	*/
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
    	
		System.currentPageReference().getParameters().put( 'pId', GenerateEnvironmentTest.project.id );
		UploadAttachmentController upc = new UploadAttachmentController();
		
		upc.setParentId( GenerateEnvironmentTest.project.id );
		upc.getParentId();
		
		upc.getButtonStyle();    	
		upc.getValidAttSize();    	
		upc.setNewAttach( new Attachment(Name = 'avatar', Body = Crypto.generateMac('HMacSHA1', Blob.valueOf('String'), Blob.valueOf('String'))) );    	
		upc.getNewAttach();    	
		upc.saveNewAttach();    	
		upc.cancelAttach();    
		upc.getErrorMsg();
			
    	
    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    } 
}