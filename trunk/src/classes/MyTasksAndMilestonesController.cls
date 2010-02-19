/**
* @author Miguel Soares
* @group Widget
* @createdDate 02/18/2010
*/
public class MyTasksAndMilestonesController{ 
	
	private id currentUser;
	private id currentProject;
	
	public List<Task> tasks 		 { set; get; }
	public Boolean    showTasks		 { set; get; } 
	public List<Task> milestones 	 { set; get; }
	public Boolean    showMilestones { set; get; }

	/**
	* Constructor
	*/
	public MyTasksAndMilestonesController(){ 
		
		this.tasks 			= new List<Task>();
		this.milestones 	= new List<Task>();
		this.currentUser 	= UserInfo.getUserId();
		
		this.selectTaskToShow();
	}
	
	/**
	* Select tasks and milestones to show.
	*/
	private void selectTaskToShow(){
		
		List<ProjectAssignee__c> localTasks 		= new List<ProjectAssignee__c>();
		List<ProjectAssignee__c> localMilestones 	= new List<ProjectAssignee__c>();
		
		localTasks 		= DAOFactory.getInstance().getTaskOrMilestoneByUser( false );
		localMilestones = DAOFactory.getInstance().getTaskOrMilestoneByUser( true );
							
							
		this.showTasks 		= localTasks != null || localTasks.size() > 0;
		this.showMilestones = localMilestones != null || localMilestones.size() > 0;
		
		if( this.showTasks ) 
			this.tasks = ObjectFormatter.formatAssigneeTask( localTasks );
		
		if( this.showMilestones )
			this.milestones = ObjectFormatter.formatAssigneeTask( localMilestones );
	}
}