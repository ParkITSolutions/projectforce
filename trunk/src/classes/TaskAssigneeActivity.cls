/**
* @author Matias Menafra 1/7/2010
*/
public class TaskAssigneeActivity extends ActivityLog{

	private String name;
	private String taskName;
	
	/**
	* Constructor
	*/
	public TaskAssigneeActivity(String projectId, DateTime timeStamp, String modifiedBy, String action, String changeType, String assigneeId, String taskId){
		
		super(projectId, timeStamp, modifiedBy, action, changeType);
	}
	
	/**
	* 
	*/
	public override void log(){
		
	}
}