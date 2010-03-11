/**
* @author Miguel Soares 
* @createdDate 
*/
public with Sharing class UserTasksController{
	
	public List<ProjectMember__c> allProjects;
	public List<SelectOption> selectOpsProject;
    public Map<id,ProjectMember__c> allProjectsMap;
	public id currentUser;
	public String opSelected;
    public String attachmentPrjId;
    public Boolean  isProduction 	{ set; get; }
    public Boolean showDetail 		{ set; get; }
    public Boolean auxShowDetail 	{ set; get; }
    public Project currentProject 	{ set; get; }
    public Paginator paginator  	{ set; get; }
    
    /**
    * Constructor
    */
    public UserTasksController(){
        
        this.isProduction	= ProjectUtil.isProduction;
        this.currentUser    = UserInfo.getUserId();
        this.showDetail     = false;

        this.allProjects        = new List<ProjectMember__c>();
        this.allProjectsMap     = new Map<id,ProjectMember__c>();
        this.selectOpsProject   = new List<SelectOption>(); 
        
        this.paginator = new Paginator();
        
        this.paginator.orderBy    = 'Name';
        this.paginator.orderAsc   = true;
        this.paginator.filter     = '1'; // Show all tasks and milestones
        
        if( this.opSelected == null || this.opSelected == 'none' )
        	this.paginator.project.id   = '';
        
        paginator.loadTasksByUser();
        this.selectAllProjectsName();
    }

    /**
    * @return attachmentPrjId
    */
    public String getAttachmentPrjId(){
        
        if( this.allProjects == null )
            selectProjectBasicData();
        
        return this.attachmentPrjId;
    }

    /**
    * @return List<SelectOption>
    */
    public List<SelectOption> getProjectSelectOps(){
        
        this.selectOpsProject.clear();
        this.selectOpsProject.add( new SelectOption( 'none', 'All projects' ) );

        for( ProjectMember__c p : this.allProjects )
            if( p.Project__c != null )
            	this.selectOpsProject.add( new SelectOption( (String)p.Project__c, p.Project__r.name ) );
            
        return this.selectOpsProject;
    }

    /**
    * @return opSelected
    */
    public String getOpSelected(){
        
        this.selectProjectBasicData();
        return this.opSelected;
    }
    
    /**
    * 
    * @param option
    */
    public void setOpSelected( String option ){          
        this.opSelected = option;
        
        this.paginator.project.id = option == 'none' ? '' : option;
        
        this.showDetail = option != 'none';
        auxShowDetail 	= this.opSelected == 'none' ? false : true;
        
        paginator.loadTasksByUser();
        this.selectProjectBasicData();
    }
    
    /**
    * 
    */
    public void selectProjectBasicData(){
        
        List<String> days               = new List<String>{'Mon', 'Thu', 'Wen', 'Thu', 'Fri', 'Sat', 'Sun'};
        this.currentProject             = new Project();
        ProjectMember__c tempProject    = new ProjectMember__c(); 
        
        if( this.allProjectsMap.size() > 0 && this.OpSelected != null && this.OpSelected != 'none' ){
            tempProject = this.allProjectsMap.get( this.OpSelected );
            
            this.AttachmentPrjId                        = tempProject.Project__r.Picture__c;
            this.currentProject.name                    = ProjectUtil.chopWords( ProjectUtil.chopPhrase( tempProject.Project__r.name,30) );
            this.currentProject.priority                = ProjectUtil.chopWords( tempProject.Project__r.priority__c );
            this.currentProject.displayDuration         = ProjectUtil.chopWords( tempProject.Project__r.DisplayDuration__c );
            this.currentProject.description             = ProjectUtil.chopWords( ProjectUtil.chopPhrase( tempProject.Project__r.Description__c, 30) );
            
            if( tempProject.Project__r.DaysInWorkWeek__c == null )
            	this.currentProject.daysWorkWeekFormated = '-';
            else
            	this.currentProject.daysWorkWeekFormated    = 'Mon - ' + days[ Integer.valueOf( tempProject.Project__r.DaysInWorkWeek__c )-1]; 
        }
    }
    
    /**
    *
    */
    public void selectAllProjectsName(){
         this.allProjects = DAOFactory.getInstance().getProjetsInfoByMember( this.currentUser );   
         
         for( ProjectMember__c p : this.allProjects)
            this.allProjectsMap.put( p.project__c, p );
    }
	
	/**
    * Test user tasks Page
    */
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		//System.runAs( GenerateEnvironmentTest.user ){
		ProjectUtil.setIsTest( true );
    	Test.startTest();
    	
    	Test.setCurrentPageReference( new PageReference( 'Page.UserTasks' ) );

    	UserTasksController userTask = new UserTasksController();
	 	userTask.showDetail 		= true;
		userTask.showDetail 		= userTask.showDetail;
		userTask.auxShowDetail 		= true;
		userTask.auxShowDetail 		= userTask.auxShowDetail;
		
		userTask.currentProject = new Project();
		userTask.currentProject = userTask.currentProject;
		
		userTask.paginator 	= new Paginator();
		userTask.paginator 	= userTask.paginator;
		
    	userTask = new UserTasksController();
    	userTask.getProjectSelectOps();
    	userTask.getOpSelected();
    	userTask.getAttachmentPrjId();
    	
    	userTask.selectProjectBasicData();
    	userTask.setOpSelected( 'none' );
    	userTask.selectProjectBasicData();
    	
    	userTask.selectAllProjectsName();
    	
    	userTask.getAttachmentPrjId();
    	userTask.allProjects = null;
    	userTask.getAttachmentPrjId();
    	
    	Test.stopTest();
		ProjectUtil.setIsTest( false );
		//}
    }	
}