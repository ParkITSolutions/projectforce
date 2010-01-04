public class DAOProject {
	
	public DAOProject(){}
	
	public List<ProjectMember__c> getMembers(String projectId){
		
		List<ProjectMember__c> members = new List<ProjectMember__c>();
		
		members = [select t.Project__c, t.User__r.Name, t.User__r.IsActive, t.Name, t.User__c, t.Id 
	  	 		   from ProjectMember__c t 
	  	 		   where t.Project__c =: projectId 
	  	 		   and t.User__r.IsActive != false]; 
	  	 		   
	    return members;
		
	}
	
	public Project2__c getInfo(String projectId){
		
		Project2__c project = new Project2__c();
		
		return project;
	}
}