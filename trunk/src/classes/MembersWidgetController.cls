/** 
* @author Nicolas Dominguez 
* @dateCreated 08/02/2009
*/
public with Sharing class MembersWidgetController {
	
	public Boolean  isProduction 				{ set; get; }
	public UserPermissions userPermissions	 	{ set; get; }
	public String projectId;
	public Boolean isManager   					{ set; get; }
	public List<ProjectMember> projectMembers;
	
	/**
    * Constructor
    */
	public MembersWidgetController(){
		this.isProduction		= ProjectUtil.isProduction;
		this.userPermissions 	= new UserPermissions();
	}

	/**
	* generates permissions for an especific user
	*/
	public void genPermissions() {
		this.userPermissions.setId( UserInfo.getUserId() );
		this.userPermissions.setProject( this.projectId );
		this.userPermissions.setObjectType( 'Project' );
		this.userPermissions.setPermissions();
		this.isManager = this.userPermissions.getCanManage();
	}
	
	/**
    * setter method for project Id
    * @param projId
    */
	public void setProjectId( String projId ){
		this.projectId = projId;
		this.genPermissions();
	}
	
	/**
    * Getter for Project Id
    * @return projectId
    */
	public String getProjectId(){
		return this.projectId;
	}
	/**
	* reloadMemberList 
	* @refresh the projectMembers List
	*/
	public void reloadMemberList(){ 
		this.projectMembers = getProjectMembers();
	}
	
	/**
	* Get the project Members
	* @return listProjectMember
	*/
	public List<ProjectMember> getProjectMembers() {
		List<ProjectMember> listProjectMember = new List<ProjectMember>();

		for (ProjectMember__c projMember :	DAOFactory.getInstance().getMembersToWidget( projectId )){
			ProjectMember projAux = new ProjectMember();
			projAux.id 				= projMember.Id;
			projAux.name 			= projMember.Name;
			projAux.CreatedDate 	= projMember.CreatedDate;
			projAux.isAdmin 		= (projMember.Profile__r.Name == 'Project Administrator');
			
			listProjectMember.add( projAux );
		}
		return listProjectMember;
	}
	
	/**
    * Test Members Widget
    */
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
		
		Test.setCurrentPageReference( new PageReference( 'Page.ProjectDetail' ) );
		
		MembersWidgetController memberWidget = new MembersWidgetController();
		memberWidget.setProjectId( GenerateEnvironmentTest.project.id );
		memberWidget.getProjectId();
		memberWidget.reloadMemberList();
		
    	Test.stopTest();
		ProjectUtil.setIsTest( false );    	
    }
}