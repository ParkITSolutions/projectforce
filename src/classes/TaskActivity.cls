/**
* @author Matias Menafra 1/7/2010
*/
public class TaskActivity extends ActivityLog{

	private String name 		= '';
	private String newName		= '';
	private String duration		= '';
	private String status		= '';
	private Boolean complete	= false;
	private ProjectTask__c oldTask = null;
	private ProjectTask__c newTask = null;
	
	/**
	* Constructor that can handle two tasks, for comparing (update)
	* @param String projectId
	* @param DateTime timeStamp
	* @param String modifiedBy	
	* @param String action
	* @param ProjectTask__c oldTask
	* @param ProjectTask__c newTask
	*/
	public TaskActivity( String projectId, DateTime timeStamp, String modifiedBy, String action, ProjectTask__c oldTask, ProjectTask__c newTask ){
		
		super( projectId, timeStamp, action );
		this.oldTask 	= oldTask;
		this.newTask 	= newTask;
		this.memberId 	= modifiedBy;
	}
	
	/**
	* Constructor for only one task (insert,  delete)
	* @param String projectId
	* @param DateTime timeStamp
	* @param String modifiedBy	
	* @param String action
	* @param ProjectTask__c newTask
	*/
	public TaskActivity( String projectId, DateTime timeStamp, String modifiedBy, String action, ProjectTask__c newTask ){
		
		super( projectId, timeStamp, action );
		this.newTask = newTask;
	}
	
	/**
	* Method which will take care of logging individual changes to ProjectTask Object
	* @return void
	*/
	public override void log(){
		
		ProjectMember__c member = DAOFactory.getInstance().getMemberByUserId( this.memberId );
		this.modifiedBy = member.Name;
		
		this.newName = this.newTask.Name;
		
		//New task is created
		if( this.action == 'insert' ){
			this.changeType = '';
			DAOFactory.getInstance().logTaskActivity( this.projectId, this.timeStamp, this.modifiedBy, this.action, this.changeType, this.name, this.newName, this.duration, this.status, this.complete );
		}
		
		//Task is Removed from a project
		if( this.action == 'delete' ){
			this.changeType = '';
			DAOFactory.getInstance().logTaskActivity( this.projectId, this.timeStamp, this.modifiedBy, this.action, this.changeType, this.name, this.newName, this.duration, this.status, this.complete );
		}		
		
		//Task is Updated
		if( this.action == 'update' ){
			//Task Name is changed
			if( this.oldTask.Name != this.newTask.Name ){
				this.changeType = '';
				this.name 		= this.oldTask.Name;
				this.newName 	= this.newTask.Name;
				DAOFactory.getInstance().logTaskActivity( this.projectId, this.timeStamp, this.modifiedBy, this.action, this.changeType, this.name, this.newName, this.duration, this.status, this.complete );
			}

			//Tasks Duration is changed
			if( this.oldTask.DurationUI__c != this.newTask.DurationUI__c ){
				this.changeType = '';
				this.duration 	= this.newTask.DurationUI__c;
				DAOFactory.getInstance().logTaskActivity( this.projectId, this.timeStamp, this.modifiedBy, this.action, this.changeType, this.name, this.newName, this.duration, this.status, this.complete );
			}
			
			//Tasks is completed
			if( (this.oldTask.PercentCompleted__c != this.newTask.PercentCompleted__c) && this.newTask.PercentCompleted__c == 100.0 ){
				this.changeType = '';
				this.complete 	= true;
				DAOFactory.getInstance().logTaskActivity( this.projectId, this.timeStamp, this.modifiedBy, this.action, this.changeType, this.name, this.newName, this.duration, this.status, this.complete );
			}
			
			//Tasks status is changed
			if( this.oldTask.Status__c != this.newTask.Status__c ){
				this.changeType = '';
				this.status 	= this.newTask.Status__c; 
				DAOFactory.getInstance().logTaskActivity( this.projectId, this.timeStamp, this.modifiedBy, this.action, this.changeType, this.name, this.newName, this.duration, this.status, this.complete );
			}
		}
	}
}