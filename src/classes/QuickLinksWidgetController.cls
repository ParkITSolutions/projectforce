/*
*@author Nicolas Dominguez @ 29/01/2010
*/
public class QuickLinksWidgetController {
	
	public String idProject   				{ set; get; }
	public UserPermissions userPermission 	{ set; get; }
	

    /**
    * Constructor
    */
    public QuickLinksWidgetController(){
    	
    	this.userPermission = new UserPermissions();
		this.idProject 		= System.currentPageReference().getParameters().get( 'id' );
		
		this.genPermissions();
    }
    
    /**
    * Load permission for current user
    */
 	private void genPermissions(){
 		
        userPermission.setId(UserInfo.getUserId());
        userPermission.setProject(idProject);
        userPermission.setObjectType('Project');
        userPermission.setPermissions();
    }
}