public class ProjectDetailTestController {
	
	public Project2__c project = new Project2__c();
	
	
	public ProjectDetailTestController(){}
	
	
	public Project2__c getProject(){
		return project;
	}
	
	public void setProject(Project2__c p){
		project = p;	
	}
	
}