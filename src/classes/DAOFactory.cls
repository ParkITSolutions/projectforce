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
		this.DAOTask 				= new DAOTask();
		this.DAOMember 				= new DAOMember();
		this.DAOProject 			= new DAOProject();
		this.DAOSubscription 		= new DAOSubscription();
		this.DAOTaskPredecessor 	= new DAOTaskPredecessor();
		this.DAOTaskComment 		= new DAOTaskComment();
		this.DAOAttachment 			= new DAOAttachment();
		this.DAOAssignee 			= new DAOAssignee();
		this.DAOActivity 			= new DAOActivity();
	}
	
	/*-------------------------------------------------- Task operations ---------------------------------------------------------*/
	
	/**
	* Inserts a task
	* @param name
	* @param startDate
	* @param dueDate
	* @param duration
	* @param assignToId
	* @param projectId
	* @param isMilestone
	*/
	public void insertTask(String name, String startDate, String dueDate, String duration, String assignTo, String projectId, Boolean isMilestone){
		
		DAOTask.insertTask(name, startDate, dueDate, duration, assignTo, projectId, isMilestone);
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
	public void updateTask(String taskId, String name, String startDate, String dueDate, String duration, String assignTo, String projectId, Boolean isMilestone){
		
		DAOTask.updateTask(taskId, name, startDate, dueDate, duration, assignTo, projectId, isMilestone);
	}
	
	/**
	* deletes a task
	* @param tasks tasks ids string separated by ":"
	*/
	public void deleteTasks(String tasks){
		
		DAOTask.deleteTasks(tasks);
	}
	
	/**
	* gets a task by its id
	* @param id
	* @return task a ProjectTask__c
	*/
	public ProjectTask__c getTask(Id id){
		
		return DAOTask.get(id);
	}

	/**
	* gets all tasks of a given project
	* @param projectId
	* @param filter a filter criteria
	* @param orderBy column name
	* @param orderAsc true if order way must be ascending or descendant
	* @return tasks a list of tasks
	*/
	public ApexPages.StandardSetController getTasksByProject(String projectId, String filter, String orderBy, Boolean orderAsc){
		
		return DAOTask.getByProject(projectId, filter, orderBy, orderAsc);
	}
	
	/**
	* @param tasksIds ids separated by ":"
	* @return tasks a tasks list
	*/
	public List<ProjectTask__c> getTasks(String tasksIds){ 
		
		return DAOTask.getTasks(tasksIds);
	}
	
	/**
	* @param taskId
	* @return task
	*/
	public List<ProjectTask__c> ProjectTaskNotesObtainData( Id taskId ){
		return DAOTask.getInfoTaskById( taskId );
	}
	
	/*-----------------------------------------------------------------------------------------------------------------------------*/
	
	/*--------------------------------------------------- Member operations -------------------------------------------------------*/
	
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
	public ProjectMember__c getMemberByUserId(String userId){
		
		return DAOMember.getMemberByUserId(userId);	
	}
	
	/*-----------------------------------------------------------------------------------------------------------------------------*/
	
	/*--------------------------------------------------- Assignee operation ------------------------------------------------------*/
	
	/**
	* inserts an assignee
	* @param taskId
	* @param assignToId
	* @param projetId
	*/
	public void insertAssignee(String taskId, String assignTo, String projectId){
		
		DAOAssignee.insertAssignee(taskId, assignTo, projectId);
	}
	
	/**
	* @param task
	* @return isTaskAssigned
	*/
	public Boolean isTaskAssigned(ProjectTask__c task){
		
		return DAOAssignee.isTaskAssigned(task); 
	}
	
	/**
	* returns a list with all task assingees
	* @param taskId
	* @return assigneesList
	*/
	public List<ProjectMember> getAssignees(String taskId){
		
		return DAOAssignee.getAssignees(taskId); 
	}
	
	/*-----------------------------------------------------------------------------------------------------------------------------*/
	
	/*--------------------------------------------------- Project operations ------------------------------------------------------*/
	
	/**
	* @param projectId
	* @return members
	*/
	public List<ProjectMember__c> getProjectMembers(String projectId){
		
		return DAOProject.getMembers(projectId);
	}
	
	/**
	* @param projectId
	* @param project
	*/
	public Project getProjectInfo(String projectid){
		
		return DAOProject.getInfo(projectId);
	}
	
	/**
	* @param projectId
	* @return isProjectAdministrator
	*/
	public Boolean isProjectAdministrator(String projectId){
		
		return DAOProject.isProjectAdministrator(projectId); 
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
}