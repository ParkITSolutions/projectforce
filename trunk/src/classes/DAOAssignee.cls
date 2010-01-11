public class DAOAssignee {
	
	public DAOAssignee(){}
	
	public void insertAssignee(String taskId, String assignTo, String projectId){
	
		ProjectAssignee__c assignee = new ProjectAssignee__c();
		
		assignee.User__c = assignTo;
		
		assignee.ProjectTask__c = taskId;
		
		assignee.Project__c = projectId;
		
		insert assignee;
	}
	
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
	* Returns a list with all task assingees
	*/
	public List<ProjectMember> getAssignees(String taskId){
		
		List<ProjectAssignee__c> assignees = [select Id, Name
											  from ProjectAssignee__c
											  where ProjectTask__c =: taskId];
											 
		List<ProjectMember> assigneesList = new List<ProjectMember>();
		
		for(ProjectAssignee__c assignee : assignees){
			
			ProjectMember member = new ProjectMember();
			
			member.id = assignee.id;
			member.name = assignee.Name;
			
			assigneesList.add(member);
		}				
		
		return assigneesList;							 
	}
}