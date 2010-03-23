/**
* @author Andres Canavesi
* @createdDate 
*/
public with Sharing class TaskListController{
	
	public List<Task> tasks;
	public Boolean  isProduction 				{ set; get; }	
	public UserPermissions userPermissions	 	{ set; get; }
	public Boolean isMember   					{ set; get; }
	public Boolean isManager   					{ set; get; }
	public String projectId 					{ set; get; }
	public String url 							{ set; get; }
	public Project project 						{ set; get; }
	public Project exceptionMessage 			{ set; get; }
	public Paginator paginator 					{ set; get; }
	public String csvFileId 					{ set; get; }
	
	/**
	* Constructor
	*/
	public TaskListController(){  
		
		this.isProduction 	= ProjectUtil.isProduction;
		
		this.tasks 		= new List<Task>();
		this.projectId 	= System.currentPageReference().getParameters().get( 'id' );
		
		if( this.projectId == null || this.projectId == '' ){
			throw new CustomException( 'There is not a project selected' );
		}
		
		this.project 	= new Project( projectId );
		this.url 		= ProjectUtil.getUrl();
		
		this.project.displayDuration = DAOFactory.getInstance().getProjectInfo( projectid ).displayDuration;
		
		this.paginator 	= new Paginator();
		
		if( System.currentPageReference().getParameters().get( 'filter' ) != null ){
			String filter = System.currentPageReference().getParameters().get( 'filter' );
			if( filter == 'allMilestones' ){
				this.paginator.filter 	= '3'; // Show all milestones
			}
			else{
				this.paginator.filter 	= '1'; // Show all tasks and milestones
			}
		}
		
		
		this.paginator.orderBy 		= 'Name';
		this.paginator.project.id 	= this.projectId;
		
		paginator.loadTasksByProject();
		
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
	*/
	public List<SelectOption> getFilterItems() {
		
		List<SelectOption> options = new List<SelectOption>();
		
		options.add(new SelectOption( '1','All' ) );
		options.add(new SelectOption( '2','All tasks' ) );
		options.add(new SelectOption( '3','All milestones' ) );
		options.add(new SelectOption( '4','My tasks and milestones' ) );
		options.add(new SelectOption( '5','Completed tasks' ) );
		options.add(new SelectOption( '6','Overdue tasks' ) );
		options.add(new SelectOption( '7','Overdue milestones' ) );
		
		return options;
	}
	
   	/**
    * Export the task list into a csv file
    */ 
    public void generateTaskListCsv() {
       
        this.project 	= DAOFactory.getInstance().getProjectInfo( projectId );
        String csvText 	= 'ID ,Type,Priority,Name,Description,Status,AssignedTo,PercentCompleted,Duration (' + project.displayDuration + '),DueDate,DaysLate\n';               
             
        for( Task iterTask : this.paginator.getTasksByProject() ) {
           
            csvText += iterTask.idDisplay + ',';           
           
            if( iterTask.isMilestone )           
                csvText += 'Milestone,';
            else           
                csvText += 'Task,';
               
            csvText += iterTask.priority + ',';           
            csvText += iterTask.getName() + ',';  
           
            String description;
            if( iterTask.Description != null ){
                description  = iterTask.description.replaceAll( '\r\n', ' ' );
                description  = description.replaceAll( ',', ' ' );
            }
           
            csvText += description + ',';           
            csvText += iterTask.status + ',';  
            if( iterTask.assignees.size() > 0 ){
            	csvText += iterTask.assignees[0].name + ',';
            }         
            csvText += iterTask.getPercentCompleted() + ',';
            csvText += iterTask.endDate + '\n';
                 
        }
       
        List<Attachment> attachs =  new List<Attachment>();
        Attachment doc = null; 
       
        attachs = DAOFactory.getInstance().csvExport( 'pf__export.csv' );
        if( attachs.size() > 0 )
            doc = attachs[0];
        else{
            doc = new Attachment();
            doc.ParentId = PROJECTID;
            doc.Name = 'pf__export.csv';
        }

        doc.Body = Blob.valueOf(csvText);
        doc.ContentType = 'text/csv';
       	//TODO move SOQL to DAO
        upsert doc;
        this.csvFileId = doc.Id;
    }   	
    
	/**
	* Test Task List Controller
	*/
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
    	
    	TaskListController tKC;
    	
    	try{
    		tKC = new TaskListController();
    	}catch( CustomException e ){
    		System.assert( e.getMessage().contains('There is not a project selected' ));
    	}

		System.currentPageReference().getParameters().put( 'id', GenerateEnvironmentTest.project.id );
    	tKC = new TaskListController();
	
		tKC.getFilterItems();
        List<Attachment> attachs =  new List<Attachment>();
        attachs = DAOFactory.getInstance().csvExport( 'pf__export.csv' );
        
        tKC.generateTaskListCsv();

    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    }
}