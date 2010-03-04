/**
 * Implements the breadcrum feature
 * @author Miguel Soares de Lima
 * @createdDate 02/01/2010
 * @group Controller
 */
public class BreadcrumController{
	
	private Map<String, BreadcrumNode> listNodes;
	private Set<String> infoOfProject;
	private Set<String> infoOfTaskAndProject;
	private String projectId;
	private String projectName;
	private String taskId;
	private String taskName;
	
	public List<BreadcrumNode> breadcrum 	{ set; get; }
	public String currentPage 				{ set; get; }
	public String lastLinkPage 				{ set; get; }
	
	/** 
	* Constructor
	*/
	public BreadcrumController(){ 
		
		// WARNING: the name of the page must be exact as appears in the url
		infoOfProject 			= ProjectUtil.objOfSetTolowerCase( new Set<String>{ 'projectDetail', 'ProjectActivity', 'MembersList', 'projectAttachmentList', 'TaskList', 'ProjectSubscription', 'ProjectSetup' } );
		infoOfTaskAndProject 	=  ProjectUtil.objOfSetTolowerCase( new Set<String>{ 'ProjectTaskDetail', 'ProjectTaskNotes' } );
		
		try{		
			this.currentPage = ApexPages.currentPage().getUrl().split( '/apex/' ).get(1).split( '[?]' ).get(0);
		}catch( Exception e ){
			this.currentPage = 'overview';
		}
		
		this.setInfo();
		this.createMapOfNodes();
		
		this.breadcrum = new List<BreadcrumNode>();
		
		this.buildBreadcrumb();
	}
	
	/**
	* Create the breadcrum 
	*/
	private void buildBreadcrumb(){

		BreadcrumNode b = new BreadcrumNode();
		List<BreadcrumNode> breadcrumAux = new List<BreadcrumNode>(); 
		
		b = this.listNodes.get( this.currentPage.toLowercase() );
		breadcrumAux.add( b );
		
		while( b.topName != 'root' ){
			b = this.listNodes.get( b.topName.toLowercase() );
			breadcrumAux.add( b );	
		}
	
		this.lastLinkPage = breadcrumAux[ 0 ].urlDisplay; 
		for( Integer k = breadcrumAux.size()-1; k > 0; k-- )
			this.breadcrum.add(  breadcrumAux[ k ]);	
	}
	
	/**
	* Get the infomarion needed depending the name of the page
	*/
	private void setInfo(){
		
		if( this.infoOfProject.contains( this.currentPage.toLowercase() ) ){
			
			Project project = new Project();
			id pId = System.currentPageReference().getParameters().get( 'id' );
			
			if( pId != null )
				project = DAOFactory.getInstance().getProjectInfo( pId ); 
			
			this.projectId 		= project.id;
			this.projectName 	= project.name;
			
		}else if( this.infoOfTaskAndProject.contains( this.currentPage.toLowercase() ) ){
			
			ProjectTask__c task = new ProjectTask__c();
			id taskId 	= System.currentPageReference().getParameters().get( 'id' );
			task 		= DAOFactory.getInstance().taskInfoWithProjectRel( taskId ); 
			
			this.projectId 		= task.project__c;
			this.projectName 	= task.project__r.name;
			this.taskId 		= task.id;
			this.taskName 		= task.name;
		}
	}
	
	/**
	* Create the map of nodes (tree), this methos call to addNode( String String String String )
	* for each node to create.
	*/
	private void createMapOfNodes(){
		this.listNodes = new Map<String, BreadcrumNode>();
		this.addNode( '/apex/projectOverview', 'Overview', 'overview', 'root' );
		this.addNode( '/apex/projectDetail?id=' + this.projectId, this.projectName, 'projectDetail', 'overview' );
		this.addNode( '/apex/tasklist?id=' + this.projectId, 'Tasks List', 'tasklist', 'projectDetail' );
		this.addNode( '/apex/projectTaskDetail?id=' + this.taskId, this.taskName, 'ProjectTaskDetail', 'tasklist' );
		this.addNode( '/apex/userTasks', 'User Tasks', 'userTasks', 'overview' );
		this.addNode( '/apex/projectAttachmentList?id=' + this.projectId, 'Attachment List', 'projectAttachmentList', 'projectDetail' );
		this.addNode( '/apex/MembersList?id=' + this.projectId, 'Members List', 'MembersList', 'projectDetail' );
		this.addNode( '/apex/ProjectActivity?id=' + this.projectId, 'Project Activity', 'ProjectActivity', 'projectDetail' );
		this.addNode( '/apex/ProjectTaskNotes?id=' + this.taskId, 'Project Task Notes', 'ProjectTaskNotes', 'ProjectTaskDetail' );
		this.addNode( '/apex/ProjectSubscription?id=' + this.taskId, 'Manage Subscription', 'ProjectSubscription', 'ProjectDetail' );
		this.addNode( '/apex/ProjectSetup', 'Project Setup', 'ProjectSetup', 'overview' );
	}
	 
	/**
	* Aux method for formated and add a new node on the tree.
	* @param url  relative page url without any param value. Examples /apex/projectOverview or /apex/projectDetail?id=
	* @param urlDispaly label to display in the page. Examples Overview or Project Detail
	* @param name the name of the node. Examples overview, pDetail, projectdetail.
	* @param topName the name od the parent node. Examples overview, pDetail, projectdetail.
	*/ 
	private  void addNode( String url, String urlDisplay, String name, String topName ){
		BreadcrumNode node = new BreadcrumNode();
		node.url 		= url;
		node.urlDisplay = urlDisplay;
		node.name 		= name.toLowercase();
		node.topName 	= topName.toLowercase();
		
		if( this.listNodes != null && this.listNodes.containsKey( name ) )
			throw new CustomException( 'The Key must be unique.' );
		else
			this.listNodes.put( name.toLowercase(), node );
	}
	
	/**
    * Test BreadCrum Controller
    */
    public static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
			
		Test.setCurrentPageReference( new PageReference( 'Page.MembersList' ) );
		System.currentPageReference().getParameters().put( 'id', GenerateEnvironmentTest.project.id );
		BreadcrumController breadcrumb = new BreadcrumController();
		
		Test.setCurrentPageReference( new PageReference( 'Page.ProjectActivity' ) );
		System.currentPageReference().getParameters().put( 'id', GenerateEnvironmentTest.project.id );
		breadcrumb = new BreadcrumController();
		
		Test.setCurrentPageReference( new PageReference( 'Page.projectAttachmentList' ) );
		System.currentPageReference().getParameters().put( 'id', GenerateEnvironmentTest.project.id );
		breadcrumb = new BreadcrumController();
		
		Test.setCurrentPageReference( new PageReference( 'Page.projectDetail' ) );
		System.currentPageReference().getParameters().put( 'id', GenerateEnvironmentTest.project.id );
		breadcrumb = new BreadcrumController();
		
		Test.setCurrentPageReference( new PageReference( 'Page.ProjectSetup' ) );
		System.currentPageReference().getParameters().put( 'id', GenerateEnvironmentTest.project.id );
		breadcrumb = new BreadcrumController();
		
		Test.setCurrentPageReference( new PageReference( 'Page.ProjectSubscription' ) );
		System.currentPageReference().getParameters().put( 'id', GenerateEnvironmentTest.project.id );
		breadcrumb = new BreadcrumController();
		
		Test.setCurrentPageReference( new PageReference( 'Page.ProjectTaskDetail' ) );
		System.currentPageReference().getParameters().put( 'id', GenerateEnvironmentTest.project.id );
		breadcrumb = new BreadcrumController();
		
		Test.setCurrentPageReference( new PageReference( 'Page.SearchResults' ) );
		System.currentPageReference().getParameters().put( 'id', GenerateEnvironmentTest.project.id );
		breadcrumb = new BreadcrumController();
		
		Test.setCurrentPageReference( new PageReference( 'Page.TaskList' ) );
		System.currentPageReference().getParameters().put( 'id', GenerateEnvironmentTest.project.id );
		breadcrumb = new BreadcrumController();
		
		Test.setCurrentPageReference( new PageReference( 'Page.userTasks' ) );
		System.currentPageReference().getParameters().put( 'id', GenerateEnvironmentTest.project.id );
		breadcrumb = new BreadcrumController();
		
    	Test.stopTest();
		ProjectUtil.setIsTest( false );    	
    }
}