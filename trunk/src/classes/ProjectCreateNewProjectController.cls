public class ProjectCreateNewProjectController {
	
	    
    //Get id from Project item
    String param = System.currentPageReference().getParameters().get('id');
    
    // max picture size bytes
    public final Integer MAX_SIZE = 524288;
    
    Project2__c theProject = new Project2__c();
    String ProjectPicture = '';
    Boolean validSizePicture = true;
   	public static Boolean allowCustomer = true;//false;
	public static Boolean allowPartner = true;//false;  

	List<Group> allowCustomerActivated = new List<Group>();
	List<Group> allowPartnetActivated = new List<Group>();
	
   
    public Attachment document = new Attachment();
		
    /**
    * Constructor
    */
    public ProjectCreateNewProjectController(){
        if (param != null){
        	setProject(param);
        	genPermissions();
        	List<GroupMember> gm = new List<GroupMember>();
			Group instance = new Group();
			String instanceName = 'projectSharing' + param;
			if(allowCustomerActivated.size() > 0 ){
				instance = [ SELECT Id FROM Group WHERE Name =: instanceName LIMIT 1 ];
				gm = [ SELECT Id FROM GroupMember WHERE GroupId =: instance.Id AND UserOrGroupId =: allowCustomerActivated[0].Id ];
				ProjectCreateNewProjectController.allowCustomer = (gm.size() > 0) ? true : false;
			}
			if(allowPartnetActivated.size() > 0 ){
				instance = [ SELECT Id FROM Group WHERE Name =: instanceName LIMIT 1 ];
				gm = [ SELECT Id FROM GroupMember WHERE GroupId =: instance.Id AND UserOrGroupId =: allowPartnetActivated[0].Id ];
				ProjectCreateNewProjectController.allowPartner = (gm.size() > 0) ? true : false;
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
		ProjectCreateNewProjectController.allowCustomer = value;
	}
	/** 
	*@param Boolean
	*/
	public void setAllowPartner( Boolean value ){
		ProjectCreateNewProjectController.allowPartner = value;
	}
	/**
	*@return Boolean
	*/
	public Boolean getAllowCustomer(){
		return ProjectCreateNewProjectController.allowCustomer;
	}
	/**
	*@return Boolean 
	*/
	public Boolean getAllowPartner(){
		return ProjectCreateNewProjectController.allowPartner;
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
	    theProject = [Select p.Type__c, p.PublicProfile__c, p.Priority__c,p.OwnerId, p.NewMemberProfile__c, 
	    			p.Name, p.IsDeleted, p.Image__c, p.Id, p.Picture__c, p.Description__c, p.CreatedDate From Project2__c p 
	                Where p.Id =:pId];
	    
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
    * Project Type Select
    *@return List<SelectOption>
    */
    
   /*   
    public List<SelectOption> getTypes() {
        List<Type__c> ProjectType = new List<ProjectType__c>();  
        List<SelectOption> options = new List<SelectOption>();
        
        ProjectType = [Select t.Name, t.Id From Type__c t order by t.Name asc];  
        options.add(new SelectOption('', '-- select Project type --'));
        for(Type__c c: ProjectType){
            options.add(new SelectOption(c.Id, c.Name));
        }
        return options;
    }
   */
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
    	public String ProjectOpenOrClosed { set; get; }     	
    }
    
    ProjectProfile newProfile = new ProjectProfile();
    
    public ProjectProfile getnewProfile(){
    	return newProfile;
    }
    
    /**
    * Save Project
    *@return Project detail page reference
    *@throws Exception
    */    
    public PageReference saveProject(){
    	try{
    		
    		System.debug('LEN:' + document.BodyLength);
    		if(document.BodyLength <= MAX_SIZE || (document.name == null || document.name == '')){
    			validSizePicture = true;
	    		if(newProfile.ProjectOpenOrClosed == 'open'){
	    			theProject.PublicProfile__c = newProfile.publicProfileOpen;
	    			theProject.NewMemberProfile__c = newProfile.newProfileOpen;	    			
	    		}else if (newProfile.ProjectOpenOrClosed == 'close') {
	    			theProject.PublicProfile__c = newProfile.publicProfileClosed;
	    			theProject.NewMemberProfile__c = null;
	    		}else if (newProfile.ProjectOpenOrClosed == 'private'){
	    			theProject.PublicProfile__c = null;
	    			theProject.NewMemberProfile__c = null;
	    		}
	    		
	    		
	    		if(theProject.Id == null){
		    		insert theProject;
		    		if(document.name != null && document.name != ''){
			    			document.ParentId = theProject.Id;
				    		insert document;
			    			theProject.Picture__c = document.Id;
				    		update theProject;	
		    		}	
	    		}else {
	       			if(document.name != null && document.name != ''){
		    			document.ParentId = theProject.Id;
		    			insert document;
		    			theProject.Picture__c = document.Id;
		    		}
		    		
		    		update theProject;
		    	}
		    	PageReference pageRef = new PageReference('/apex/ProjectDetail?id=' + theProject.Id);
	            pageRef.setRedirect(true);
	            return pageRef; 
    		}
    		else{
    			validSizePicture=false;
    			document = new Attachment();
    			return null;
    		}
    	}catch(Exception e){
    		throw e;
    	}
    }
    public PageReference save(){
    	return saveProject();
    	
    }
		
}