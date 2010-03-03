/**
* @author Matias Menafra 
* @createdDate 1/7/2010
*/
public class AttachmentActivity extends ActivityLog{
	
	private String taskName;
	private String ProjectName;
	
	/** 
	* Constructor
	* @param projectId
	* @param timeStamp
	* @param modifiedBy
	* @param action
	*/
	public AttachmentActivity( String projectId, DateTime timeStamp, String modifiedBy, String action ){
		
		super( projectId, timeStamp, action );
		this.memberId = modifiedBy;
	}
	
	/**
	* Method which will take care of logging individual changes to Attachment Object
	*/
	public override void log(){
		
		ProjectMember__c member = DAOFactory.getInstance().getMemberByUserId( this.memberId );
		this.modifiedBy = member.Name;
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