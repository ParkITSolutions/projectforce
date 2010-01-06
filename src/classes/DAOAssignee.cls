public class DAOAssignee {
	
	public DAOAssignee(){}
	
	public void add(String taskId, String assignTo, String projectId){
	
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
}