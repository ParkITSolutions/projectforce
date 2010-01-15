//singleton class
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
	
	public static DAOFactory getInstance(){
		
		if(instance == null){
			
			instance = new DAOFactory();
		}
		
		return instance;
	}
	
	private DAOFactory(){
		this.DAOTask = new DAOTask();
		this.DAOMember = new DAOMember();
		this.DAOProject = new DAOProject();
		this.DAOSubscription = new DAOSubscription();
		this.DAOTaskPredecessor = new DAOTaskPredecessor();
		this.DAOTaskComment = new DAOTaskComment();
		this.DAOAttachment = new DAOAttachment();
		this.DAOAssignee = new DAOAssignee();
		this.DAOActivity = new DAOActivity();
	}
	
	/*-------------------------------------------------- Task operations ---------------------------------------------------------*/
	
	public void insertTask(String name, String startDate, String dueDate, String duration, String assignTo, String projectId, Boolean isMilestone){
		
		DAOTask.insertTask(name, startDate, dueDate, duration, assignTo, projectId, isMilestone);
	}
	
	public void updateTask(ProjectTask__c task){
		
		DAOTask.updateTask(task);
	}
	
	public void deleteTasks(String tasks){
		
		DAOTask.deleteTasks(tasks);
	}
	
	public ProjectTask__c getTask(String id){
		
		return DAOTask.get(id);
	}

	/*public List<ProjectTask__c> getTasksByProject(String projectId, String filter, String orderBy, Boolean orderAsc){
		
		return DAOTask.getByProject(projectId, filter, orderBy, orderAsc);
	}*/
	
	public ApexPages.StandardSetController getTasksByProject(String projectId, String filter, String orderBy, Boolean orderAsc){
		
		return DAOTask.getByProject(projectId, filter, orderBy, orderAsc);
	}
	
	public List<ProjectTask__c> getTasks(String tasksIds){ 
		
		return DAOTask.getTasks(tasksIds);
	}
	
	/* End of Task operations */
	
	/*--------------------------------------------------- Member operations -------------------------------------------------------*/
	
	public List<ProjectMember__c> getProjectMembers(String projectId){
		return DAOProject.getMembers(projectId);
	}
	
	public Boolean isCRMAdministrator(){ return DAOMember.isCRMAdministrator(); }
	
	public ProjectMember__c getMemberByUserId(String userId){
		
		return DAOMember.getMemberByUserId(userId);	
	}
	
	/* End of Member operations */
	
	/*--------------------------------------------------- Assignee operation ------------------------------------------------------*/
	
	public void insertAssignee(String taskId, String assignTo, String projectId){
		DAOAssignee.insertAssignee(taskId, assignTo, projectId);
	}
	
	public Boolean isTaskAssigned(ProjectTask__c task){return DAOAssignee.isTaskAssigned(task); }
	
	public List<ProjectMember> getAssignees(String taskId){return DAOAssignee.getAssignees(taskId); }
	
	/* End Assignee operation */
	
	/*--------------------------------------------------- Project operations ------------------------------------------------------*/
	
	public Project2__c getProjectInfo(String projectid){
		return DAOProject.getInfo(projectId);
	}
	
	public Boolean isProjectAdministrator(String projectId){return DAOProject.isProjectAdministrator(projectId); }
	
	/* End of Project operations */
	
	/*--------------------------------------------------- Activity Log operations ------------------------------------------------------*/
	
	public void logProjectActivity( String projectId, DateTime timeStamp, String modifiedBy, String action, String changeType, String name, String access ){
		DAOActivity.logProjectActivity( projectId, timeStamp, modifiedBy, action, changeType, name, access );
	}
	
	public void logMemberActivity( String projectId, DateTime timeStamp, String modifiedBy, String action, String changeType, String memberName ){
		DAOActivity.logMemberActivity(projectId, timeStamp, modifiedBy, action, changeType, memberName);
	}
	
	public void logTaskCommentActivity( String projectId, DateTime timeStamp, String modifiedBy, String action, String changeType, String taskName ){
		DAOActivity.logTaskCommentActivity(projectId, timeStamp, modifiedBy, action, changeType, taskName);
	}

	public void logTaskAssigneeActivity( String projectId, DateTime timeStamp, String modifiedBy, String action, String changeType, String assigneeName, String taskName ){
		DAOActivity.logTaskAssigneeActivity(projectId, timeStamp, modifiedBy, action, changeType, assigneeName, taskName);		
	}
	
	public void logTaskActivity( String projectId, DateTime timeStamp, String modifiedBy, String action, String changeType, String name, String newName, String duration, String status, Boolean complete ){
		DAOActivity.logTaskActivity(projectId, timeStamp, modifiedBy, action, changeType, name, newName, duration, status, complete);
	} 
	
	public void logAttachmentActivity( String projectId, DateTime timeStamp, String modifiedBy, String action, String changeType ){
		DAOActivity.logAttachmentActivity(projectId, timeStamp, modifiedBy, action, changeType);
	}
	
	public List<Project2__c> getActivityForProject(String projectId){
		return DAOActivity.getActivityForProject(projectId);
	}
	
	/* End of Activity operations */
}