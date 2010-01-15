/**
* @author Matias Menafra 1/7/2010
*/
public class TaskAssigneeActivity extends ActivityLog{

	private String assigneeName = '';
	private String taskName 	= '';
	private String assigneeId;
	private String taskId;
	
	/**
	* Constructor
	* @param String projectId
	* @param DateTime timeStamp
	* @param String modifiedBy
	* @param String action
	* @param String assigneeId
	* @param String taskId
	*/
	public TaskAssigneeActivity( String projectId, DateTime timeStamp, String modifiedBy, String action, String assigneeId, String taskId ){
		
		super( projectId, timeStamp, action );
		this.assigneeId = assigneeId;
		this.taskId 	= taskId;
	}
	
	/**
	* Method which will take care of logging individual changes to TaskAssignee Object
	* @return void
	*/
	public override void log(){
		
		ProjectMember__c member = DAOFactory.getInstance().getMemberById( this.memberId) ;
		this.modifiedBy = member.Name;
		
		//Assignee added to a Task
		if( this.action == 'insert' ){
			this.changeType = 9;
			this.assigneeName = '';
		}
		
		//Assignee removed from a Task
		if( this.action == 'delete' ){
			this.changeType = 10;
			this.assigneeName = '';
		}
	}
}