/**
* Author Miguel Soares
*/
public class AttachmentController { 
	  
	private final Integer MAX_SIZE = 131072; // 128Kb
	private final Integer MAX_LENGTH_NAME = 71;
	private final String  ERROR_NO_FILE   = 'Please select a file to upload.';
	private final String  ERROR_IMG_TYPE  = 'The image must be .jpg, .gif or .png';	
	private final String  ERROR_SIZE_FILE = 'Maximum size is 120 KB';
	
	private Set<String> imagesTypes = new Set<String> {'image/jpeg', 'image/pjpeg', 'image/png', 'image/x-png', 'image/gif'};
	  
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
		
		this.parentId = System.currentPageReference().getParameters().get( 'Id' );
    
		this.newAttach = new Attachment();
		this.location(); 
	}
	
	
	/**
	* Uploads the file
	*/
	public PageReference action(){
		
		this.parentId = System.currentPageReference().getParameters().get( 'pid' );
		this.typeOfAttachment = this.avatarTypeFlag;//System.currentPageReference().getParameters().get( 'avatar' );
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
				else{
					p.addAttachment( newAttach );
				}
					
			}else if( this.currentPage == 'attachmentlist' ){
				newAttach.parentId = this.parentId;
				insert newAttach;
			} 
		
		}else{
			this.parentId = null;
		}
		
	System.debug('2[[[>>>>]]] ' + this.currentPage);
		this.newAttach = new Attachment();
		this.endAction = true;
		
		return Page.UploadAttachment;
	}

	/**
	* Checks if file is empty. Return the error as string
	* @return String 
	*/
	private String checkEmptyValue(){
		this.error = newAttach.body != null ? '' : ERROR_NO_FILE;
		return this.error;
	}
	
	/**
	* Checks the type of file. Returns the error as string
	* @return String 
	*/
	private String  checkOnlyImgExtensions(){
		this.error = this.imagesTypes.contains( newAttach.ContentType ) ? '' : ERROR_IMG_TYPE;
		return this.error;
	} 
	
	/**
	* Checks maximum size of file. Returns the error as string
	* @return String 
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
			if( this.typeOfAttachment == 'avatar' )
				this.checkOnlyImgExtensions();
			
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
		
		if( url.contains( 'taskdetail' )){
			this.postAction = 'detailListPanel';
			this.currentPage = 'taskdetail';
		}else if( url.contains( 'projectdetail' )){
			this.currentPage = 'projectdetail';
			this.postAction = 'reloadMainContent';
		}else if( url.contains( 'projectattachmentlist' )){
			this.currentPage = 'attachmentlist';
			this.postAction = 'ReloadAttachmentList';
		}
	}
}