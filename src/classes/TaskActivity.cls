/**
* @author Matias Menafra 1/7/2010
*/
public class TaskActivity extends ActivityLog{

	private String name;
	private String newName;
	private String duration;
	private String status;
	
	/**
	* Constructor
	*/
	public TaskActivity(String projectId, DateTime timeStamp, String modifiedBy, String action, String changeType, ProjectTask__c task){
		
		super(projectId, timeStamp, modifiedBy, action, changeType);
	}
	
	/**
	* 
	*/
	public override void log(){
		
	}
}