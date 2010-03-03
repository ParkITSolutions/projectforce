/**
* @author Matias Menafra 
* @createdDate 1/15/2010
*/
public class ProjectActivity extends ActivityLog{

	private String name;
	private String access;
	private Project2__c oldProject;
	private Project2__c newProject;
	
	/**
	* Constructor
	* @param projectId
	* @param timeStamp
	* @param modifiedBy
	* @param action
	* @param oldProject
	* @param newProject
	*/
	public ProjectActivity( String projectId, DateTime timeStamp, String modifiedBy, String action, Project2__c oldProject, Project2__c newProject ){
		
		super( projectId, timeStamp, action );
		this.memberId 	= modifiedBy;
		this.oldProject = oldProject;
		this.newProject = newProject;
	}
	
	/**
	* Method which will take care of logging individual changes to Project Object
	*/
	public override void log(){
		
		ProjectMember__c member = DAOFactory.getInstance().getMemberByUserId( this.memberId );
		this.modifiedBy = member.Name;
		
		if( this.action == 'update' ){
			//Verifys change in Project Name
			if( this.oldProject.Name != this.newProject.Name ){
				this.name 		= this.newProject.Name;
				this.changeType = 'Project_Name';
				DAOFactory.getInstance().logProjectActivity( this.projectId, this.timeStamp, this.modifiedBy, this.action, this.changeType, this.name, '' );
			}
			
			//Verifys change in Project Access Level
			if( this.oldProject.Access__c != this.newProject.Access__c ){
				this.access 	= this.newProject.Access__c;
				this.changeType = 'Project_Access';
				DAOFactory.getInstance().logProjectActivity( this.projectId, this.timeStamp, this.modifiedBy, this.action, this.changeType, '', this.access );
			}
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