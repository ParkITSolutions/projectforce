/**
* @author Matias Menafra 1/7/2010
*/
public class AttachmentActivity extends ActivityLog{
	
	private String taskName;
	private String ProjectName;
	
	/** 
	* Constructor
	* @param String projectId
	* @param DateTime timeStamp
	* @param String modifiedBy
	* @param String action
	*/
	public AttachmentActivity( String projectId, DateTime timeStamp, String modifiedBy, String action ){
		
		super( projectId, timeStamp, action );
	}
	
	/**
	* Method which will take care of logging individual changes to Attachment Object
	* @return void
	*/
	public override void log(){
		
		ProjectMember__c member = DAOFactory.getInstance().getMemberById( this.memberId );
		this.modifiedBy = member.Name;
	}
}