public class ProjectOverlayDeleteAssigneeController {
	
	private Id USERID = UserInfo.getUserId(); 
	private String idDeletes = '';
	private UserPermissions userPermissions = new UserPermissions();
	private String projectId = '';
	private String taskName='';
	
		
	public ProjectOverlayDeleteAssigneeController(){} 
	 
	/**
    * Generate User Permissions
    *@void
    */ 
    public void genPermissions () {
        userPermissions.setId(UserInfo.getUserId());
        userPermissions.setProject(projectId);
        userPermissions.setObjectType('Project');
        userPermissions.setPermissions();   
            
    }
     
    /**
    *@return idDeletes
    */
    public String getIdDeletes () {
        return idDeletes;   
    }
    
    /** 
    *@param sidDeletes
    */
    public void setIdDeletes (String sidDeletes) {
        idDeletes = sidDeletes; 
    }
     

    /** deleteAssignee
    *@void
    */
    public void deleteAssignee(){

        if (idDeletes != '' && idDeletes != null){
    	    List<ProjectAssignee__c> aD=[SELECT id FROM ProjectAssignee__c WHERE id=:idDeletes ];
			delete aD;     
        }
        idDeletes = '';
    }
    

}