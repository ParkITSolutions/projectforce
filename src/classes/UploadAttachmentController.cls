/**
*@author Juan Bessonart @ 10/07/2008
*/
public class UploadAttachmentController {
	
	// Parent Id parameter
	public String parentId = System.currentPageReference().getParameters().get('pId');
	
	// Set as Avatar
	public String asAvatar = '';
	
	// Set place witch the Form is used
	public String buttonStyle = '';
	
	// max attachment size bytes
    //public final Integer MAX_SIZE = 5240000;
    public final Integer MAX_SIZE = 131072; // 128Kb
    
    public Set<String> imagesTypes = new Set<String> {'image/jpeg', 'image/pjpeg', 'image/png', 'image/x-png', 'image/gif'};
  	
  	// New Attachment Object
	public Attachment newAttach = new Attachment();
    public Boolean validAttSize = true;
    
    // Error message
    public String errorMsg = '';
	 
	/**
	* Constructor
	*/
	public UploadAttachmentController () {
			
	}	
	
	/**
	* Set parent id for Attachment instance
	*@param String parentId
	*@return void
	*/
	public void setParentId (String parentId) {
		this.parentId = parentId;
	}
	
	/**
	*@return String
	*/
	public String getParentId () {
		return parentId;
	}

	/**
	* Get place witch the Form is used
	*@return String
	*/
	public String getButtonStyle () {
		return buttonStyle;
	}
	
	/**
	*@return Boolean
	*/
	public Boolean getValidAttSize(){
		return validAttSize;
	}	
	
	/**
	*@param Attachment newAttach
	*@return void
	*/
	public void setNewAttach (Attachment newAttach) {
		if(this.newAttach != null)
		this.newAttach = new Attachment();
		
		this.newAttach = newAttach;	
	}
	
	/**
	*@return Attachment
	*/
	public Attachment getNewAttach () {
		return newAttach;
	}
	
	/**
	* returns error message
	*@return String
	*/
	public String getErrorMsg () {
		return errorMsg;
	}
	
	/**
	* Save Attachment
	*@return PageReference
	*/
	public pageReference saveNewAttach () {
		
		newAttach.ParentId = parentId;
		System.debug('\n\n======================\n'+newAttach.BodyLength);
		asAvatar = System.currentPageReference().getParameters().get('asAvatar');
		if(newAttach.BodyLength <= MAX_SIZE){
			validAttSize = true;
			
			System.debug('\n\n======================\n'+newAttach.BodyLength+' <= '+MAX_SIZE);
			
			//Update project with current avatar
			if(asAvatar.equals('true') && imagesTypes.contains(newAttach.ContentType) && newAttach.name.length() < 71){
				if(parentId != null){
					//Read Project
					Project2__c project = [select p.Id, p.Picture__c from Project2__c p where p.Id =: parentId];
					
					//Read old avatar and delete it.
					if(project.Picture__c != null){
						List<Attachment> avatar = new List<Attachment>(); 
						avatar = [select a.Id from Attachment a where a.Id =: project.Picture__c];
						if(avatar.size() > 0)
							delete avatar[0];
					}
					//Update project with new avatar
					insert newAttach;
					project.Picture__c = newAttach.Id;
					update project;
				}
			}else if (asAvatar.equals('true') && newAttach.name.length() > 70){
				errorMsg = '<b>Error:</b> The length of the attachment name must be less than 64.';
				System.debug('\n\n=====\n'+errorMsg);
				validAttSize = false;
				//return null;				
			}else if (asAvatar.equals('true')){
				errorMsg = '<b>Error:</b> Please select an image file. Valid format: .jpeg, .pjpeg, .png, .x-png, .gif';
				System.debug('\n\n=====\n'+errorMsg);
				validAttSize = false;
				//return null;				
			}else{
				insert newAttach;
			}
			this.newAttach = new Attachment();
			this.newAttach.body = null;
			this.parentId = null;
			PageReference pageRef = Page.UploadAttachment;
			pageRef.setRedirect(true);
			return pageRef;
			
		}else{ 
			System.debug('\n\n======================\n trace (1)');
			if(newAttach.BodyLength < 1 || newAttach.BodyLength == null){ 
				System.debug('\n\n======================\n trace (2)');
				errorMsg = '<b>Error:</b> Please select the file you want upload. Attachment size must be less than 128 KB.';
				validAttSize = false; 
			}
			
			if (newAttach.BodyLength > MAX_SIZE) {
				System.debug('\n\n======================\n trace (4)');
				errorMsg = '<b>Error:</b> Attachment size must be less than 128 KB.';
				validAttSize = false; 	
			}	
			
			this.newAttach = new Attachment();
			this.newAttach.body = null;
			
			return null;
		}		
		
	}
	
	/**
	* Cancel upload
	*@return PageReference
	*/
	public PageReference cancelAttach () {
		PageReference pageRef = Page.UploadAttachment;
		pageRef.setRedirect(true);
		return pageRef;
	} 
}