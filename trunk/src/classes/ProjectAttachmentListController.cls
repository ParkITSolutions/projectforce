/**
*
*@author Andres Canavesi - 10/13/2009
*
*/
public with sharing class ProjectAttachmentListController {
	
	private String teamIdParam;
	
	private boolean isManager;
	
	private String projectName;
	
    private static UserPermissions userPermission = new UserPermissions();
    
    private Project2__c teamspace = new Project2__c();
	
	public ProjectAttachmentListController(){
		
		this.teamIdParam = System.currentPageReference().getParameters().get('id');
		
		this.isManager = userPermission.getCanManage();
		
	}
	
	public String  getTeamIdParam(){
		return this.teamIdParam;
	}
	
	/**
    *@return boolean 
    */
    public boolean getIsManager(){
    	return this.isManager;
    }
    
    /**
    *
    *@return String
    */
    public String getProjectName(){
		String pName;
		pName = [Select Id, Name from Project2__c where id =: teamIdParam].Name;    	
		
		if( pName.length() > 24 )
			pName = pName.substring( 0, 23 );
				
		return pName;//  .replaceAll( '\'', '&#39;' );
    }
    
     /**
    *@return UserPermission
    */
    public UserPermissions getUserPermission () {
    	genPermissions();
        return userPermission;
    }
    
     /**
    * Static function for widgets controllers use
    *@return UserPermissions instance
    */
    public static UserPermissions getUserPermissions () {
        return userPermission;
    }
	
	 /**
    * Load permission for current user
    *@return void
    */
 	public void genPermissions () {
        userPermission.setId(UserInfo.getUserId());
        userPermission.setProject(teamIdParam);
        userPermission.setObjectType('Project');
        userPermission.setPermissions();
    }
    
    /**
    * Get Teamspace
    *@return Team__c
    */
    public Project2__c getTeamspace() {
    	
         teamspace = [select name, description__c, Type__c 
         				from Project2__c
                     	where id=: teamIdParam];
                     	
         if(teamspace == null) {
            return null;
         }else {
         	 return teamspace;
         }
     }
}