/**
*@author Juan Bessonart @ 10/07/2008
*/
public class UploadAttachmentController {
	
	// Parent Id parameter
	public String parentId = System.currentPageReference().getParameters().get('pId');
	
	//Set as Avatar
	public String asAvatar = '';
	
	// Set place witch the Form is used
	public String buttonStyle = '';
	
	// max attachment size bytes
    public final Integer MAX_SIZE = 5240000;
  	
  	// New Attachment Object
	public Attachment newAttach = new Attachment();
    public Boolean validAttSize = true;
	
	/**
	* Costructor
	*/
	public UploadAttachmentController () {
			
	}	
	
	/**
	* Set parent id for Attachment instance
	*@param String
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
	*@param Attachment
	*/
	public void setNewAttach (Attachment newAttach) {
		this.newAttach = newAttach;	
	}
	
	/**
	*@return Attachment
	*/
	public Attachment getNewAttach () {
		return newAttach;
	}
	
	/**
	* Save Attachment
	*@return PageReference
	*/
	public PageReference saveNewAttach () {
		newAttach.ParentId = parentId;
		asAvatar = System.currentPageReference().getParameters().get('asAvatar');
		
		if(newAttach.BodyLength <= MAX_SIZE){
			
			validAttSize = true;
			insert newAttach;
			
			//Update project with current avatar
			if(asAvatar.equals('true')){
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
					project.Picture__c = newAttach.Id;
					update project;
				}
			}
			
			PageReference pageRef = Page.UploadAttachment;
			pageRef.setRedirect(true);
			return pageRef;
			
		}else{
			validAttSize = false;
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