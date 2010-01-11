/**
* @author Matias Menafra 1/6/2010
*/
public abstract class ActivityLog {
	
	protected Datetime timeStamp;
	protected String projectId;
	protected String modifiedBy;
	protected String action;
	protected String changeType;
	
	/**
	* Constructor
	*/
	public ActivityLog( String projectId, DateTime timeStamp, String modifiedBy, String action, String changeType){
		
		this.projectId 	= projectId;
		this.timeStamp 	= timeStamp;
		this.modifiedBy = modifiedBy;
		this.action 	= action;
		this.changeType = changeType;
	}
	
	/**
	* 
	*/
	public virtual void log(){
		
	}
}