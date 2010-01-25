/**
* @author Andres Canavesi
*/
public class NewTaskController {
	
	public String 	name 	    { set; get; }
	public String 	startDate 	{ set; get; }
	public String 	dueDate 	{ set; get; }
	public String 	duration 	{ set; get; }
	public String 	assignTo 	{ set; get; }
	public String 	projectId 	{ set; get; }
	private List<ProjectMember__c> projectMembers;
	public String currentPage 	{set; get;}
	public String postAction 	{set; get;}
	
	/**
	* Constructor
	*/
	public NewTaskController(){
		
		this.projectId 			= System.currentPageReference().getParameters().get( 'id' );
		this.projectMembers 	= DAOFactory.getInstance().getProjectMembers( projectId );
		this.currentPage 		= Apexpages.currentPage().getUrl();
		this.postAction 		= '';
		this.assignTo 			= '';
		
	}
	
	/**
	* Action Method which inserts the new Task
	* @return void
	*/
	public void action(){
		
		DAOFactory.getInstance().insertTask( this.name, this.startDate, this.dueDate, this.duration, this.assignTo, this.projectId, false );
		
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
}