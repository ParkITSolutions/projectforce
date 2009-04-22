@isTest private class ProjectCreateNewProjectControllerTest {

    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
    	
    	System.currentPageReference().getParameters().put( 'id', GenerateEnvironmentTest.project.id );
    	ProjectCreateNewProjectController pNew = new ProjectCreateNewProjectController();
    	
    	// Setters    	
		pNew.setParam( GenerateEnvironmentTest.project.id );
		pNew.setDocument( new Attachment(Name = 'Name', Body = Crypto.generateMac('HMacSHA1', Blob.valueOf('String'), Blob.valueOf('String'))));
		pNew.setProject( GenerateEnvironmentTest.project.id );
		pNew.setProject( GenerateEnvironmentTest.project );
		pNew.setAllowCustomer( true );
		pNew.setAllowPartner( true );
		//pNew.();
		
		//   Save methods
		ProjectCreateNewProjectController.ProjectProfile pf = new ProjectCreateNewProjectController.ProjectProfile();
		pNew.newProfile.projectOpenOrClosed = 'open';
		pNew.saveAttachmentsAndAccess();
		pNew.newProfile.projectOpenOrClosed = 'close';
		pNew.saveAttachmentsAndAccess();
		pNew.newProfile.projectOpenOrClosed = 'privte';
		pNew.saveAttachmentsAndAccess();
		pNew.save();
		
		pNew.removeAvatar();
		
		
		// Getters
		ProjectCreateNewProjectController.getAllowCustomerStatic();
		ProjectCreateNewProjectController.getAllowPartnerStatic();
		pNew.getNamespace();
		pNew.getdocument();
		pNew.getValidSizePicture();
		pNew.getValidTypePicture();
		pNew.getProject();
		pNew.getProjectPicture();
		pNew.getAllowCustomer();
		pNew.getAllowPartner();
		pNew.getAllowCustomerActivated();
		pNew.getAllowPartnerActivated();
		pNew.getProfiles();
		pNew.getProjectImage();


		// Delete and insert all profiles
		List<ProjectProfile__c> pp = new List<ProjectProfile__c>();
		pp = [ SELECT Id FROM ProjectProfile__c ];
		if( pp.size() > 0 )
		delete pp;
		pNew.genProfiles();
    	
    	
    	
    	
    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    } 
}