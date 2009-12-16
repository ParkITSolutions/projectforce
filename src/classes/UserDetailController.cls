public class UserDetailController{

	private Boolean showDetail;
	private id projectId;
	private id currentUser;
	private ProjectMember__c currentProject;
	private List<ProjectMember__c> allProjects;
	private Map<id,ProjectMember__c> allProjectsMap;
	
	private List<SelectOption> selectOpsProject;
	
	public String opSelected {set; get;}
	public List<ProjectAssignee__c> tasks {set; get;}

	public UserDetailController(){
		this.projectId = System.currentPageReference().getParameters().get('id');
		this.currentUser = UserInfo.getUserId();
		
		this.showDetail = false;
		this.currentProject = new ProjectMember__c();
		this.allProjects = new List<ProjectMember__c>();
		this.tasks = new List<ProjectAssignee__c>();
		this.allProjectsMap = new Map<id,ProjectMember__c>();
		this.selectOpsProject = new List<SelectOption>(); 
		
		this.selectAllPeojectName();
		this.selectTasks();
	}
	
	public Boolean getShowDetail(){ 		
		return this.opSelected != null; 
	} 

	public ProjectMember__c getCurrentProject(){
		this.selectProjectBasicData();
		return this.currentProject;
	}

	public void setCurrentProject( ProjectMember__c p ){
		this.currentProject = p;
	}

	public List<SelectOption> getProjectSelectOps(){
		this.selectOpsProject.clear();
		this.selectOpsProject.add( new SelectOption( '', 'All' ));

		for( ProjectMember__c p : this.allProjects )
			this.selectOpsProject.add( new SelectOption( p.Project__c, p.Project__r.name ));
			
		return this.selectOpsProject;
	}
	
	// Private section 	
	//
	
	private void selectProjectBasicData(){
		if( this.allProjectsMap.size() > 0 )
			this.currentProject = this.allProjectsMap.get( this.OpSelected );
	}
	
	private void selectAllPeojectName(){
		this.allProjects = [ SELECT Project__c, Project__r.name, Project__r.Description__c, Project__r.Priority__c, Project__r.DisplayDuration__c, Project__r.DaysInWorkWeek__c FROM ProjectMember__c WHERE User__c =: this.currentUser ];
		
		if( this.allProjects.size() > 0 )
		for( ProjectMember__c m : this.allProjects )
			this.allProjectsMap.put( m.Project__c, m );
	}
	
	private void selectTasks(){
		this.tasks = [ SELECT ProjectTask__r.name, ProjectTask__r.startDate__c, ProjectTask__r.endDate__c, ProjectTask__r.status__c, ProjectTask__r.priority__c, ProjectTask__r.milestone__c, ProjectTask__r.percentCompleted__c FROM ProjectAssignee__c WHERE User__c =: this.currentUser ];
	}
}