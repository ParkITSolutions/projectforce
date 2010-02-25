/*
*@author Nicolas Dominguez @ 29/01/2010
*/
public class QuickLinksWidgetController {
    
    public String projectId;
    public UserPermissions userPermission   { set; get; }
    public Boolean canView                 { set; get; }

    /**
    * Constructor
    */
    public QuickLinksWidgetController(){
    }
    
    /**
    * Load permission for current user
    */
    private void genPermissions(){
        userPermission.setId(UserInfo.getUserId());
        userPermission.setProject(this.projectId);
        userPermission.setObjectType('Project');
        userPermission.setPermissions();
        this.canView = userPermission.isUserMemberOfProject( UserInfo.getUserId() , this.projectId ) || userPermission.getCanManage();
    }
    
    public void setProjectId( String value ){
		//To pass bug of apex
		this.projectId 		= value;
		this.userPermission = new UserPermissions(); 
		this.genPermissions();
	}
	
	public String getProjectId(){
		return this.projectId;
	}
}