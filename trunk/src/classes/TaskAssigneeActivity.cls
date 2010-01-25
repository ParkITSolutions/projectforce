/**
* @author Matias Menafra 1/7/2010
*/
public class TaskAssigneeActivity extends ActivityLog{

	private String assigneeName 		= '';
	private String taskName 			= '';
	private ProjectAssignee__c assignee = null; 
		
	/**
	* Constructor
	* @param String projectId
	* @param DateTime timeStamp
	* @param String modifiedBy
	* @param String action
	* @param String assigneeId
	* @param String taskId
	*/
	public TaskAssigneeActivity( String projectId, DateTime timeStamp, String modifiedBy, String action, ProjectAssignee__c assignee ){
		
		super( projectId, timeStamp, action );
		this.assignee = assignee;
		this.memberId = modifiedBy;
	}
	
	/**
	* Method which will take care of logging individual changes to TaskAssignee Object
	* @return void
	*/
	public override void log(){
		
		ProjectMember__c member = DAOFactory.getInstance().getMemberByUserId( this.memberId ) ;
		this.modifiedBy = member.Name;
		
		ProjectMember__c newAssignee = DAOFactory.getInstance().getMemberByUserId( assignee.User__c );
		ProjectTask__c task = DAOFactory.getInstance().getTask( assignee.ProjectTask__c );
			
		//Assignee added to a Task
		if( this.action == 'insert' ){
			this.changeType 	= 'TaskAssignee_Insert';
			this.assigneeName 	= newAssignee.Name;
			this.taskName 		= task.Name;
			DAOFactory.getInstance().logTaskAssigneeActivity( this.projectId, this.timeStamp, this.modifiedBy, this.action, this.changeType, this.assigneeName, this.taskName );
		}
			
		//Assignee removed from a Task
		if( this.action == 'delete' ){
			this.changeType 	= 'TaskAssignee_Delete';
			this.assigneeName 	= newAssignee.Name;
			this.taskName 		= task.Name;
			DAOFactory.getInstance().logTaskAssigneeActivity( this.projectId, this.timeStamp, this.modifiedBy, this.action, this.changeType, this.assigneeName, this.taskName );
		}
	}
}