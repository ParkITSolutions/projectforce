public class TaskListController {
	
	public List<ProjectTask__c> 	tasks 	{ set; get; }
	
	public String 	projectId 		{ set; get; }
	
	public String 	url 		{ set; get; }
	
	public Project 	project 		{ set; get; }
	
	public TaskListController(){
		
		this.tasks = new List<ProjectTask__c>();
		
		this.projectId = System.currentPageReference().getParameters().get('id');
		
		//this.tasks = DAOFactory.getInstance().listTasksByProject(this.projectId);
		
		this.project = new Project(projectId);
		
		this.tasks = project.getTasks();
		
		this.url = ProjectUtil.getUrl();
		
		System.debug('### System.Userinfo.getUserType(): '+System.Userinfo.getUserType());
		
	}
	
	public void refreshTasksList(){
		//this.tasks = DAOFactory.getInstance().listTasksByProject(this.projectId);
		
		this.tasks = project.getTasks();
	}
	
}