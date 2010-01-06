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
	public List<ProjectTask__c> 	tasks 			{ set; get; }
			
	
	/**
	* Constructor
	*/
	public Project(String id){
		
		this.id = id;
		
	}
	
	public Project(){
		
	}
	
	public List<ProjectTask__c> getTasks(){
		
		return DAOFactory.getInstance().listTasksByProject(this.id);
	}
	
	public void setInfo(){
		
	 	Project2__c project = DAOFactory.getInstance().getProjectInfo(this.id);
	 	
	 	this.name = project.Name;
	}
	
	public void setTasks(String tasksIds){
		
		this.tasks = DAOFactory.getInstance().getTasks(tasksIds);
	}
	
	/**
	* Put all this.tasks percentages in 100%
	*/
	public void markCompleteTasks(){
		
		haveTasksPermissions(this.tasks);
		
		List<ProjectTask__c> tasks = new List<ProjectTask__c>();
				
		for(ProjectTask__c task: this.tasks){
					
			task.PercentCompleted__c = 100;
					
			tasks.add(task);
		}
				
		ProjectUtil.setTaskDependenciesFlag(false);
				
		try{
					
			update tasks;
					
		}catch(Exception e){
					 
			throw new CustomException('Updateing error. It may be because there are tasks that have children.'); 
					
		}finally{
					
			ProjectUtil.setTaskDependenciesFlag(true);
		}
	}
	
	/**
	* Checks if all given tasks can be modified by the current user.
	*/
	public void haveTasksPermissions(List<ProjectTask__c> tasks){
		
		List<ProjectTask__c> tasksError = new List<ProjectTask__c>();
		
		if(!DAOFactory.getInstance().isCRMAdministrator()){
			
			if(!DAOFactory.getInstance().isProjectAdministrator(this.id)){
				
				for(ProjectTask__c task : tasks){
					
					if(task.OwnerId == Userinfo.getUserId() || DAOFactory.getInstance().isTaskAssigned(task)){
						
						throw new CustomException('Insufficient privileges to update task(s)');
					}
					
				}
			
			}
			
		}
	}
	
}