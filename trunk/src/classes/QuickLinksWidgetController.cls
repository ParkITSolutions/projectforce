/*
*@author Nicolas Dominguez @ 29/01/2010
*/
public class QuickLinksWidgetController {
	
	public UserPermissions userPermission 	{ set; get; }
	public String projectId   				{ set{this.userPermission = new UserPermissions(); this.genPermissions();} get; }
	public Boolean isMember   				{ set; get; }

    /**
    * Constructor
    */
    public QuickLinksWidgetController(){
    	
		//System.debug('XXX contr UserInfo.getUserId()='+UserInfo.getUserId()+', this.projectId ='+this.projectId );
		
    }
    
    /**
    * Load permission for current user
    */
 	private void genPermissions(){
        userPermission.setId(UserInfo.getUserId());
        userPermission.setProject(this.projectId);
        userPermission.setObjectType('Project');
        userPermission.setPermissions();
        System.debug('XXX gen UserInfo.getUserId()='+UserInfo.getUserId()+', this.projectId ='+this.projectId );
        this.isMember = userPermission.isUserMemberOfProject( UserInfo.getUserId() , 'a003000000DjAKJAA3' );
    }
}