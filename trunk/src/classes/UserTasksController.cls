/**
* @author Miguel Soares 
*/
public class UserTasksController{

    private Boolean showDetail;
    public id projectId;
    public id currentUser;
    public Project currentProject { set; get; }
    public List<ProjectMember__c> allProjects;
    public Map<id,ProjectMember__c> allProjectsMap;
    public List<Task> tasks {set; get;}
    public List<SelectOption> selectOpsProject;

    public String opSelected;   
    public String attachmentPrjId;
    
    // Paginator 
    public Paginator paginator 	{ set; get; }
    
    
    /**
    * Constructor
    */
    public UserTasksController(){
        
        this.projectId 		= System.currentPageReference().getParameters().get('id');
        this.currentUser 	= UserInfo.getUserId();
        this.opSelected 	= 'none'; 
        this.showDetail 	= false;

        this.allProjects 		= new List<ProjectMember__c>();
        this.tasks 				= new List<Task>();
        this.allProjectsMap 	= new Map<id,ProjectMember__c>();
        this.selectOpsProject 	= new List<SelectOption>(); 
        
		this.paginator = new Paginator();
		
		this.paginator.orderBy 		= 'Name';
		this.paginator.orderAsc 	= true;
		this.paginator.filter 		= '1'; // Show all tasks and milestones
		this.paginator.project.id 	= this.opSelected == 'none' ? '' : this.opSelected; 
		
        paginator.loadTasksByUser();
        
        this.selectAllPeojectName();
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
    * @return Boolean
    */
    public Boolean getShowDetail(){         
        
        return this.opSelected != 'none'; 
    } 

    /**
    * @return List<SelectOption>
    */
    public List<SelectOption> getProjectSelectOps(){
        
        this.selectOpsProject.clear();
        ProjectMember__c c = this.allProjects[0].clone();       
        this.selectOpsProject.add( new SelectOption( 'none', 'All projects' ) );

        for( ProjectMember__c p : this.allProjects )
            this.selectOpsProject.add( new SelectOption( (String)p.Project__c, p.Project__r.name ) );
            
        return this.selectOpsProject;
    }

    /**
    * @return String
    */
    public String getOpSelected(){
        
        this.selectProjectBasicData();
        return this.opSelected;
    }
    
    /**
    * @param String
    */
    public void setOpSelected( String op ){
        
        this.opSelected = op;
        this.paginator.project.id = op == 'none' ? '' : op;
        this.selectProjectBasicData();
    }
    
    /**
    * 
    */
    public void selectProjectBasicData(){
        
        List<String> d 					= new List<String>{'Mon', 'Thu', 'Wen', 'Thu', 'Fri', 'Sat', 'Sun'};
        this.currentProject  			= new Project();
        ProjectMember__c tempProject 	= new ProjectMember__c(); 
        
        if( this.allProjectsMap.size() > 0 && this.OpSelected != 'none' ){
            tempProject = this.allProjectsMap.get( this.OpSelected );
            
            this.AttachmentPrjId                        = tempProject.Project__r.Picture__c;
            this.currentProject.name                    = ProjectUtil.chopWords( tempProject.Project__r.name );
            this.currentProject.priority                = ProjectUtil.chopWords( tempProject.Project__r.priority__c );
            this.currentProject.displayDuration         = ProjectUtil.chopWords( tempProject.Project__r.DisplayDuration__c );
            this.currentProject.description             = ProjectUtil.chopWords( tempProject.Project__r.Description__c );
            this.currentProject.daysWorkWeekFormated    = 'Mon - ' + d[ Integer.valueOf( tempProject.Project__r.DaysInWorkWeek__c )]; 
        }
    }
    
    /**
    * @return void
    */
    public void selectAllPeojectName(){
         this.allProjects = DAOFactory.getInstance().getProjetsInfoByMember( this.currentUser );   
         
         for( ProjectMember__c p : this.allProjects)
         	this.allProjectsMap.put( p.project__c, p );
    }
}