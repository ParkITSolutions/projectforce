public class UserDetailController{

	// Paginator settigns
	private Integer rows = 20;
	public Integer getRows(){
		return this.rows;
	}
	
	public String page = '0';
	public String lastPage;
	public String getLastPage(){
		return String.valueOf( Integer.valueOf( this.lastPage )+1);
	}
	public void setLastPage( String lp){
		this.lastPage = lp;
	}
 
	public String getPage(){
		return String.valueOf( Integer.valueOf( this.page )+1);
	}
	public void setPage( String p ){
		if( p == 'next' ){
			this.page = String.valueOf( Math.abs(Integer.valueOf( this.page )+1));
		}else if( p == 'previous' ){
			this.page = String.valueOf( Math.abs(Integer.valueOf( this.page )-1)); 
		}	
	}
	public Integer notShowFirst;
	public Integer getNotShowFirst(){
		System.debug( '##> page ' + this.page + ' # rows ' +  this.rows);
		return  this.rows * Integer.valueOf( this.page ); 
	}
	

	private Boolean showDetail;
	private id projectId;
	private id currentUser;
	private ProjectMember__c currentProject;
	private List<ProjectMember__c> allProjects;
	private Map<id,ProjectMember__c> allProjectsMap;
	public String order;
	private List<SelectOption> selectOpsProject;
	
	public String opSelected;	
	public String AttachmentPrjId {set; get;}
	public List<Task> tasks;// {set; get;}

	public List<Task> getTasks(){
		
		return this.tasks;
	}
	
	public void setTasks( List<Task> ts ){
		this.tasks = ts;		
	}
	
	public String sortBy { set; get; }
	
	
	public UserDetailController(){
		System.debug('Construnctor ' + this.order);
		this.projectId = System.currentPageReference().getParameters().get('id');
		this.currentUser = UserInfo.getUserId();
		this.sortBy = 'projectTask__r.name';
		this.order = 'DESC';
		this.opSelected = '--None--'; 
		this.showDetail = false;
		this.currentProject = new ProjectMember__c();
		this.allProjects = new List<ProjectMember__c>();
		this.tasks = new List<Task>();
		this.allProjectsMap = new Map<id,ProjectMember__c>();
		this.selectOpsProject = new List<SelectOption>(); 
		
		this.selectAllPeojectName();
		this.selectTasks();
	}
	
	public Boolean getShowDetail(){ 		
		return this.opSelected != '--None--'; 
	} 

	public ProjectMember__c getCurrentProject(){

		return this.currentProject;
	}

	public void setCurrentProject( ProjectMember__c p ){
		this.currentProject = p;
	}

	public List<SelectOption> getProjectSelectOps(){
		this.selectOpsProject.clear();
		
		ProjectMember__c c = this.allProjects[0].clone();
		//c.Profile__c = 'ALL';
		
		this.selectOpsProject.add( new SelectOption( '--None--', 'All projects' ));

		for( ProjectMember__c p : this.allProjects )
			this.selectOpsProject.add( new SelectOption((String)p.Project__c, p.Project__r.name ));
			
		return this.selectOpsProject;
	}

	public String getOpSelected(){
	this.foo = this.opSelected;
		this.selectProjectBasicData();
		return this.opSelected;
	}
	
	public void setOpSelected( String op ){
		////////////////////
		//this.page = '0';
		this.opSelected = op;
		//this.selectProjectBasicData();
	
			
	}
	
	//Private section 	
	//\\
	private void selectProjectBasicData(){
		if( this.allProjectsMap.size() > 0 && this.OpSelected != '--None--'){
			this.currentProject = this.allProjectsMap.get( this.OpSelected );
			this.AttachmentPrjId = this.currentProject.Project__r.Picture__c; 
		}
	}
	
	private void selectAllPeojectName(){
		this.allProjects = [ SELECT Project__c, Project__r.Picture__c, Project__r.name, Project__r.Description__c, Project__r.Priority__c, Project__r.DisplayDuration__c, Project__r.DaysInWorkWeek__c FROM ProjectMember__c WHERE User__c =: this.currentUser ];
		
		if( this.allProjects.size() > 0 )
		for( ProjectMember__c m : this.allProjects )
			this.allProjectsMap.put( m.Project__c, m );
	}
	
	public void setingOrder(){
		if( this.order == 'ASC' )
			this.order = 'DESC';
		else 
			this.order = 'ASC';		
		
		this.page = '0';
		this.selectTasks();
	}
	
	public String foo{set;get;}
	
	public void selectTasks(){
		
		//this.setingOrder();
		
		System.debug( '[>>] ' + this.order );
		String sql = 'SELECT project__c, ProjectTask__c, project__r.name, ProjectTask__r.name, ProjectTask__r.startDate__c, ProjectTask__r.endDate__c, ProjectTask__r.status__c, ProjectTask__r.priority__c, ProjectTask__r.milestone__c, ProjectTask__r.percentCompleted__c FROM ProjectAssignee__c WHERE User__c = ';
		sql += '\'' +this.currentUser + '\'';
		
		
		if( this.opSelected != '--None--' ) 
			sql += ' AND Project__c = ' + '\'' + this.opSelected + '\'';			
			
		sql += ' ORDER BY ' + this.sortBy + ' ' + this.order;
			
		sql += ' LIMIT 1000 ';
		
		System.debug( '[>>2] ' + this.order +'<<'+sql);
		Task tempTask;
		this.tasks.clear(); 
		List<ProjectAssignee__c> chuchu = Database.query( sql );
		for( ProjectAssignee__c t : chuchu){
			tempTask = new Task();
			tempTask.project = t.project__c;
			tempTask.projectName = t.project__r.name;
			tempTask.id = t.ProjectTask__c;
			tempTask.name = t.ProjectTask__r.name;
			tempTask.startDate = t.ProjectTask__r.startDate__c; 
			tempTask.formatedStartDate = t.ProjectTask__r.startDate__c.format();
			tempTask.endDate = t.ProjectTask__r.endDate__c;
			tempTask.formatedEndDate = t.ProjectTask__r.endDate__c.format();
			tempTask.status = t.ProjectTask__r.status__c;
			tempTask.priority = t.ProjectTask__r.priority__c;
			tempTask.isMilestone = t.ProjectTask__r.milestone__c;
			tempTask.percentComplete = t.ProjectTask__r.percentCompleted__c;
			this.tasks.add( tempTask ); 
		}
		
		this.lastPage = String.valueOf( this.tasks.size() / this.rows );
	}
}