public class UserDetailController{

	private Boolean showDetail;
	private id projectId;
	private id currentUser;
	private Project currentProject;
	private List<ProjectMember__c> allProjects;
	private Map<id,ProjectMember__c> allProjectsMap;
	private List<Task> tasks = new List<Task>();
	private List<SelectOption> selectOpsProject;

	public String page = '0';
	public String lastPage;
	private Integer rows = 20; 

	public Integer notShowFirst;
	public String opSelected;	
	public String attachmentPrjId;
	public Integer tasksListSize {set; get;}
	public String order {set; get;}	
	public String sortBy { set; get; }
	public Project thisProject  { set; get; }
	
	
	public UserDetailController(){
		System.debug('Construnctor ' + this.order);
		this.projectId = System.currentPageReference().getParameters().get('id');
		this.currentUser = UserInfo.getUserId();
		this.sortBy = 'projectTask__r.name';
		this.order = 'ASC';
		this.opSelected = '--None--'; 
		this.showDetail = false;

		this.allProjects = new List<ProjectMember__c>();
		this.tasks = new List<Task>();
		this.allProjectsMap = new Map<id,ProjectMember__c>();
		this.selectOpsProject = new List<SelectOption>(); 
		
		this.selectAllPeojectName();
		this.selectTasks();
	}

	/**
	*@return List<Task>
	*/
	public List<Task> getTasks(){		
		return this.tasks;
	}
	
	/**
	*@param List<Task>
	*/
	public void setTasks( List<Task> ts ){
		this.tasks = ts;		
	}

	/**
	*@return String
	*/
	public String getAttachmentPrjId(){
		if( this.allProjects == null )
		selectProjectBasicData();
		
		return this.attachmentPrjId;
		
	}

	/**
	*@return Integer
	*/
	public Integer getRows(){
		return this.rows;
	}
	
	/**
	*@return String
	*/
	public String getLastPage(){
		return String.valueOf( Integer.valueOf( this.lastPage )+1);
	}
	
	/**
	*@param String
	*/
	public void setLastPage( String lp){
		this.lastPage = lp;
	}
 
 	/**
 	*@retunr String
 	*/
	public String getPage(){
		return String.valueOf( Integer.valueOf( this.page )+1);
	}
	
	/**
	*@param String
	*/
	public void setPage( String p ){
		if( p == 'next' ){
			this.page = String.valueOf( Math.abs(Integer.valueOf( this.page )+1));
		}else if( p == 'previous' ){
			this.page = String.valueOf( Math.abs(Integer.valueOf( this.page )-1)); 
		}	
	}

	/**
	*@return Integer
	*/
	public Integer getNotShowFirst(){
		return  this.rows * Integer.valueOf( this.page ); 
	}
	
	/**
	*return Boolean
	*/
	public Boolean getShowDetail(){ 		
		return this.opSelected != '--None--'; 
	} 

	/**
	*@return ProjectMember__c
	*/
	public Project getCurrentProject(){
		return this.currentProject;
	}

	/**
	*@param ProjectMember__c
	*/
	public void setCurrentProject( Project p ){
		this.currentProject = p;
	}

	/**
	*@return List<SelectOption>
	*/
	public List<SelectOption> getProjectSelectOps(){
		this.selectOpsProject.clear();
		ProjectMember__c c = this.allProjects[0].clone();		
		this.selectOpsProject.add( new SelectOption( '--None--', 'All projects' ));

		for( ProjectMember__c p : this.allProjects )
			this.selectOpsProject.add( new SelectOption((String)p.Project__c, p.Project__r.name ));
			
		return this.selectOpsProject;
	}

	/**
	*@return String
	*/
	public String getOpSelected(){
		this.selectProjectBasicData();
		return this.opSelected;
	}
	
	/**
	*@param String
	*/
	public void setOpSelected( String op ){
		this.opSelected = op;
		this.selectProjectBasicData();
	}
	
	//Private section 	
	/**
	*@return void
	*/
	private void selectProjectBasicData(){
		List<String> d = new List<String>{'Mon', 'Thu', 'Wen', 'Thu', 'Fri', 'Sat', 'Sun'};
		this.currentProject  = new Project();
		ProjectMember__c tempProject = new ProjectMember__c(); 
		
		if( this.allProjectsMap.size() > 0 && this.OpSelected != '--None--' ){
			tempProject = this.allProjectsMap.get( this.OpSelected );
			
			this.AttachmentPrjId 					= tempProject.Project__r.Picture__c;
			this.currentProject.name 				= ProjectUtil.chopWords( tempProject.Project__r.name );
			this.currentProject.priority 			= ProjectUtil.chopWords( tempProject.Project__r.priority__c );
			this.currentProject.displayDuration 	= ProjectUtil.chopWords( tempProject.Project__r.DisplayDuration__c );
			this.currentProject.description 		= ProjectUtil.chopWords( tempProject.Project__r.Description__c );
			this.currentProject.daysWorkWeekFormated 	= 'Mon - ' + d[ Integer.valueOf( tempProject.Project__r.DaysInWorkWeek__c )];
			
		}
	}
	
	/**
	*@return void
	*/
	private void selectAllPeojectName(){
		this.allProjects = [ SELECT Project__c, Project__r.Picture__c, Project__r.name, Project__r.Description__c, Project__r.Priority__c, Project__r.DisplayDuration__c, Project__r.DaysInWorkWeek__c FROM ProjectMember__c WHERE User__c =: this.currentUser ];
		
		if( this.allProjects.size() > 0 )
		for( ProjectMember__c m : this.allProjects )
			this.allProjectsMap.put( m.Project__c, m );
	}
	
	/**
	*@return void
	*/
	public void setingOrder(){
		if( this.order == 'ASC' )
			this.order = 'DESC';
		else 
			this.order = 'ASC';		
		
		this.page = '0';
		this.selectTasks();
	}
		
	/**
	*@return void
	*/
	public void selectTasks(){
				
		String sql = 'SELECT project__c, ProjectTask__c, project__r.name, ProjectTask__r.name, ProjectTask__r.startDate__c, ProjectTask__r.endDate__c, ProjectTask__r.status__c, ProjectTask__r.priority__c, ProjectTask__r.milestone__c, ProjectTask__r.percentCompleted__c, ProjectTask__r.DurationUI__c FROM ProjectAssignee__c WHERE User__c = ';
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
			tempTask.name =  t.ProjectTask__r.name;
			tempTask.startDate = t.ProjectTask__r.startDate__c; 
			tempTask.formatedStartDate = t.ProjectTask__r.startDate__c.format();
			tempTask.endDate = t.ProjectTask__r.endDate__c;
			tempTask.formatedEndDate = t.ProjectTask__r.endDate__c.format();
			tempTask.status = t.ProjectTask__r.status__c;
			tempTask.priority = t.ProjectTask__r.priority__c;
			tempTask.isMilestone = t.ProjectTask__r.milestone__c;
			tempTask.percentComplete = t.ProjectTask__r.percentCompleted__c;
			tempTask.duration = String.valueOf( t.ProjectTask__r.percentCompleted__c );
			this.tasks.add( tempTask ); 
		}
		
		this.tasksListSize = this.tasks.size();
		this.lastPage = String.valueOf( this.tasks.size() / this.rows );
	}
}