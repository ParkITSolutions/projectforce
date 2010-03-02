/**
* This is a singleton class to manage all data access
* @author Andres Canavesi 
* @dateCreated 12/15/2009
*/
public class DAOFactory {
    
    private static DAOFactory instance;
    private DAOTask DAOTask;
    private DAOMember DAOMember;
    private DAOProject DAOProject;
    private DAOSubscription DAOSubscription;
    private DAOTaskPredecessor DAOTaskPredecessor;
    private DAOTaskComment DAOTaskComment;
    private DAOAttachment DAOAttachment;
    private DAOAssignee DAOAssignee;
    private DAOActivity DAOActivity;
    private DAOUser DAOUser;
    private DAOSetup DAOSetup;
    
    
    /**
    * @return an instance of this class
    */
    public static DAOFactory getInstance(){
        
        if(instance == null){
            instance = new DAOFactory();
        }
        
        return instance;
    }
    
    /**
    * Constructor
    */
    private DAOFactory(){
        
        this.DAOTask                = new DAOTask();
        this.DAOMember              = new DAOMember();
        this.DAOProject             = new DAOProject();
        this.DAOSubscription        = new DAOSubscription();
        this.DAOTaskPredecessor     = new DAOTaskPredecessor();
        this.DAOTaskComment         = new DAOTaskComment();
        this.DAOAttachment          = new DAOAttachment();
        this.DAOAssignee            = new DAOAssignee();
        this.DAOActivity            = new DAOActivity();
        this.DAOUser                = new DAOUser();
        this.DAOSetup				= new DAOSetup();
    }
    
    /*-------------------------------------------------- Task operations ---------------------------------------------------------*/
    
    /**
    * Inserts a task
    * @param task
    * @param assignedTo
    */
    public void insertTask( ProjectTask__c task, String[] assignees){
        
        DAOTask.insertTask( task, assignees);
    }
    
    /**
    * Updates a tasks 
    * @param taskId
    * @param name
    * @param startDate
    * @param dueDate
    * @param duration
    * @param assignToId
    * @param projectId
    * @param isMilestone
    */
    /*
    public void updateTask( String taskId, String name, String startDate, String dueDate, String duration, String assignTo, String projectId, Boolean isMilestone ){
        
        DAOTask.updateTask( taskId, name, startDate, dueDate, duration, assignTo, projectId, isMilestone );
    }*/
    
    
    public void updateTask(ProjectTask__c task){
        DAOTask.updateTask( task );
    }
    
    
    /**
    * deletes a task
    * @param tasks tasks ids string separated by ":"
    */
    public void deleteTasks( String tasks ){
        
        DAOTask.deleteTasks( tasks );
    }
    
    /**
    * gets a task by its id
    * @param id
    * @return task a ProjectTask__c
    */
    public ProjectTask__c getTask( Id id ){
        
        return DAOTask.get( id );
    }

    /**
    * gets all tasks of a given project
    * @param projectId
    * @param filter a filter criteria
    * @param orderBy column name
    * @param orderAsc true if order way must be ascending or descendant
    * @param letter letter to filter
    * @return tasks a list of tasks
    */
    public ApexPages.StandardSetController getTasksByProject( String projectId, String filter, String orderBy, Boolean orderAsc, String letter ){
        
        return DAOTask.getByProject( projectId, filter, orderBy, orderAsc, letter );
    }
    
    /**
    * @param tasksIds ids separated by ":"
    * @return tasks a tasks list
    */
    public List<ProjectTask__c> getTasks( String tasksIds ){ 
        
        return DAOTask.getTasks( tasksIds );
    }
    
    /**
    * @param 
    * @return 
    */
    public ProjectTask__c getTaskByCustomId( String customId ){ 
        
        return DAOTask.getTaskByCustomId( customId );
    }
    
    /**
    * @param taskId
    * @return task
    */
    public List<ProjectTask__c> ProjectTaskNotesObtainData( Id taskId ){
        return DAOTask.getInfoTaskById( taskId );
    }
    
    public ApexPages.StandardSetController searchForTaskByProject( String projectId, String searchTerm, String namespace ){
        return DAOTask.searchForTasksByProject( projectId, searchTerm, namespace );
    }

    public ApexPages.StandardSetController loadTasksByUser( String filter, String orderBy, Boolean orderAsc, String projectId, String letter ){
        return this.DAOTask.loadTasksByUser( filter, orderBy, orderAsc, projectId, letter );
    }
    
    public ProjectTask__c taskInfoWithProjectRel( id idTask ){
         return this.DAOTask.getTaskInfoWithProjectRel( idTask );
    }
    
    /**
    *
    *@param String idTaskAssignee
    */
    public void deleteTaskAssignee( String idTaskAssignee ){
    	this.DAOTask.deleteTaskAssignee( idTaskAssignee );
    }
    /*-----------------------------------------------------------------------------------------------------------------------------*/
    
    /*--------------------------------------------------- Member operations -------------------------------------------------------*/
    
    /**
    * deletes members
    * @param members members ids string separated by ":"
    * @param projectId
    */
    public void deleteMembers( String members, String projectId ){
        
        DAOMember.deleteMembers( members, projectId );
    }
    
    /**
    * @return permissionsModifyAllData
    */
    public Boolean isCRMAdministrator(){ 
        
        return DAOMember.isCRMAdministrator(); 
    }
    
    /**
    * retrives a member by User id
    * @param userId
    * @return member
    */
    public ProjectMember__c getMemberByUserId( String userId ){
        
        return DAOMember.getMemberByUserId( userId );   
    }
    
    /**
    *@return a list of members candidates to be assigned
    */
    public List<ProjectMember__c> getCandidatesToAssign(String taskId){
        return DAOMember.getCandidatesToAssign(taskId);
    }

    /**
    *@return List<ProjectMember__c>
    */
    public List<ProjectMember__c> getProjetsInfoByMember( Id us ){
        return DAOMember.getProjetsInfoByMember( us ); 
    }
    
    /**
    * gets all members of a given project
    * @param projectId
    * @param filter a filter criteria
    * @param orderBy column name
    * @param orderAsc true if order way must be ascending or descendant
    * @param letter letter to filter
    * @return members a list of members
    */
    public ApexPages.StandardSetController getMembersByProject( String projectId, String filter, String orderBy, Boolean orderAsc, String letter ){
        
        return DAOMember.getByProject( projectId, filter, orderBy, orderAsc, letter );
    }
    
    /** 
    * Inserts new users member
    * @param newMemberList
    */
    public void newMemberList(List<ProjectMember__c> newMemberList){
        DAOMember.newMemberList(newMemberList);
    }
    
    
    /*-----------------------------------------------------------------------------------------------------------------------------*/
    
    /*--------------------------------------------------- Assignee operation ------------------------------------------------------*/
    
    /**
    * inserts an assignee
    * @param taskId
    * @param assignToId
    * @param projetId
    */
    public void insertAssignees( String taskId, String[] assignees, String projectId ){
        
        DAOAssignee.insertAssignees( taskId, assignees, projectId );
    }
    
    /**
    * @param task
    * @return isTaskAssigned
    */
    public Boolean isTaskAssigned( ProjectTask__c task ){
        
        return DAOAssignee.isTaskAssigned( task ); 
    }
    
    /**
    * returns a list with all task assingees
    * @param taskId
    * @return assigneesList
    */
    public List<TaskAssignee> getAssignees( String taskId ){
        
        return DAOAssignee.getAssignees( taskId ); 
    }

	/**
	*Return a list of tasks or milestones by user
	*@param taskOrMilestone a boolean flag
	*@return a List of task
	*/
	public List<ProjectAssignee__c> getTaskOrMilestoneByUser( Boolean taskOrMilestone ){
		return this.DAOAssignee.taskOrMilestoneByUser( taskOrMilestone );
	}
    
    /*-----------------------------------------------------------------------------------------------------------------------------*/
    
    /*--------------------------------------------------- Project operations ------------------------------------------------------*/
    
    /**
    * @param projectId
    * @return members
    */
    public List<ProjectMember__c> getProjectMembers( String projectId ){
        
        return DAOProject.getMembers( projectId );
    }
    
    /** Return project members, order by CreateDate
    * @param projectId
    * @return members
    */
    public List<ProjectMember__c> getMembersToWidget (String idProject){
        return DAOProject.getMembersToWidget( idProject );
    }
    
    /**
    * @param projectId
    * @param project
    */
    public Project getProjectInfo( String projectid ){
        return DAOProject.getInfo( projectId );
    }
    
    /**
    * @param projectId
    * @return isProjectAdministrator
    */
    public Boolean isProjectAdministrator( String projectId ){
        
        return DAOProject.isProjectAdministrator( projectId ); 
    }
    
    public ApexPages.StandardSetController searchForProjects( String searchTerm, String namespace ){
        return DAOProject.searchForProjects( searchTerm, namespace );
    }
    
    /**
    * @param void
    * @return Map<String,Id>
    */
    public Map<String,Id> idProjectProfile(){
        return DAOProject.idProjectProfile();
    }
    
    /**
	* Delete a Project
	* @param Project2__c projectToDelete
	*/
	public void deleteProject( String projectId ){
		DAOProject.deleteProject( projectId );
	}
	
	public String getProjectAvatarId( String pId ){
		return DAOProject.projectAvatarId( pId );
	}
    /*-----------------------------------------------------------------------------------------------------------------------------*/
    
    /*--------------------------------------------------- Activity Log operations ------------------------------------------------------*/
    
    /**
    * @param projectId
    * @param timeStamp
    * @param modifiedBy
    * @param action
    * @param changeType
    * @param name
    * @param access
    */
    public void logProjectActivity( String projectId, DateTime timeStamp, String modifiedBy, String action, String changeType, String name, String access ){
        
        DAOActivity.logProjectActivity( projectId, timeStamp, modifiedBy, action, changeType, name, access );
    }
    
    /**
    * @param projectId
    * @param timeStamp
    * @param modifiedBy
    * @param action
    * @param changeType
    * @param memberName
    */
    public void logMemberActivity( String projectId, DateTime timeStamp, String modifiedBy, String action, String changeType, String memberName ){
        
        DAOActivity.logMemberActivity( projectId, timeStamp, modifiedBy, action, changeType, memberName );
    }
    
    /**
    * @param projectId
    * @param timeStamp
    * @param modifiedBy
    * @param action
    * @param changeType
    * @param taskName
    */
    public void logTaskCommentActivity( String projectId, DateTime timeStamp, String modifiedBy, String action, String changeType, String taskName ){
        
        DAOActivity.logTaskCommentActivity( projectId, timeStamp, modifiedBy, action, changeType, taskName );
    }
    
    /**
    * @param projectId
    * @param timeStamp
    * @param modifiedBy
    * @param action
    * @param changeType
    * @param assigneeName
    * @param taskName
    */
    public void logTaskAssigneeActivity( String projectId, DateTime timeStamp, String modifiedBy, String action, String changeType, String assigneeName, String taskName ){
        
        DAOActivity.logTaskAssigneeActivity( projectId, timeStamp, modifiedBy, action, changeType, assigneeName, taskName );        
    }
    
    /**
    * @param projectId
    * @param timeStamp
    * @param modifiedBy
    * @param action
    * @param changeType
    * @param name
    * @param newName
    * @param duration
    * @param status
    * @param complete
    */
    public void logTaskActivity( String projectId, DateTime timeStamp, String modifiedBy, String action, String changeType, String name, String newName, String duration, String status, Boolean complete ){
        
        DAOActivity.logTaskActivity( projectId, timeStamp, modifiedBy, action, changeType, name, newName, duration, status, complete );
    } 
    
    /**
    * @param projectId
    * @param timeStamp
    * @param modifiedBy
    * @param action
    * @param changeType
    * @beta still not implemented
    */
    public void logAttachmentActivity( String projectId, DateTime timeStamp, String modifiedBy, String action, String changeType ){
        
        DAOActivity.logAttachmentActivity( projectId, timeStamp, modifiedBy, action, changeType );
    }
    
    /** 
    * @param projectId
    * @return projectActivities
    */
    public ApexPages.StandardSetController getActivityForProject( String projectId ){
        
        return DAOActivity.getActivityForProject( projectId );
    }
    
    /** 
    * @param projectId
    * @return prjActivity
    */
    public List<Activity__c> getActivityForProjectWidget( String projectId ){
        
        return DAOActivity.getActivityForProjectWidget( projectId );
    }
    
    /*-----------------------------------------------------------------------------------------------------------------------------*/
    
    /*--------------------------------------------------- Attachment operations ------------------------------------------------------*/
    
    public List<AttachmentObj> getAttachments( String id ){
        
        return DAOAttachment.getAttachments( id );
    }
    
    public void insertAttachment( Attachment att, id idAtt ){
        this.DAOAttachment.insertAttachment( att, idAtt );
    }
    
    public void deleteAttachments( String attachments ){
        DAOAttachment.deleteAttachment( attachments );
    }
    
    /*-----------------------------------------------------------------------------------------------------------------------------*/
    
    /*--------------------------------------------------- User operations ------------------------------------------------------*/

    public Boolean isAdministrator(){
        return DAOUser.isAdministrator();
    }
    
    public List<User> findUserNotMember( List<String> newMembers, String idProject ){
        return DAOUser.findUserNotMember( newMembers, idProject );
    }
    
    public Boolean isProjectMember( String projectId ){
    	return DAOUser.isProjectMember( projectId );
    }
	
	/**
	* Return true if the usr usrid is a member of project (projectid)
	* @param String usrId
	* @param String projectId
	* @return Boolean
	*/
	public Boolean isMemberOfProject( String usriId, String projectId ){
		return DAOUser.isMemberOfProject( usriId, projectId );
	}
    /*-----------------------------------------------------------------------------------------------------------------------------*/
    
    /*--------------------------------------------------- Project Subscription operations ------------------------------------------------------*/
    
    /** Return list of project subscriptions
    *@param String idProject
    *@return List<ProjectSubscription__c>
    */
    public List<ProjectSubscription__c> subscriptionProjectList(String idProject){
        return DAOSubscription.subscriptionProjectList(idProject);
    }
    
    /** Insert project subscription
    *@param ProjectSubscription__c subs
    *@return void
    */
    public void insertProjectsubscription(ProjectSubscription__c subs){
        DAOSubscription.insertProjectsubscription(subs);
    }
    
    /** Updtate project subscription
    *@param ProjectSubscription__c subs
    *@return void
    */
    public void updateProjectsubscription(ProjectSubscription__c subs){
        DAOSubscription.updateProjectsubscription(subs);
    }

	/*-----------------------------------------------------------------------------------------------------------------------------*/
    
    /*--------------------------------------------------- Project Setup operations ------------------------------------------------------*/
	
	/**
	* Get ListSavedProfiles from ProjectSetup 
	* @return List<ProjectSetup__c>
	*/
	public List<ProjectSetup__c> getListSavedProfilesProjectSetup(){ 
		return DAOSetup.getListSavedProfiles();
	}
	
	/** 
	* Insert project setup
	* @param ProjectSetup__c 
	*/
	public void insertProjectSetup( ProjectSetup__c projectSetup ){
		DAOSetup.insertProjectSetup( projectSetup );
	}
	
	/** 
	* Updtate project setup
	* @param ProjectSetup__c
	*/
	public void updateProjectSetup(ProjectSetup__c projectSetup){
		DAOSetup.updateProjectSetup( projectSetup );
	}
	
    /*-----------------------------------------------------------------------------------------------------------------------------*/
    
}