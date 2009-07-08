/**
*@author Miguel Soares @ 03/17/2009
*/
public with sharing class ProjectDetailController
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
    private String projectType = '';	
    String teamIdParam = System.currentPageReference().getParameters().get('id');
    public boolean isManager = false;
    public String USERID =  UserInfo.getUserId();
    
    public static ProjectTask__c taskT;
    public static UserPermissions userPermission = new UserPermissions();
    
    /**
    * Constructor
    */
    public ProjectDetailController(ApexPages.StandardController ctrl){
       genPermissions();   	   
   	   getTeamDetail();
       genTeamData();
       this.isManager = userPermission.getCanManage();
       this.projectType = getTeamspace().Type__c;
    }   
    
    /**
    * Empty Constructor
    */
    public ProjectDetailController (){
    
    }
    
    /**
    *@return isLastMemberAdmin
    */
    public Boolean getIsLastMemberAdmin(){
    	return this.isLastMemberAdmin;
   	}
   	
   	 /**
    *@return UserPermission
    */
    public UserPermissions getUserPermission () {
    	genPermissions();
        return userPermission;
    }

    /**
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
    *@return boolean IsManager
    */
    public boolean getIsManager(){
    	return this.isManager;
    }  

    /**
    *@param String team id
    */
    public void setTeamIdParam (String idTeam){ 
        this.teamIdParam = idTeam;
    }
    
    /**
    * @return String teamIdParam The Id of the team
    */
    public String getTeamIdParam(){
        return this.teamIdParam;
    } 
    
    /**
    *@param Boolean isp
    * @return void
    */	
	public void setIsPublic(Boolean isp){
		this.isPublic = isp;
	}
	
	/**
    *@param Boolean ism
    * @return void
    */	
	public void setIsMember(Boolean ism){
		this.isMember = ism;
	}
	
	/**
    * @return boolean isPublic
    */
	public boolean getIsPublic(){
		return this.isPublic;
	}
	
	/**
    * @return boolean isMember
    */	
	public boolean getIsMember(){
		//Read project data first to load any changes.
		genTeamData();
		return this.isMember;	
	}
       
    /**
    * Check if is TeamsSuscription page
    *@return Boolean 
    */
    public Boolean getInTeamSubscription () {
        String currentPageUrl = System.currentPageReference().getUrl();
        return (currentPageUrl != null && currentPageUrl.indexOf('TeamsSubscription') != -1);
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
    * Read Team
    *@throws Exception
    */
    public void getTeamDetail(){
        try {
           	teamspace = [Select t.OwnerId, t.Name, t.LastModifiedDate, t.LastModifiedById, 
           					t.IsDeleted, t.Id, t.Description__c, t.CreatedDate, t.CreatedById, t.Type__c 
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
		if(this.teamIdParam != null){
			this.teamspace = [select Id, Name, PublicProfile__c 
								from Project2__c 
								where id =: teamIdParam 
								limit 1];
			if(teamspace.PublicProfile__c != null){
				this.setIsPublic(true);
			}else if (userPermission.getCanManage()){
				this.setIsPublic(true);
   			}else {
				this.setIsPublic(false);
   			}
   			
			List<ProjectMember__c> member = [select Id, User__c 
												from ProjectMember__c 
												where Project__c =: teamIdParam and User__c =: UserInfo.getUserId() 
												limit 1];
			if(member.size() > 0){
				this.setIsMember(true);
			}else {
				this.setIsMember(false);
			}
		}
	}

    /**
    * Join Project
    *@return void
    */
    public void joinProject(){
		pmc.setProjectId(System.currentPageReference().getParameters().get('id'));
		pmc.joinProject();
		genPermissions();
		isMember = true;
	}
	
	/**
	* Unjoin Project
	*@return PageReference
	*/
	public PageReference unjoinProject(){
		pmc.setProjectId(System.currentPageReference().getParameters().get('id'));
		if(!pmc.isLastMemberAdmin()){
			
			pmc.unjoinProject();
			this.isMember = false;
			
			genPermissions();
			this.isLastMemberAdmin = false;			

			if( this.projectType == 'private'  )
				return this.projectRedirect();

		}else{
			genPermissions();
			this.isLastMemberAdmin = true;
		}
	
		return null;
	}

	/**
	* Redirect to ProjectOverview
	*@return PageReference
	*/
	public PageReference projectRedirect(){
		PageReference discOver = Page.projectOverview;
		return discOver;
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
    * Static function for widgets controllers use
    *@return UserPermissions instance
    */
    public static UserPermissions getUserPermissions () {
        return userPermission;
    }
}