public with sharing class MyTasksAndMilestonesController {
	
	private id currentUser;
	private id currentProject;
	
	public List<Task> tasks { set; get; }
	public List<Task> milestones { set; get; }

	public MyTasksAndMilestonesController(){
		this.tasks 			= new List<Task>();
		this.milestones 	= new List<Task>();
		this.currentUser 	= UserInfo.getUserId();
		this.currentProject = System.currentPageReference().getParameters().get( 'id' );
		this.selectTaskToShow();
	}
	
	private void selectTaskToShow(){
		List<ProjectAssignee__c> localTasks = new List<ProjectAssignee__c>();
		List<ProjectAssignee__c> localMilestones = new List<ProjectAssignee__c>();
		
		localTasks = [  SELECT id, project__c, project__r.name, projectTask__r.name, projectTask__r.status__c, projectTask__r.priority__c, projectTask__r.startDate__c, projectTask__r.endDate__c, projectTask__r.percentCompleted__c, projectTask__r.milestone__c, ProjectTask__r.DurationUI__c
							FROM ProjectAssignee__c 
							WHERE projectTask__r.milestone__c = false AND User__c =: this.currentUser AND projectTask__r.status__c != 'Close'
							ORDER BY projectTask__r.endDate__c DESC  LIMIT 5];
		
		localMilestones = [  SELECT id, project__c, project__r.name, projectTask__r.name, projectTask__r.status__c, projectTask__r.priority__c, projectTask__r.startDate__c, projectTask__r.endDate__c, projectTask__r.percentCompleted__c, projectTask__r.milestone__c, ProjectTask__r.DurationUI__c
								FROM ProjectAssignee__c 
								WHERE projectTask__r.milestone__c = true AND User__c =: this.currentUser AND projectTask__r.status__c != 'Close'
								ORDER BY projectTask__r.endDate__c DESC  LIMIT 5];
								
		this.tasks = ObjectFormatter.formatAssigneeTask( localTasks );
		this.milestones = ObjectFormatter.formatAssigneeTask( localMilestones );
	}
}