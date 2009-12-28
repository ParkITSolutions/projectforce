public class DAOAssignee {
	
	public DAOAssignee(){}
	
	public void add(String taskId, String assignTo, String projectId){
	
		ProjectAssignee__c assignee = new ProjectAssignee__c();
		
		assignee.User__c = assignTo;
		assignee.ProjectTask__c = taskId;
		assignee.Project__c = projectId;
		
		insert assignee;
	}
}