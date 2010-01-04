public class ConfirmOverlayController {
	
	public String 	title 	        { set; get; }
	
	public String 	messageToUser 	{ set; get; }
	
	public String 	actionIds 	    { set; get; }
	
	public String 	actionName 	    { set; get; }
	
	public String 	postAction 	    { set; get; }
	
	
	/**
	*Constructor
	*/
	public ConfirmOverlayController(){
		
	}
	
	/**
	* Action for accept button
	*/
	public void action(){
		
		if(this.actionName == 'DeleteTasks'){
			
			DAOFactory.getInstance().removeTasks(this.actionIds);
			
			this.postAction = 'DeleteTasksSuccess';
			
		}
		
		if(this.actionName == 'MarkCompleteTasks'){
			
			//DAOFactory.getInstance().markCompleteTasks(this.actionIds);
			
			String projectId = System.currentPageReference().getParameters().get('id');
			
			Project project = new Project(projectId);
			
			project.setTasks(this.actionIds);
			
			project.markCompleteTasks();
			
			this.postAction = 'MarkCompleteTasksSuccess';
			
		}
		
	}
	
}