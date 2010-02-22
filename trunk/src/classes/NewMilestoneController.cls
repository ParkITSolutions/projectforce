/**
* @author Andres Canavesi
*/
public class NewMilestoneController {
	
	private List<ProjectMember__c> projectMembers;
	public  String[] assignees 						{ set; get; }
	public  String projectId 						{ set; get; }
	public  ProjectTask__c myTask 					{ set; get; }
	public  transient String currentPage 			{ set; get; }
	public  String postAction 						{ set; get; }
	public  transient String taskPrefix 			{ set; get; }
	public  transient String domain					{ set; get; }
     
	/**
	* Constructor
	*/
	public NewMilestoneController(){
		
		this.myTask 			= new ProjectTask__c();
		this.domain 			= ProjectUtil.getDomain();
		this.projectId 			= System.currentPageReference().getParameters().get( 'id' );
		this.projectMembers 	= DAOFactory.getInstance().getProjectMembers( this.projectId );
		this.currentPage		= Apexpages.currentPage().getUrl();
		this.postAction 		= '';
		this.assignees 			= new String[]{};
		this.taskPrefix			= Schema.SObjectType.Projecttask__c.getKeyPrefix();

	}
	
	/**
	* Action Method which inserts the new Milestone
	* @return void
	*/
	public void action(){
		myTask.Project__c 	= this.projectId;
		myTask.Milestone__c = true;
		DAOFactory.getInstance().insertTask( myTask, this.assignees );
		this.postAction = 'MilestoneCreatedSuccess';
		if(System.currentPageReference().getUrl().contains('ProjectDetail')){
			this.postAction = 'ProjectDetail-MilestoneCreatedSuccess';
		}
		this.myTask 			= new ProjectTask__c();
	}
	
	/**
	* Method for retrieving project members
	* @return List<SelectOption>
	*/
	public List<SelectOption> getMembers() {
		
		List<SelectOption> options = new List<SelectOption>();

		for( ProjectMember__c member: projectMembers ) {
    		options.add(new SelectOption( member.User__c, member.User__r.Name ) ); 
	 	}
		
		return options;
	}
}