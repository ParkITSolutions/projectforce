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
	public List<ProjectMember> getAssignees(String taskId){
		List<ProjectAssignee__c> assignees = [select Id, User__r.Name, User__c
											  from ProjectAssignee__c
											  where ProjectTask__c =: taskId];
		List<ProjectMember> assigneesList = new List<ProjectMember>();
		for(ProjectAssignee__c assignee : assignees){
			ProjectMember member = new ProjectMember();
			member.id = assignee.User__c;
			member.name = assignee.User__r.Name;
			assigneesList.add(member);
		}				
		
		return assigneesList;							 
	}
}