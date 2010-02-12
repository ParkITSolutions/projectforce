/**
* @author Andres Canavesi
*/
public class NewTaskController {
	
	private transient List<ProjectMember__c> projectMembers;
	public transient String[] assignees 		{ set; get; }
	public transient String projectId 			{ set; get; }
	public transient ProjectTask__c myTask 		{ set; get; }
	public transient String currentPage 		{ set; get; }
	public transient String postAction 			{ set; get; }
	public transient String taskPrefix 			{ set; get; }
	public transient String domain				{ set; get; }
	
	/**
	* Constructor
	*/
	public NewTaskController(){
		
		this.myTask 			= new  ProjectTask__c();
		this.domain 			= ProjectUtil.getDomain();
		this.projectId 			= System.currentPageReference().getParameters().get( 'id' );
		this.projectMembers 	= DAOFactory.getInstance().getProjectMembers( this.projectId );
		this.currentPage 		= Apexpages.currentPage().getUrl();
		this.taskPrefix			= Schema.SObjectType.Projecttask__c.getKeyPrefix();
		this.postAction 		= '';
		this.assignees 			= new String[]{};
	
	}
	
	/**
	* Action Method which inserts the new Task
	* @return void
	*/
	public void action(){
		
		myTask.Project__c = this.projectId;
		DAOFactory.getInstance().insertTask( myTask, this.assignees );
		
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
		
		for( ProjectMember__c member: projectMembers ) {
    		options.add( new SelectOption( member.User__c, member.User__r.Name ) ); 
	 	}
		
		return options;
	}
}