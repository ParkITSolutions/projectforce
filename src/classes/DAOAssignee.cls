/**
* @author Andres Canavesi 
* @dataCreated 12/15/2009
*/
public class DAOAssignee {
	
	/**
	* Constructor
	*/
	public DAOAssignee(){
	}
	
	/**
	* inserts an assignee
	* @param taskId
	* @param assignToId
	* @param projetId
	*/
	public void insertAssignees(String taskId, String[] assignees, String projectId){
		
		List<ProjectAssignee__c> assigneesList = new List<ProjectAssignee__c>();
		
		for(String assigneeId: assignees){
			
			ProjectAssignee__c assignee = new ProjectAssignee__c();
			assignee.User__c = assigneeId;
			assignee.ProjectTask__c = taskId;
			assignee.Project__c = projectId;
			
			assigneesList.add(assignee);
		}
		
		insert assigneesList;
	}
	
	/**
	* @param task
	* @return isTaskAssigned
	*/
	//TODO change the list for a simple ProjectAssignee__c
	public Boolean isTaskAssigned(ProjectTask__c task){
		
		List<ProjectAssignee__c> assignee = [select Id
											 from ProjectAssignee__c
											 where ProjectTask__c =: task.Id
											 and OwnerId =: Userinfo.getUserId()
											 limit 1];
											 
		if(assignee.size() == 0){
			
			return true;
		}				
		
		return false;							 
	}
	
	/**
	* returns a list with all task assingees
	* @param taskId
	* @return assigneesList
	*/
	public List<TaskAssignee> getAssignees( String taskId ){
		List<ProjectAssignee__c> assignees = [select Id, User__r.Name, User__c, ProjectTask__c, Project__c
											  from ProjectAssignee__c
											  where ProjectTask__c =: taskId];
		
		List<TaskAssignee> assigneesList = ObjectFormatter.formatTaskAssignees( assignees );					  
		return assigneesList;							 
	}
	
	/**
	*Return a list of tasks or milestones by user
	*@param taskOrMilestone a boolean flag
	*@return a List of task
	*/
	public List<ProjectAssignee__c> taskOrMilestoneByUser( Boolean taskOrMilestone ){
		List<ProjectAssignee__c> localTasks = new List<ProjectAssignee__c>(); 
		
		localTasks = [ SELECT id, project__c, project__r.name, projectTask__r.name, projectTask__r.status__c, projectTask__r.priority__c, projectTask__r.startDate__c, projectTask__r.endDate__c, projectTask__r.percentCompleted__c, projectTask__r.milestone__c, ProjectTask__r.DurationUI__c
					   FROM ProjectAssignee__c 
					   WHERE projectTask__r.milestone__c =: taskOrMilestone AND User__c =: UserInfo.getUserId() AND projectTask__r.status__c != 'Close'
					   ORDER BY projectTask__r.endDate__c DESC  LIMIT 5];
		return localTasks;	 
	}
}