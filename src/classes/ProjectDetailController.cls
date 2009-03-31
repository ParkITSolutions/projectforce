/**
*@author Bruno Fagundez @ 06/09/2008
*/public with sharing class ProjectDetailController 
{
    
    Project2__c teamspace = new Project2__c();
    public Boolean isLastMemberAdmin = false;
    boolean noImage; 
    boolean emailTeamspace;
    String  error = '';
    boolean showError = false;
   	private Boolean isMember;
	private Boolean isPublic;
    public ProjectMembersListController pmc = new ProjectMembersListController(); 
    public static UserPermissions userPermission = new UserPermissions();
    private String projectType = '';	
    String teamIdParam = System.currentPageReference().getParameters().get('id'); 
    
    /**
    * Constructor
    */
    public ProjectDetailController(){
        if(teamIdParam != null)
            getTeamDetail();
            genTeamData();        
        //genPermissions();
        this.projectType = getTeamspace().Type__c;
    }   
    
    /**
    *@param String team id
    */
    public void setTeamIdParam (String idTeam){ 
        teamIdParam = idTeam;
    }
    
    /**
    * @return String teamIdParam The Id of the team
    */
    public String getTeamIdParam(){
        return teamIdParam;
    }    
    
    /**
    * Check if is TeamsSuscription page
    *@return Boolean 
    */
    public Boolean getInTeamSubscription () {
        String currentPageUrl = System.currentPageReference().getUrl();
        return (currentPageUrl != null && currentPageUrl.indexOf('TeamsSubscription') != -1);
    } 
    
    public String USERID =  UserInfo.getUserId();
    
    //public UserPermissions userPermissionsTeam = new UserPermissions();
    
    //public UserPermissions userPermissionsWiki = new UserPermissions();
    
    /**
    *@return UserPermission
    */
    //public UserPermissions getUserPermissionsWiki () {
    //  return userPermissionsWiki;
    //}
    
    /**
    * Load permission for current user
    */
    /*
    public void genPermissions () {
        userPermission.setId(UserInfo.getUserId());
        userPermission.setTeam(teamIdParam);
        userPermission.setObjectType('Wiki');
        userPermission.setPermissions();
        userPermissionsWiki = userPermission;
        
        userPermissionsTeam.setId(UserInfo.getUserId());
        userPermissionsTeam.setTeam(teamIdParam);
        userPermissionsTeam.setObjectType('Team');
        userPermissionsTeam.setPermissions();                   
    }
    */
    
    /**
    *@return UserPermission
    */
    /*
    public UserPermissions getUserPermission () {
        return userPermission;
    }   
    */
    
    /**
    * Read Team
    *@throws Exception
    */
    public void getTeamDetail(){
        try {
            teamspace = [Select  
                            //t.SystemModstamp, 
                            t.OwnerId, t.Name,                      
                            t.LastModifiedDate,
                            t.LastModifiedById, 
                            //t.NewMemberProfile__c,
                            //t.PublicProfile__c,
                            t.IsDeleted,
                            t.Id, 
                            t.Description__c, 
                            t.CreatedDate, 
                            t.CreatedById,
                            t.Type__c
                            from Project2__c t 
                            where id =: teamIdParam];
            
        } catch(Exception e ){
            throw e;
        }   
    }
    
     /**
    * Show join event
    *@return Boolean
    */
  	public void genTeamData(){
		if(teamIdParam != null){
			this.teamspace = [select Id, Name, PublicProfile__c from Project2__c where id =: teamIdParam limit 1];
			if(teamspace.PublicProfile__c != null){
				this.setIsPublic(true);
   			}else {
				this.setIsPublic(false);
   			}
   			
			List<ProjectMember__c> member = [select Id, User__c from ProjectMember__c where Project__c =: teamIdParam and User__c =: UserInfo.getUserId() limit 1];
			if(member.size() > 0){
				this.setIsMember(true);
			}else {
				this.setIsMember(false);
			}
		}
	}
	public void setIsPublic(Boolean isp){
		this.isPublic = isp;
	}
	public void setIsMember(Boolean ism){
		this.isMember = ism;
	}
	public boolean getIsPublic(){
		return this.isPublic;
	}
	public boolean getIsMember(){
		return this.isMember;	
	}
    
    /**
    * For show join button
    *@void
    */
   
    
    /**
    * Join Team
    */

    
    public void joinProject(){
		pmc.setProjectId(System.currentPageReference().getParameters().get('id'));
		pmc.joinProject();
		isMember = true;
	}
	public PageReference unjoinProject(){
		pmc.setProjectId(System.currentPageReference().getParameters().get('id'));
		if(!pmc.isLastMemberAdmin()){
			pmc.unjoinProject();
			isMember = false;
			isLastMemberAdmin = false;			
			if( this.projectType == 'private'  )
				return this.projectRedirect();
		}else{
			isLastMemberAdmin = true;
		}	
		return null;
	}
	public PageReference projectRedirect(){
		PageReference discOver = Page.projectOverview;
		return discOver;
	}
    
    
    /**
    * Perform the remove from the team
    *@throws Exception
    */      
   
    /**
    * Get Teamspace
    *@return Team__c
    */
    public Project2__c getTeamspace() {
         teamspace = [select name, description__c, Type__c from Project2__c
                     where id=: teamIdParam];
         if(teamspace == null) {
            return null;
         }else {
            return teamspace;
         }
    }
    
    /**
    * Get Teamspace image
    *@return String
    */
    public String getTeamspaceImage() {
    
        List<Project2__c> teamAvatar = [select Picture__c
                                        from Project2__c
                                        where Id =:System.currentPageReference().getParameters().get('id')];
        if(teamAvatar.size() == 0) 
            return '';
        return '/servlet/servlet.FileDownload?file=' + teamAvatar[0].Picture__c;
    }  
    
 
    /**
    * Refresh wiki list for widgets
    *@void
    */
    public void refreshWikis () {}
    
    public static ProjectTask__c taskT;

}