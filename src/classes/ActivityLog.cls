/**
* @author Matias Menafra 1/6/2010
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
	* @param String projectId
	* @param DateTime timeStamp
	* @param String action
	*/
	public ActivityLog( String projectId, DateTime timeStamp, String action ){
		
		this.projectId 	= projectId;
		this.timeStamp 	= timeStamp;
		this.action 	= action;
	}
	
	/**
	* Virtual method for logging Objects, will be overriden by sub classes
	* @return void
	*/
	public virtual void log(){
	}
}