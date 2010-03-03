/**
* @author Matias Menafra 
* @createdDate 1/7/2010
*/
public class MemberActivity extends ActivityLog{

	private String memberName;
	private ProjectMember__c memberChanged;
	
	/**
	* Constructor
	* @param projectId
	* @param timeStamp
	* @param modifiedBy
	* @param action
	* @param member
	*/
	public MemberActivity( String projectId, DateTime timeStamp, String modifiedBy, String action, ProjectMember__c member ){
		
		super( projectId, timeStamp, action );
		this.memberChanged = member;
		this.memberId = modifiedBy;
	}
	
	/**
	* Method which will take care of logging individual changes to ProjectMember Object
	*/
	public override void log(){
		
		ProjectMember__c member = DAOFactory.getInstance().getMemberByUserId( this.memberId );
		this.modifiedBy = member.Name;
		
		this.memberName = this.memberChanged.Name;
		
		//Member has been added to a project
		if( this.action == 'insert' ){
			this.changeType = 'Member_Insert';
			DAOFactory.getInstance().logMemberActivity( this.projectId, this.timeStamp, this.modifiedBy, this.action, this.changeType, this.memberName );
		}
		
		//Member has been removed from a project
		if( this.action == 'delete' ){
			this.changeType = 'Member_Delete';
			DAOFactory.getInstance().logMemberActivity( this.projectId, this.timeStamp, this.modifiedBy, this.action, this.changeType, this.memberName );
		}		
	}
	
	/**
    * Test 
    */
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
		
		Test.setCurrentPageReference(new PageReference('Page.ProjectDetail'));
		System.currentPageReference().getParameters().put( 'id', GenerateEnvironmentTest.project.id );

		
    	Test.stopTest();
		ProjectUtil.setIsTest( false );    	
    }
}