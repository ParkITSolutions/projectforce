/**
* @author Matias Menafra 1/7/2010
*/
public class MemberActivity extends ActivityLog{

	private String memberName;
	
	/**
	* Constructor
	*/
	public MemberActivity( String projectId, DateTime timeStamp, String modifiedBy, String action, String changeType, ProjectMember__c member){
		
		super(projectId, timeStamp, modifiedBy, action, changeType);
	}
	
	/**
	* 
	*/
	public override void log(){
		
	}
}