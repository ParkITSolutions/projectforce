/**
*@author Miguel Soares - 04/08/2009
*/
@isTest private  class ProjectDetailAttachmentControllerTest {
	
	/**
	* Test ProjectDetailAttachmentController
	*@void
    *@static
	*/
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
    	
    	ProjectDetailAttachmentController d = new ProjectDetailAttachmentController();
    	
		Attachment att1 = new Attachment(Name = 'avatar.rar', ContentType = null,           Body = Crypto.generateMac('HMacSHA1', Blob.valueOf('String'), Blob.valueOf('String')));
		Attachment att2 = new Attachment(Name = 'avatar',     ContentType = null,           Body = Crypto.generateMac('HMacSHA1', Blob.valueOf('String'), Blob.valueOf('String')));
		Attachment att3 = new Attachment(Name = 'avatar',     ContentType = 'image/jpeg',   Body = Crypto.generateMac('HMacSHA1', Blob.valueOf('String'), Blob.valueOf('String')));
		Attachment att4 = new Attachment(Name = 'avatar',     ContentType = 'generic',      Body = Crypto.generateMac('HMacSHA1', Blob.valueOf('String'), Blob.valueOf('String')));
    	List<Attachment> attList = new List<Attachment>();
    	attList.add( att1 );
    	attList.add( att2 );
    	attList.add( att3 );
    	attList.add( att4 );
    	for( Attachment a : attList )
    	a.ParentId = GenerateEnvironmentTest.project.Id;
    	insert attList;
    	
    	d.setProject( GenerateEnvironmentTest.project.Id );
    	d.getProject();
    	d.genPermissions();
    	d.getUserPermissions();
    	d.readAttachments();
    	
    	System.currentPageReference().getParameters().put( 'idAttach', att1.Id );
    	d.deleteAttach();
    	
    	d.getAttachments();
    	d.getAttachmentCount();
    	
    	ProjectDetailAttachmentController.AttachmentInfo aInf = new ProjectDetailAttachmentController.AttachmentInfo();
    	aInf.setId( att1.id );
    	aInf.setName( att1.Name );
    	aInf.setAttachImage( 'Image' );
    	aInf.setAttachment( att1 );
    	aInf.setIsOwner( false );

    	aInf.getIsOwner();
    	aInf.getAttachment();
    	aInf.getAttachImage();
    	aInf.getName();
    	aInf.getId();
    	
    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    }     	
}