@isTest private  class ProjectDetailAttachmentControllerTest {
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
    	
    	ProjectDetailAttachmentController d = new ProjectDetailAttachmentController();
    	
		Attachment att1 = new Attachment(Name = 'avatar', Body = Crypto.generateMac('HMacSHA1', Blob.valueOf('String'), Blob.valueOf('String')));
		Attachment att2 = new Attachment(Name = 'avatar', Body = Crypto.generateMac('HMacSHA1', Blob.valueOf('String'), Blob.valueOf('String')));
		Attachment att3 = new Attachment(Name = 'avatar', Body = Crypto.generateMac('HMacSHA1', Blob.valueOf('String'), Blob.valueOf('String')));
		Attachment att4 = new Attachment(Name = 'avatar', Body = Crypto.generateMac('HMacSHA1', Blob.valueOf('String'), Blob.valueOf('String')));
    	List<Attachment> attList = new List<Attachment>();
    	attList.add( att1 );
    	attList.add( att2 );
    	attList.add( att3 );
    	attList.add( att4 );
    	for( Attachment a : attList )
    	a.ParentId = GenerateEnvironmentTest.project.Id;
    	insert attList;
    	
    	d.setProject( GenerateEnvironmentTest.project.Id );
    	d.readAttachments();
    	
    	System.currentPageReference().getParameters().put( 'idAttach', att1.Id );
    	d.deleteAttach();
    	
    	d.getAttachments();
    	d.getAttachmentCount();
    	
    	
    	
    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    }     	
}