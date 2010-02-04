/**
* @author Andres Canavesi
*/
public class NewTaskController {
	
	public String 	assignTo 	{ set; get; }
	public String 	projectId 	{ set; get; }
	private List<ProjectMember__c> projectMembers;
	public ProjectTask__c myTask {set; get;}
	public String currentPage 	{set; get;}
	public String postAction 	{set; get;}
	public String  taskPrefix = Schema.SObjectType.Projecttask__c.getKeyPrefix();
	
	public String domain;
	
	/**
	* Constructor
	*/
	public NewTaskController(){
		
		myTask = new  ProjectTask__c();
		domain = ProjectUtil.getDomain();
		this.projectId 			= System.currentPageReference().getParameters().get( 'id' );
		this.projectMembers 	= DAOFactory.getInstance().getProjectMembers( this.projectId );
		this.currentPage 		= Apexpages.currentPage().getUrl();
		this.postAction 		= '';
		this.assignTo 			= '';
	
	}
	
	/**
	* Action Method which inserts the new Task
	* @return void
	*/
	public void action(){
		
		myTask.Project__c = this.projectId;
		
		DAOFactory.getInstance().insertTask( myTask, this.assignTo );
		
		if( this.currentPage.contains( 'TaskList' ) ){
			this.postAction = 'TaskCreatedSuccess';
		}
	}
	
	/**
	* Method for retrieving project members
	* @return List<SelectOption>
	*/
	public List<SelectOption> getMembers() {
		
		List<SelectOption> options = new List<SelectOption>();
		options.add( new SelectOption( '-1', 'Choose a project Member' ) );
		
		for( ProjectMember__c member: projectMembers ) {
    		options.add( new SelectOption( member.User__c, member.User__r.Name ) ); 
	 	}
		
		return options;
	}
	
	/**
	*@return String
	*/
	public String getDomain(){
		return this.domain;
	}
	
	/**
   	*@return taskPrefix
   	*/
   	public String getTaskPrefix(){
   		return taskPrefix;
   	}
}