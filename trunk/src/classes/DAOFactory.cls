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
	}
	
	/* Task operations */
	
	public void addTask(String name, String startDate, String dueDate, String duration, String assignTo, String projectId){
		DAOTask.add(name, startDate, dueDate, duration, assignTo, projectId);
	}
	
	public void actualizeTask(ProjectTask__c task){DAOTask.actualize(task);}
	
	public void removeTasks(String tasks){DAOTask.remove(tasks);}
	
	public ProjectTask__c getTask(String id){return DAOTask.get(id);}

	public List<ProjectTask__c> listTasksByProject(String projectId){
		return DAOTask.listByProject(projectId);
	}
	
	//public void markCompleteTasks(String tasks){DAOTask.markComplete(tasks);}
	
	/* End of Task operations */
	
	/* Member operations */
	
	public List<ProjectMember__c> getProjectMembers(String projectId){
		return DAOProject.getMembers(projectId);
	}
	
	/* End of Member operations */
	
	/* Assignee operation */
	
	public void addAssignee(String taskId, String assignTo, String projectId){
		DAOAssignee.add(taskId, assignTo, projectId);
	}
	
	/* End Assignee operation */
	
	/** Project operations */
	
	public Project2__c getProjectInfo(String projectid){
		return DAOProject.getInfo(projectId);
	}
	
	/** End of Project operations */

}