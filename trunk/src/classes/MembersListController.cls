/**
* @author Andres Canavesi
* @createdDate 02/08/2010
*/
public with Sharing class MembersListController {
	
	public List<ProjectMember> member;	
	public UserPermissions userPermissions	 	{ set; get; }
	public Boolean isMember   					{ set; get; }
	public Boolean isManager   					{ set; get; }
	public String projectId 					{ set; get; }
	public String url 							{ set; get; }
	public Project project 						{ set; get; }
	public Project exceptionMessage 			{ set; get; }
	public Paginator paginator 					{ set; get; }
	
	/**
	* Constructor
	*/
	public MembersListController(){
		
		this.member 	= new List<ProjectMember>();
		this.projectId 	= System.currentPageReference().getParameters().get( 'id' );
		
		if( this.projectId == null || this.projectId == '' ){
			throw new CustomException('There is not a project selected');
		}
		
		this.project 	= new Project( this.projectId );
		this.url 		= ProjectUtil.getUrl();
		
		this.paginator 	= new Paginator();
		this.paginator.orderBy 		= 'name';
		this.paginator.project.id 	= this.projectId;
		
		paginator.loadMembersByProject();
		
		this.userPermissions = new UserPermissions();
		this.genPermissions();
	}
	
	/**
    * Load permission for current user
    */
 	public void genPermissions(){
        this.userPermissions.setId( UserInfo.getUserId() );
        this.userPermissions.setProject( this.projectId );
        this.userPermissions.setObjectType( 'Project' );
        this.userPermissions.setPermissions();
        
        this.isManager 	= this.userPermissions.getCanManage();
        this.isMember 	= this.userPermissions.isUserMemberOfProject( UserInfo.getUserId() , this.projectId );
    }
	
	/**
	* 
	* @return options the filter options
	*/
	public List<SelectOption> getFilterItems(){
		
		List<SelectOption> options = new List<SelectOption>();
		
		options.add(new SelectOption( '1','All' ) );
		options.add(new SelectOption( '2','All members' ) );
		options.add(new SelectOption( '3','All administrators' ) );
		
		return options;
	}
	
	/**
    * Test Member List
    */
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
		
		Test.setCurrentPageReference( new PageReference( 'Page.MembersList' ) );
		System.currentPageReference().getParameters().put( 'id', GenerateEnvironmentTest.project.id );

		MembersListController memberList = new MembersListController();
		memberList.getFilterItems();
		
		Test.setCurrentPageReference( new PageReference( 'Page.MembersList' ) );
		try{
			memberList = new MembersListController();
			memberList.getFilterItems();
		}
		catch( Exception e ){
		}
		
    	Test.stopTest();
		ProjectUtil.setIsTest( false );    	
    }
}