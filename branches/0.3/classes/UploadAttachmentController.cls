/**
*@author Juan Bessonart @ 10/07/2008
*/
public class UploadAttachmentController {
	// Parent Id parameter
	public String parentId = System.currentPageReference().getParameters().get('pId');
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
		constructMethods();		
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
	* Executes on constructor
	*/
	public void constructMethods () {
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
		if(newAttach.BodyLength <= MAX_SIZE){
			validAttSize=true;
			insert newAttach;
			PageReference pageRef = Page.UploadAttachment;
			pageRef.setRedirect(true);
			return pageRef;
		}	
		else{
			validAttSize=false;
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