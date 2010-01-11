/**
* @author Matias Menafra 1/7/2010
*/
public class TaskCommentActivity extends ActivityLog{

	private String taskName;
	
	/**
	* Constructor
	*/
	public TaskCommentActivity(String projectId, DateTime timeStamp, String modifiedBy, String action, String changeType, String commentId, String taskId){
		
		super(projectId, timeStamp, modifiedBy, action, changeType);
	}
	
	/**
	* 
	*/
	public override void log(){
		
	}
}