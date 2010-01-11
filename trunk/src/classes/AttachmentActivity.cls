/**
* @author Matias Menafra 1/7/2010
*/
public class AttachmentActivity extends ActivityLog{
	
	private String taskName;
	private String ProjectName;
	
	/**
	* Constructor
	*/
	public AttachmentActivity( String projectId, DateTime timeStamp, String modifiedBy, String action, String changeType){
		
		super(projectId, timeStamp, modifiedBy, action, changeType);
	}
	
	/**
	* 
	*/
	public override void log(){
		
	}
}