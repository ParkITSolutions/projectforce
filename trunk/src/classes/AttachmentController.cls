/**
* @author Miguel Soares
*/
public with Sharing class AttachmentController{  
	
	 
	private final Integer MAX_SIZE = 131072; // 128Kb
	private final Integer MAX_LENGTH_NAME = 71;
	private final String  ERROR_NO_FILE   = 'Please select a file to upload.';
	private final String  ERROR_IMG_TYPE  = 'The image must be .jpg, .gif or .png';	
	private final String  ERROR_BIN_TYPE  = 'Binary type are not allowed.';	
	private final String  ERROR_SIZE_FILE = 'Maximum size is 128 KB';
	
	private Set<String> imagesTypes 		= new Set<String> {'image/jpeg', 'image/pjpeg', 'image/png', 'image/x-png', 'image/gif'};
	private Set<String> notAllowedTypes 	= new Set<String> {'application/octet-stream'};
	
	public Boolean      isProduction 		{ set; get; }  
	public String		parentId 	 		{ set; get; }
	public String 		error 				{ set; get; }
	public Attachment 	newAttach 			{ set; get; }
	public Boolean		endAction			{ set; get; }
	public String 		typeOfAttachment 	{ set; get; }
	public String		currentPage			{ set; get; }
	public String 		postAction 			{ set; get; }
	public String		avatarTypeFlag		{ set; get; }
	
	/**
	* Class constructor
	*/ 
	public AttachmentController(){
		
		this.isProduction	= ProjectUtil.isProduction;
		this.parentId 		= System.currentPageReference().getParameters().get( 'Id' );
     
		this.newAttach = new Attachment();
		this.location(); 
	}
	
	/**
	* Uploads the file
	* @return UploadAttachment
	*/
	public PageReference action(){
		
		this.parentId = System.currentPageReference().getParameters().get( 'pid' );
		this.typeOfAttachment = this.avatarTypeFlag;
		this.cleanErrors();
		
		if( this.allValidations() ){ 
			
			if( this.currentPage == 'taskdetail' ){
				Task t = new Task();
				t.id = this.parentId;
				t.addAttachment( newAttach );
			}else if( this.currentPage == 'projectdetail' ){
				Project p = new Project( this.parentId );
				
				if( this.typeOfAttachment == 'avatar')
					p.setAvatar( newAttach );
				else
					p.addAttachment( newAttach );
					
			}else if( this.currentPage == 'attachmentlist' ){
				newAttach.parentId = this.parentId;
				//TODO Move insert to DAOattachments
				insert newAttach;
			} 
		
		}else{
			this.parentId = null;
		}
		
		this.newAttach = new Attachment();
		this.endAction 			= true;
		this.typeOfAttachment 	= ''; 
		this.avatarTypeFlag 	= '';
		
		return Page.UploadAttachment;
	}

	/**
	* Checks if file is empty. Return the error as string
	* @return error 
	*/
	private String checkEmptyValue(){
		this.error = newAttach.body != null ? '' : ERROR_NO_FILE;
		return this.error;
	}
	
	/**
	* Checks the type of file. Returns the error as string
	* @return error 
	*/
	private String  checkOnlyImgExtensions(){
		this.error = this.imagesTypes.contains( newAttach.ContentType ) ? '' : ERROR_IMG_TYPE;
		return this.error;
	} 

	/**
	* Checks if the type of file is binary. Returns the error as string
	* @return error 
	*/
	private String  checkBinType(){
		this.error = this.notAllowedTypes.contains( newAttach.ContentType ) ? ERROR_BIN_TYPE : '';
		return this.error;
	} 
	
	/**
	* Checks maximum size of file. Returns the error as string
	* @return error 
	*/
	private String checkSize(){
		this.error = newAttach.BodyLength <= MAX_SIZE ? '' : ERROR_SIZE_FILE;
		return this.error;
	}
	
	/**
	* Runs all validation code
	* @return Boolean
	*/
	private Boolean allValidations(){
		if( this.checkEmptyValue() == '' && this.checkSize() == '' ){	
			// As avatar
			if( this.typeOfAttachment == 'avatar' ){
				this.checkOnlyImgExtensions();
			}else{
				this.checkBinType();
			}
			
		}
		return this.error == ''; 
	}
	
	/**
	* Clears all errors variables
	*/
	private void cleanErrors(){
		this.error = '';
	}
	
	/**
	* Sets location for each page where Overlay is included
	*/
	private void location(){
		
		String url = ApexPages.currentPage().getUrl().toLowerCase();
		if( url.contains( 'taskdetail' ) ){
			this.postAction 	= 'detailListPanel';
			this.currentPage 	= 'taskdetail';
		}else if( url.contains( 'projectdetail' ) ){
			this.currentPage 	= 'projectdetail';
			this.postAction 	= 'reloadMainContent';
		}else if( url.contains( 'attachmentlist' ) ){
			this.currentPage 	= 'attachmentlist';
			this.postAction 	= 'ReloadAttachmentList';
		}
	}
	
	/**
    * Test Attachment Controller
    */
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
		Attachment uploadTest = new Attachment( Name = 'avatar', Body = Crypto.generateMac( 'HMacSHA1', Blob.valueOf( 'String' ), Blob.valueOf( 'String' ) ), ContentType = 'image/png' );
		
		Test.setCurrentPageReference( new PageReference( 'Page.ProjectDetail' ) );
		System.currentPageReference().getParameters().put( 'Id', GenerateEnvironmentTest.project.id );
		System.currentPageReference().getParameters().put( 'pid', GenerateEnvironmentTest.project.id );
		
		AttachmentController attController = new AttachmentController();
		uploadTest.parentId 	= GenerateEnvironmentTest.project.Id;
		attController.newAttach = uploadTest;
		attController.action();
		
		uploadTest = new Attachment( Name = 'avatar', Body = Crypto.generateMac( 'HMacSHA1', Blob.valueOf( 'String' ), Blob.valueOf( 'String' ) ), ContentType = 'image/png' );
		attController = new AttachmentController();
		uploadTest.parentId 	= GenerateEnvironmentTest.project.Id;
		attController.newAttach = uploadTest;
		attController.avatarTypeFlag = 'avatar';
		attController.action();
		
    	Test.stopTest();
		ProjectUtil.setIsTest( false );    	
    }
    
	/**
    * Test Attachment Controller
    */
    static testMethod void myUnitTest2(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
		Attachment uploadTest = new Attachment( Name = 'avatar', Body = Crypto.generateMac( 'HMacSHA1', Blob.valueOf( 'String' ), Blob.valueOf( 'String' ) ), ContentType = 'image/png' );
		
		Test.setCurrentPageReference( new PageReference( 'Page.taskdetail' ) );
		System.currentPageReference().getParameters().put( 'Id', GenerateEnvironmentTest.project.id );
		System.currentPageReference().getParameters().put( 'pid', GenerateEnvironmentTest.project.id );
		
		AttachmentController attController = new AttachmentController();
		uploadTest.parentId 	= GenerateEnvironmentTest.project.Id;
		attController.newAttach = uploadTest;
		attController.action();
		
    	Test.stopTest();
		ProjectUtil.setIsTest( false );    	
    }

	/**
    * Test Attachment Controller
    */
    static testMethod void myUnitTest3(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
    	
		Attachment uploadTest = new Attachment( Name = 'avatar', Body = Crypto.generateMac( 'HMacSHA1', Blob.valueOf( 'String' ), Blob.valueOf( 'String' ) ), ContentType = 'image/png' );
		uploadTest.ParentId = GenerateEnvironmentTest.project.id;
		insert uploadTest;
		
		Test.setCurrentPageReference( new PageReference( 'Page.attachmentlist' ) );
		System.currentPageReference().getParameters().put( 'Id', GenerateEnvironmentTest.project.id );
		System.currentPageReference().getParameters().put( 'pid', GenerateEnvironmentTest.project.id );
		
		AttachmentController attController = new AttachmentController();
		//uploadTest.parentId = GenerateEnvironmentTest.project.Id;
		//attController.newAttach = uploadTest;
		attController.avatarTypeFlag = 'avatar';
		attController.newAttach = GenerateEnvironmentTest.avatar;
		attController.action();
		
    	Test.stopTest();
		ProjectUtil.setIsTest( false );    	
    }

}