public class ProjectOverlayDeleteAttachmentController{
	
	private Id USERID = UserInfo.getUserId(); 
	private String idDeletes = System.currentPageReference().getParameters().get('idAttach');
	//private UserPermissions userPermissions = new UserPermissions();
	private String projectId = '';
	private String taskName='';
	
	/*
	* Constructor
	*/	
	public ProjectOverlayDeleteAttachmentController(){} 
	 
	/**
    * Generate User Permissions
    *@return void
    */ 
    public void genPermissions () {
   /*
        userPermissions.setId(UserInfo.getUserId());
        userPermissions.setProject(projectId);
        userPermissions.setObjectType('Project');
        userPermissions.setPermissions();   
     */       
    }
     
    /**
    *@return String
    */
    public String getIdDeletes () {
        return idDeletes;   
    }
    
    /** 
    *@param String sidDeletes
    *@return void
    */
    public void setIdDeletes (String sidDeletes) {
        idDeletes = sidDeletes; 
    }
     
 
    /*
    * deleteAttachment
    *@reutrn void
    */
    public void deleteAttachment(){
		System.debug('\n\n===========\nidDeletes = '+idDeletes+'\n\n');
        if (idDeletes != '' && idDeletes != null){
    	    List<Attachment> aD=[SELECT id FROM Attachment WHERE id=:idDeletes ];
			delete aD;     
        }
        idDeletes = '';
    }
}