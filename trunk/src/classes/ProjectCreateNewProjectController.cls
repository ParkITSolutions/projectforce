public class ProjectCreateNewProjectController {
	
	    
    //Get id from Project item
    String param = System.currentPageReference().getParameters().get('id');
    
    // max picture size bytes
    public final Integer MAX_SIZE = 524288;
    Project2__c theProject = new Project2__c();
    String ProjectPicture = '';
    Boolean validSizePicture = true;
    public Boolean validTypePicture = true;
   	public static Boolean allowCustomer = false;
	public static Boolean allowPartner = false;  
	

	List<Group> allowCustomerActivated = new List<Group>();
	List<Group> allowPartnetActivated = new List<Group>();
	
   
    public Attachment document = new Attachment();
		
    /**
    * Constructor
    */
    public ProjectCreateNewProjectController(ApexPages.StandardController controller){
    	
    	newProfile.projectOpenOrClosed = 'open';
    	allowCustomerActivated = [ SELECT Id FROM Group WHERE Type = 'AllCustomerPortal' ];
		allowPartnetActivated = [ SELECT Id FROM Group WHERE Type = 'PRMOrganization' ];
        if (param != null){
        	
        	//Read Project
        	setProject(param);
			//Set User Permissions
        	genPermissions();
        	
        	List<GroupMember> gm = new List<GroupMember>();
			Group instance = new Group();
			String instanceName = 'projectSharing' + param;
			instance = [ SELECT Id FROM Group WHERE Name =: instanceName LIMIT 1 ];
			
			if(allowCustomerActivated.size() > 0 ){
				gm = [ SELECT Id FROM GroupMember WHERE GroupId =:instance.Id AND UserOrGroupId =: allowCustomerActivated[0].Id ];
				allowCustomer = (gm.size() > 0) ? true : false;
			}
			
			if(allowPartnetActivated.size() > 0 ){
				gm = [ SELECT Id FROM GroupMember WHERE GroupId =:instance.Id AND UserOrGroupId =: allowPartnetActivated[0].Id ];
				allowPartner = (gm.size() > 0) ? true : false;
			}
						
			String members_profile = theProject.NewMemberProfile__r.Name;
			String public_profile = theProject.PublicProfile__r.Name;
			if (public_profile == 'Public Profile') {
				newProfile.projectOpenOrClosed = 'open';
			}
			else if (members_profile == 'Member Profile') {
				newProfile.projectOpenOrClosed = 'close';
			}
			else {
				newProfile.projectOpenOrClosed = 'private';
			}
			
        	if(!userPermissions.getCanManage())
        		throw new CustomException('Insufficient Privileges');
        }
    }
    
	/**
	* Return the Namespace Prefix
	*@return String
	*/
	
	public String getNamespace () {
        return ProjectUtil.getNamespace();
    } 
	
	
	/**
	*@param Attachment
	*/
	public void setdocument (Attachment attach) {
		this.document = attach;
	}
	 
	/**
	*@return Attachment
	*/
	public Attachment getdocument () {     
		return document;
	}
    
    public Boolean getValidSizePicture(){
    	return validSizePicture;
    }
    public Boolean getValidTypePicture(){
    	return validTypePicture;
    }	
    
    /**
    * Set String param
    *@param String p
    *@void
    */
    public void setParam(String p){
    	param = p;
    }
    
    /**
    * Get Project instance
    *@return Project__c
    */
    public Project2__c getProject(){
        return theProject;
    }
    
    /**
    * Set Project
    *@param Project__c t
    */
    public void setProject(Project2__c p){
    	theProject = p;
    }
    
    /**
    * Get picture
    *@return String pic
    */
    public String getProjectPicture (){
        return projectPicture;
    }
    
    	/**
	*@param Boolean
	*/
	public static Boolean getAllowCustomerStatic(){ 
		return allowCustomer ;
	}
	/**
	*@param Boolean
	*/
	public static Boolean getAllowPartnerStatic(){ 
		return allowPartner ;
	}

	/**
	*@param Boolean
	*/
	public void setAllowCustomer( Boolean value ){
		allowCustomer = value;
	}
	/** 
	*@param Boolean
	*/
	public void setAllowPartner( Boolean value ){
		allowPartner = value;
	}
	/**
	*@return Boolean
	*/
	public Boolean getAllowCustomer(){
		return allowCustomer;
	}
	/**
	*@return Boolean 
	*/
	public Boolean getAllowPartner(){
		return allowPartner;
	} 
	/**
	*@return Boolean
	*/
	public Boolean getAllowCustomerActivated(){
		return allowCustomerActivated.size() > 0;
	}
	/**
	*@return Boolean
	*/
	public Boolean getAllowPartnerActivated(){
		return allowPartnetActivated.size() > 0;
	}	

	public UserPermissions userPermissions = null;
	
	/**
	* Load permission for cuerrent user
	*/
	public void genPermissions () {
		userPermissions = new UserPermissions();
		userPermissions.setId(UserInfo.getUserId());
		userPermissions.setProject(param);
		userPermissions.setObjectType('Project');
		userPermissions.setPermissions();		
	}
	
	public String ProjectType {get; set;}
	
    /**
    * Get Project
    *@param String Project id
    *@void
    */
   
    public void setProject (String pId){
	    
	    Map<String, Schema.SObjectField> projectFields = Schema.SObjectType.Project2__c.fields.getMap();
	    
	    String fields = '';
	    String query = 'select ';
	    
	    //Set Object Fields
	    for(Schema.SObjectField field : projectFields.values()){
	    	if(field != null)
	    		fields += (field + ', ');  	
	    }
	    
	    //Execute Dynamic SOQL
	    query += fields.substring(0, (fields.length() - 2)) + ', NewMemberProfile__r.Name,PublicProfile__r.Name from Project2__c p where Id = \'' + pId + '\'';
	    theProject = Database.query(query);
	    
	    if(theProject.Id != null){
            getProjectImage();
    		if(theProject.PublicProfile__c != null && theProject.NewMemberProfile__c != null){
	    		newProfile.newProfileOpen = theProject.NewMemberProfile__c;
	    		newProfile.publicProfileOpen = theProject.PublicProfile__c;
    		}else if (theProject.PublicProfile__c != null){
    			newProfile.publicProfileClosed = theProject.PublicProfile__c;
    		}
	    } 
    
    }
    
    
    /**
    * Project Profile Select
    *@return List<SelectOption>
    */
    public List<SelectOption> getProfiles(){
        List<ProjectProfile__c> profiles = new List<ProjectProfile__c>();
        List<SelectOption> options = new List<SelectOption>();
        profiles = [select p.Id, p.Name from ProjectProfile__c p order by p.Name asc];
        for (ProjectProfile__c tp : profiles){
            options.add(new SelectOption(tp.Id, tp.Name));
        }
        return options;
    }
        
    
    /**
    * Get Project Picture
    *@void
    */
    public void getProjectImage() {
        if(theProject.Picture__c != null) ProjectPicture = '/servlet/servlet.FileDownload?file=' + theProject.Picture__c;
    }
    

    /**
    * Class ProjectProfile
    */
    public class ProjectProfile {
    	public String publicProfileOpen { set; get; }
    	public String newProfileOpen { set; get; }
    	public String publicProfileClosed { set; get; }
    	public String projectOpenOrClosed { set; get; }     	
    }
    
    ProjectProfile newProfile = new ProjectProfile();
    
    public ProjectProfile getnewProfile(){
    	return newProfile;
    }
     public void setnewProfile(ProjectProfile pr){
    	newProfile=pr;
    }
    /**
    * Save Project
    *@return Project detail page reference
    *@throws Exception
    */    
    public void saveProject(){
    	try{	
			if(theProject.Id == null){
				insert theProject;
			}else{
	    		update theProject;	
			}
    	}catch(Exception e){
    		throw e;
    	}
    }
    
    public void saveAttachmentsAndAccess(){
    	
    	validSizePicture = true;
		validTypePicture = true; 
    	
    	if (document.name == null || document.name == '' || document.BodyLength > MAX_SIZE || 
			!(document.ContentType == 'image/jpeg' || document.ContentType == 'image/pjpeg' || document.ContentType == 'image/gif' 
			|| document.ContentType == 'image/png' || document.ContentType == 'image/x-png')){
			if (document.BodyLength > MAX_SIZE) {
				validSizePicture = false;
			}
			if (!(document.name == null || document.name == '') && !(document.ContentType == 'image/jpeg' || document.ContentType == 'image/pjpeg' || 
				document.ContentType == 'image/gif' || document.ContentType == 'image/png')) {
				validTypePicture = false;
			} 
			document = new Attachment();
			if (!validSizePicture || !validTypePicture) {
				//return null;
			}
		}
			
		if(document.name != null && document.name != ''){
    		document.ParentId = theProject.Id;
	    	insert document;
    		theProject.Picture__c = document.Id;
    		
		}	
		
		if(newProfile.projectOpenOrClosed == 'open'){
			theProject.PublicProfile__c = [ SELECT id FROM ProjectProfile__c WHERE Name =: 'Public Profile' ].id;
			theProject.Type__c = 'open';			
		}else if (newProfile.projectOpenOrClosed == 'close') {
			theProject.NewMemberProfile__c = [ SELECT id FROM ProjectProfile__c WHERE Name =: 'Member Profile' limit 1 ].id;
			theProject.PublicProfile__c = null;
			theProject.Type__c = 'close';			
		}else if (newProfile.projectOpenOrClosed == 'private'){
			theProject.Type__c = 'private';
			theProject.PublicProfile__c = null;
			theProject.NewMemberProfile__c = null;
		}	

		saveProject();	
		
		//PageReference pageRef = new PageReference('/apex/projectDetail?id=' + theProject.Id);
		//pageRef.setRedirect(true);
		//return pageRef;
    }
    
    public void save(){
    	saveProject();
    }
 
	public PageReference removeAvatar(){
		if( this.theProject != null ){
				Attachment avatar = new Attachment();
				Project2__C proj = new Project2__c();
				
				avatar = [ SELECT Id FROM Attachment WHERE Id =: this.theProject.Picture__c ];
				proj   = [ SELECT id, Picture__c FROM Project2__c    WHERE Id =: this.theProject.Id ];
				
				delete avatar;
				
				proj.Picture__c = null;
				upsert proj;
				this.theProject.Picture__c = '';
		}
		PageReference pageRef = new PageReference('/apex/ProjectCreateNew?id=' + this.theProject.Id );
		pageRef.setRedirect(true);
		return pageRef;
		
	}
	
		
}