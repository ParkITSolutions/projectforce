/**
*@author Miguel Soares @ 03/17/2009
* refactoring for project force
*/
public class ProjectOverlayNewTaskController {
	
    public ProjectTask__c newTask = new ProjectTask__c();
   	public String PROJECTID = System.currentPageReference().getParameters().get('id'); 
   	public Project2__c currentProject = null;   
    public ProjectMember__c projectMember = new ProjectMember__c();    
   	public UserPermissions userPermissions = ProjectDetailController.userPermission.clone();
   	public String  taskPrefix = Schema.SObjectType.Projecttask__c.getKeyPrefix();
   	
   	public String domain;
   	 
    /**
    * Constructor
    */
    public ProjectOverlayNewTaskController(){
    	getCurrentProject();	
    	genPermissions();
    	
    	domain = ProjectUtil.getDomain();
	}
	
	/**
	*@return String
	*/
	public String getDomain(){
		return this.domain;
	}

   	/**
   	*@param String projectId
   	*@return void
   	*/
   	public void setProject (String projectId) {
   		this.PROJECTID = projectID;
   	}
   	
   	/**
   	* Get current project instance
   	*@return Project2__c
   	*/
   	public Project2__c getProject (){
   		return this.currentProject;
   	}
   	
   	/**
    *@return ProjectTask__c
    */
    public ProjectTask__c getTask(){
    	return this.newTask;
    }
    
	/**
	*@param ProjectTask__c value
	*@return void
	*/    
    public void setTask(ProjectTask__c value){
    	this.newTask = value;
    }
    

   
    /**
    *@return ProjectMember__c
    */
    public ProjectMember__c getProjectMember(){
    	return this.projectMember;
    }
    
    /**
    *@param ProjectMember__c value
    *@return void
    */
    public void setProjectMember(ProjectMember__c value){
    	this.projectMember = value;
    }
    
   	/**
   	*@return String
   	*/
   	public String getCurrentProjectId(){
   		return this.PROJECTID;
   	}
   	/**
   	*@return taskPrefix
   	*/
   	public String getTaskPrefix(){
   		return this.taskPrefix;
   	}
    
    /**
    * Return members select options
    *@return List<SelectOption>
    */ 
	public List<SelectOption> getProjectMembers() {
    	List<ProjectMember__c> projectMembers = new List<ProjectMember__c>();  
  	 	List<SelectOption> options = new List<SelectOption>();
  	 	if(PROJECTID != null){
	  	 	projectMembers = [Select t.Project__c, t.User__r.Name, t.User__r.IsActive, t.Name, t.User__c, t.Id 
	  	 						from ProjectMember__c t 
	  	 						where t.Project__c =: PROJECTID and t.User__r.IsActive != false];  
	  	 	options.add(new SelectOption('-1', 'Choose a project Member'));
	  	 	for(ProjectMember__c c: projectMembers) {
    			options.add(new SelectOption(c.User__c, c.User__r.Name)); 
	 		}
  	 	}
  	 	return options;
   	}

	/**
	* Read Project for current project
	*@return void
	*/
	public void getCurrentProject(){   
		if(PROJECTID != null)
			currentProject = [select p.Id, p.Name, p.DisplayDuration__c 
								from Project2__c p 
								where p.Id =: PROJECTID 
								limit 1];
	}
	
	
	/**
	* For rerender use
	*@return void
	*/
	public void dummyRefresh (){}   
	
	
	/**
	* Read user permissions
	*@return void
	*/
	public void genPermissions () {
		userPermissions.setId(UserInfo.getUserId());
		userPermissions.setProject(PROJECTID);
		userPermissions.setObjectType('Project');
		userPermissions.setPermissions();		
	}
   	
   	/**
   	* Create new task
   	*@throws CustomException message Insufficient Privileges
	*@return void
   	*/
   	public void insertTask (){ 
   		
   		//Read Permissions
   		genPermissions();
   		
   		if(!userPermissions.getCanCreate()){
        	throw new CustomException('Insufficient Privileges');
   		}else{	
   			
   			ProjectUtil.setFlagAssignee( false );
   			newTask.Milestone__c = false;
			newTask.Project__c = PROJECTID;
			newTask.PercentCompleted__c = 0.0;
			newTask.Priority__c = 'Medium';
			insert newTask; 

	  		ProjectAssignee__c Assign = new ProjectAssignee__c();
			Assign.User__c = projectMember.User__c;
			Assign.ProjectTask__c = newTask.Id;
			Assign.Project__c = newTask.Project__c;
			insert Assign;
			
			newTask = new ProjectTask__c();
			Assign = new ProjectAssignee__c();
   		}
   		 //To reset the selectList
		projectMember.User__c=null;
   	}
}