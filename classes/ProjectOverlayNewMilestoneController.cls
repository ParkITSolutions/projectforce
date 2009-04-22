/**
*@author Miguel Soares @ 03/18/2009
* refactoring for projectforce
*/
public class ProjectOverlayNewMilestoneController {
    
    
    ProjectTask__c newTask = new ProjectTask__c();
    public String PROJECTID = System.currentPageReference().getParameters().get('id');
    public ProjectMember__c projectMember = new ProjectMember__c();
    public Project2__c currentProject = null;
    public UserPermissions userPermissions = ProjectDetailController.userPermission.clone();
     
    /**
    * Constructor
    */
    public ProjectOverlayNewMilestoneController(){
        getCurrentProject();
        genPermissions();   
    }
    

    /**
    *@return String
    */
    public String getCurrentProjectId(){
        return PROJECTID;
    }
    
      
    /**
    *@param String project Id
    */
    public void setCurrentProjectId(String s) { 
        PROJECTID = s;
    }
    
    /**
    *@return ProjectTask__c
    */
    public ProjectTask__c getTask(){
        return newTask;
    }
    
    /**
    *@param ProjectTask__c 
    */
    public void setNewProyect(ProjectTask__c pT) {
        newTask = pT;
    }
    
       
    /**
    * Returns user location
    *@return String
    */
    public String getUserLocale(){
        return Userinfo.getLocale();    
    }
    
    /**
    *@return ProjectMember__c
    */
    public ProjectMember__c getProjectMember(){ 
        return projectMember;
    }

    
    /**
    *@param ProjectMember__c
    */
    public void setProjectMember(ProjectMember__c tm){
        projectMember = tm;
    }

    
    //For rerender use
    public void dummyRefresh (){}
    
    /**
    * Create members select options
    *@return List<SelectOption>
    */
    
    public List<SelectOption> getProjectMembers() {

        List<SelectOption> options = new List<SelectOption>();
        List<ProjectMember__c> projectMembers = new List<ProjectMember__c>();  
        if(PROJECTID != null){
            projectMembers = [Select t.Project__c, t.User__r.Name, t.User__r.IsActive, t.Name, t.User__c, t.Id From ProjectMember__c t where t.Project__c =: PROJECTID and t.User__r.IsActive != false];  
            options.add(new SelectOption('-1', 'Choose a project Member'));
            for(ProjectMember__c c: projectMembers) {
                options.add(new SelectOption(c.User__c, c.User__r.Name)); 
            }
        }
        return options;
    }
    

    /**
    * Returns Project for current project
    */
    public void getCurrentProject(){
        if(PROJECTID != null)
            currentProject = [select Id from Project2__c where Id =: PROJECTID limit 1];
    }
    
   
    /**
    * Read User permissions
    */
    public void genPermissions () {
        userPermissions.setId(UserInfo.getUserId());
        userPermissions.setProject(PROJECTID);
        userPermissions.setObjectType('Project');
        userPermissions.setPermissions();       
    }
    
    
    /**
    * Create new Milestone
    *@throws CustomExceptions, message Insufficient Privileges
    */
    public void insertMilestone (){ 
        if(!userPermissions.getCanCreate()){
            throw new CustomException('Insufficient Privileges'); 
        }       
        
        newTask.Milestone__c = true;
        newTask.Project__c = PROJECTID;
        newTask.StartDate__c = newTask.EndDate__c;
        newTask.PercentCompleted__c = 0.0;
        newTask.Priority__c = 'Medium';
        newTask.Project__c = currentProject.Id;
        newTask.Duration__c = 0.0;
        insert newTask; 
        
        ProjectAssignee__c Assign = new ProjectAssignee__c();
        Assign.User__c = projectMember.User__c;
        Assign.ProjectTask__c = newTask.Id;
        insert Assign;
        
        newTask = new ProjectTask__c();
    }
    
    
}