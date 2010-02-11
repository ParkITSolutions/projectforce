public class BreadcrumController {

	private Set<String> infoOfProject = new Set<String>{ 'projectDetail', 'ProjectActivity', 'MembersList', 'projectAttachmentList', 'tasklist' };
	private Set<String> infoOfTaskAndProject =  new Set<String>{ 'ProjectTaskDetail', 'ProjectTaskNotes' };

	public String currentPage { set; get; }
	public String projectId { set; get; }
	public String projectName { set; get; }
	public String taskId { set; get; }
	public String taskName { set; get; }
	
	public Map<String, BreadcrumNode> listNodes;
	public List<BreadcrumNode> breadcrum { set; get; }
	public String actualPage { set; get; }
	
	
	
	
	public BreadcrumController(){ 

		this.currentPage = ApexPages.currentPage().getUrl().split('/apex/').get(1).split('[?]').get(0).toLowercase();
		
		this.setInfo( this.currentPage );
		this.createMapOfNodes();
		
		this.breadcrum = new List<BreadcrumNode>();
		
		this.buildBreadcrumb();

	}
	
	
	private void buildBreadcrumb(){

		BreadcrumNode b = new BreadcrumNode();
		List<BreadcrumNode> breadcrumAux = new List<BreadcrumNode>(); 
		
		b = this.listNodes.get( this.currentPage );
		breadcrumAux.add( b );
		
		while( b.topName != 'root' ){
				b = this.listNodes.get( b.topName );
				breadcrumAux.add( b );	
		}
		
		this.actualPage = breadcrumAux[ 0 ].urlDisplay; 
		for( Integer k = breadcrumAux.size()-1; k > 0; k-- )
			this.breadcrum.add(  breadcrumAux[ k ]);
		
	}
	
	private void setInfo( String pageName ){
		
		if( this.infoOfProject.contains( pageName )){
			Project project = new Project();
			id pId = System.currentPageReference().getParameters().get( 'id' );
			project = DAOFactory.getInstance().getProjectInfo( pId ); 
			this.projectId = project.id;
			this.projectName = project.name;
		}else if( this.infoOfTaskAndProject.contains( pageName )){
			ProjectTask__c task = new ProjectTask__c();
			id taskId = System.currentPageReference().getParameters().get( 'id' );
			task = DAOFactory.getInstance().ProjectTaskNotesObtainData( taskId )[0]; 
			this.projectId = task.project__c;
			this.projectName = task.project__r.name;
			this.taskId = task.id;
			this.taskName = task.name;
		}
	}
	
	
	private void createMapOfNodes(){
		this.listNodes = new Map<String, BreadcrumNode>();
		this.addNode( '/apex/projectOverview', 'Overview', 'overview', 'root');
		this.addNode( '/apex/projectDetail?id=' + this.projectId, 'Project Detail', 'projectDetail', 'overview');
		this.addNode( '/apex/tasklist?id=' + this.projectId, 'Tasks List', 'tasklist', 'projectDetail');
		this.addNode( '/apex/projectTaskDetail?id=' + this.taskId, this.taskName, 'ProjectTaskDetail', 'tasklist');
		this.addNode( '/apex/userTasks', 'User Tasks', 'userTasks', 'overview');
		this.addNode( '/apex/projectAttachmentList?id=' + this.projectId, 'Attachment List', 'projectAttachmentList', 'projectDetail');
		this.addNode( '/apex/MembersList?id=' + this.projectId, 'Members List', 'MembersList', 'projectDetail');
		this.addNode( '/apex/ProjectActivity?id=' + this.projectId, 'Project Activity', 'ProjectActivity', 'projectDetail');
		this.addNode( '/apex/ProjectTaskNotes?id=' + this.taskId, 'Project Task Notes', 'ProjectTaskNotes', 'ProjectTaskDetail');
	} 
	 
	private  void addNode( String url, String urlDisplay, String name, String topName ){
		BreadcrumNode node = new BreadcrumNode();
		node.url = url;
		node.urlDisplay = urlDisplay;
		node.name = name.toLowercase();
		node.topName = topName.toLowercase();
		
		if( this.listNodes != null && this.listNodes.containsKey( name ))
			throw new CustomException( 'The Key must be unique.' );
		else
			this.listNodes.put( name.toLowercase(), node );
	}

}