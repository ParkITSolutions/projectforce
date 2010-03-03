/**
* @author Matias Menafra 1/6/2010
* @createdDate 1/6/2010
*/
public abstract class ActivityLog {
	
	protected Datetime timeStamp;
	protected String projectId;
	protected String modifiedBy;
	protected String action;
	protected String changeType;
	protected String memberId;
	
	/**	
	* Constructor
	* @param projectId
	* @param timeStamp
	* @param action
	*/
	public ActivityLog( String projectId, DateTime timeStamp, String action ){
		
		this.projectId 	= projectId;
		this.timeStamp 	= timeStamp;
		this.action 	= action;
	}
	
	/**
	* Virtual method for logging Objects, will be overriden by sub classes
	*/
	public virtual void log(){
	}
}