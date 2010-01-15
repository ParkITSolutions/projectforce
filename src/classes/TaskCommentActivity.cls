/**
* @author Matias Menafra 1/7/2010
*/
public class TaskCommentActivity extends ActivityLog{

	private String taskName;
	private TaskComment__c comment = null;
		
	/**
	* Constructor
	* @param String projectId
	* @param DateTime timeStamp
	* @param String modifiedBy
	* @param String action
	* @param String commentId
	* @param String taskId
	*/
	public TaskCommentActivity( String projectId, DateTime timeStamp, String modifiedBy, String action, TaskComment__c comment ){
		
		super( projectId, timeStamp, action );
		this.comment 	= comment;
		this.memberId 	= modifiedBy;
	}
	
	/**
	* Method which will take care of logging individual changes to TaskComment Object
	* @return void
	*/
	public override void log(){
		
		ProjectMember__c member = DAOFactory.getInstance().getMemberByUserId( this.memberId ) ;
		this.modifiedBy = member.Name;
		
		//Comment Added to a Task
		if( this.action == 'insert' ){
			this.changeType = 11;
			this.taskName 	= this.comment.Task__r.Name;
			DAOFactory.getInstance().logTaskCommentActivity( this.projectId, this.timeStamp, this.modifiedBy, this.action, this.changeType, this.taskName );
		}
		
		//Comment removed from a Task
		if( this.action == 'delete' ){
			this.changeType = 12;
			this.taskName 	= this.comment.Task__r.Name;
			DAOFactory.getInstance().logTaskCommentActivity( this.projectId, this.timeStamp, this.modifiedBy, this.action, this.changeType, this.taskName );
		}
	}
}