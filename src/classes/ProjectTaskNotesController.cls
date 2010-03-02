/** 
* @author Nicolas Dominguez 
* @dateCreated 21/12/2009
*/
public class ProjectTaskNotesController {

	private ProjectTask__c taskVar 	{ set; get; }
	public String taskId 			{ set; get; }
	public String taskNotes 		{ set; get; }
	public String taskName 			{ set; get; }
	public String taskNameShort 	{ set; get; }
	public String projectId 		{ set; get; }
	public String projectName 		{ set; get; }
	public String projectNameShort 	{ set; get; }
	public Boolean canAccess 		{ set; get; }
	public UserPermissions userPermissions;

	/**
    * Constructor
    * @param ApexPages.StandardController
    */
    public ProjectTaskNotesController( ApexPages.StandardController ctrl ){
    	
		this.taskVar 			= new ProjectTask__c();
		this.userPermissions 	= new UserPermissions();
		this.genPermissions();
		this.obtainData();
    }
    
    /**
	* generates permissions for an especific user
	*/
	public void genPermissions() {
		userPermissions.setId( UserInfo.getUserId() );
		userPermissions.setObjectType( 'Project' );
		userPermissions.setPermissions();		
	}

    /**
    * obtains data from the task and project
    */
	public void obtainData(){
		
		this.taskId=System.currentPageReference().getParameters().get( 'id' );
		List<ProjectTask__c> taskList = new List<ProjectTask__c>();

		taskList = DAOFactory.getInstance().ProjectTaskNotesObtainData( taskId ); 

		if (taskList.size() > 0 ) {
			this.taskVar=taskList[0];
			if (this.taskVar != null){
				this.projectId=this.taskVar.Project__c;
				this.projectName=this.taskVar.Project__r.Name;
				
				//I cut out the name if too long
				this.projectNameShort=ProjectUtil.chopWords( ProjectUtil.chopPhrase( this.projectName , 20 ) );
				
				this.taskName=this.taskVar.Name;
				//I cut out the name if too long
				this.taskNameShort=ProjectUtil.chopWords( ProjectUtil.chopPhrase( this.taskName , 20 ) );
				
				this.taskNotes=this.taskVar.notes__c;
				
				//Permissions
				//I can access if it is true canAccess
				this.canAccess = false;
				if( UserInfo.getUserId() == this.taskVar.CreatedById ){
					this.canAccess = true;	
				}
				else if ( this.userPermissions.getCanManage() ){
					this.canAccess = true;
				}
				else if( ( ( this.taskVar.ProjectsAssignees__r).size() != 0 ) && ( this.taskVar.ProjectsAssignees__r != null ) ){
					for ( ProjectAssignee__c item: this.taskVar.ProjectsAssignees__r ) {
					
						if( UserInfo.getUserId() == item.User__r.id ){
							this.canAccess = true;
						}
						else{
						}
					}
				}
			}
		}
	}

    /**
    * cancel changes
    * @return pageRef a page reference
    */
    public PageReference CancelEdit () {
    	
		PageReference pageRef = new PageReference( '/apex/ProjectTaskDetail' );
		pageRef.getParameters().put( 'id', this.taskId );
        pageRef.setRedirect( true );
        
		return pageRef;	
	}
    
    /**
    * 
    * 
    */
    private Boolean sizeAllowed(){
    	
    	Boolean result= false;
    	if ( taskNotes != null && taskNotes.length() <= 32000 )
    		result=true;
    		
    	return result;
    }
    
    /**
	* saves changes and redirect
	* @return pageRef a page reference
	*/
	public PageReference SaveEditAndExit () {
		
		if ( this.sizeAllowed() ){
			this.taskVar.notes__c = taskNotes;
			
			//update this.taskVar;
			//update Task Notes;
			DAOFactory.getInstance().updateTask( this.taskVar );
		
			PageReference pageRef = new PageReference( '/apex/ProjectTaskDetail' );
			pageRef.getParameters().put( 'id', this.taskId );
	        pageRef.setRedirect( true );
			return pageRef;
		}
		else
			return null;
	}
	
	/**
	* saves changes
	* @return null
	*/
	public PageReference SaveEdit () {
		if (this.sizeAllowed()){
			this.taskVar.notes__c = taskNotes;
			
			//update this.taskVar;
			//update Task Notes;
			DAOFactory.getInstance().updateTask( this.taskVar ); 
		}
		return null;
	}
}