/**
*@author Matias Menafra @ 12/17/2009
*/
public class Project {

	public String 	id					{ set; get; }
	public String 	access 					{ set; get; }
	public Boolean 	allowCPU 				{ set; get; }
	public Boolean 	allowPPU 				{ set; get; }
	public String 	daysWorkWeek 			{ set; get; }
	public String 	daysWorkWeekFormated 	{ set; get; }
	public String 	description 			{ set; get; }
	public String 	displayDuration 		{ set; get; }
	public String 	image 					{ set; get; }
	public String 	name 					{ set; get; }
	public String 	picture 				{ set; get; }
	public String 	priority 				{ set; get; }
	public String 	createdBy 				{ set; get; }
	public Date 	createdDate 			{ set; get; }
	public String 	prjType 				{ set; get; }
	public Integer 	workingHours 			{ set; get; }
	public ProjectTask__c 	tasks 			{ set; get; }
			
	
	/**
	* Constructor
	*/
	public Project(String id){
		this.id = id;
		
	}
	
	public List<ProjectTask__c> getTasks(){
		
		return DAOFactory.getInstance().listTasksByProject(this.id);
	}
	
	public void setInfo(){
		
	 	Project2__c project = DAOFactory.getInstance().getProjectInfo(this.id);
	 	
	 	this.name = project.Name;
	}
	
	public void setTasks(String tasksIds){
		
		//this.tasks = DAOFactory.getInstance().getTasks(tasksIds) create it!
	}
	
	public void markCompleteTasks(){
		
		//for each tasks as task
		//	task.markComplete()
	}
}