/**
* @author Matias Menafra 1/7/2010
*/
public class TaskCommentActivity extends ActivityLog{

	private String taskName;
	private String commentId;
	private String taskId;
	
	/**
	* Constructor
	* @param String projectId
	* @param DateTime timeStamp
	* @param String modifiedBy
	* @param String action
	* @param String commentId
	* @param String taskId
	*/
	public TaskCommentActivity( String projectId, DateTime timeStamp, String modifiedBy, String action, String commentId, String taskId ){
		
		super( projectId, timeStamp, action );
		this.commentId 	= commentId;
		this.taskId		= taskId;
	}
	
	/**
	* Method which will take care of logging individual changes to TaskComment Object
	* @return void
	*/
	public override void log(){
		
		ProjectMember__c member = DAOFactory.getInstance().getMemberById( this.memberId) ;
		this.modifiedBy = member.Name;
		
		//Comment Added to a Task
		if( this.action == 'insert' ){
			this.changeType = 11;
			this.taskName = '';
		}
		
		//Comment removed from a Task
		if( this.action == 'delete' ){
			this.changeType = 12;
			this.taskName = '';
		}
	}
}