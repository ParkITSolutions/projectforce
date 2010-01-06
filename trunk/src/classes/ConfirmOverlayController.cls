public class ConfirmOverlayController {
	
	public String 	title 	        { set; get; }
	
	public String 	messageToUser 	{ set; get; }
	
	public String 	actionIds 	    { set; get; }
	
	public String 	actionName 	    { set; get; }
	
	public String 	postAction 	    { set; get; }
	
	public String 	exceptionMessage 	    { set; get; }
	
	/**
	*Constructor
	*/
	public ConfirmOverlayController(){
		
	}
	
	/**
	* Action for accept button
	*/
	public void action(){
		
		try{
		
			if(this.actionName == 'DeleteTasks'){
				
				DAOFactory.getInstance().removeTasks(this.actionIds);
				
				this.postAction = 'DeleteTasksSuccess';
				
			}
			
			if(this.actionName == 'MarkCompleteTasks'){
				
				String projectId = System.currentPageReference().getParameters().get('id');
				
				Project project = new Project(projectId);
				
				project.setTasks(this.actionIds);
				
				Map<String, List<ProjectTask__c>> m = project.markCompleteTasks();
					
				if(m.containsKey('TasksMarkCompleteSuccess')){
					 
					 this.postAction = 'TasksMarkCompleteSuccess';
					 	
				}
					
				if(m.containsKey('TasksMarkCompleteNoPermissions')){
					 
					 this.postAction = 'TasksMarkCompleteNoPermissions';
					 	
				}
					
				if(m.containsKey('TasksMarkCompleteHaveChildren')){
					 
					 this.postAction = 'TasksMarkCompleteHaveChildren';
					 	
				}
					
				for(ProjectTask__c task : m.get(this.postAction)){
					 	
					 actionIds = actionIds + ':' + task.Id;
				}
				
			}
		}catch(CustomException e){
					
			this.exceptionMessage = e.getMessage();
		}
		
	}
	
}