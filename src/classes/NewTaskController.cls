/**
* @author Andres Canavesi
*/
public class NewTaskController{
	
	private List<ProjectMember__c> projectMembers;
	public  String[] assignees 						{ set; get; }
	public  String projectId 			         	{ set; get; }
	public  ProjectTask__c myTask 		        	{ set; get; }
	public  transient String currentPage 			{ set; get; }
	public  String postAction 			        	{ set; get; }
	public  transient String taskPrefix 			{ set; get; }
	public  transient String domain					{ set; get; }
	
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
	*/
	public void action(){
		myTask.Project__c = this.projectId;
		
		DAOFactory.getInstance().insertTask( myTask, this.assignees );
		this.postAction = 'TaskCreatedSuccess';
		
		if( System.currentPageReference().getUrl().contains( 'ProjectDetail' ) ){
			this.postAction = 'ProjectDetail-TaskCreatedSuccess';
		}
		
		this.myTask = new ProjectTask__c();
	}
	
	/**
	* Method for retrieving project members
	* @return options
	*/
	public List<SelectOption> getMembers(){
		
		List<SelectOption> options = new List<SelectOption>();
		
		for( ProjectMember__c member: projectMembers ) {
    		options.add( new SelectOption( member.User__c, member.User__r.Name ) ); 
	 	}
		
		return options;
	}
	
	/**
    * Test new task overlay component
    */
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
		
		Test.setCurrentPageReference( new PageReference( 'Page.ProjectDetail' ) );
		System.currentPageReference().getParameters().put( 'id', GenerateEnvironmentTest.project.id );

		NewTaskController newTask = new NewTaskController();
		
		List<SelectOption> options = newTask.getMembers();
		ProjectTask__c task = new ProjectTask__c();
		task.Name 			= 'task 1';
        task.Project__c 	= GenerateEnvironmentTest.project.id;
        task.StartDate__c 	= Date.today();
        task.EndDate__c 	= Date.today();
        task.DurationUI__c 	= '2';
        newTask.myTask		= task;
		newTask.action();
		
		System.assertEquals( 'ProjectDetail-TaskCreatedSuccess', newTask.postAction );
		
    	Test.stopTest();
		ProjectUtil.setIsTest( false );    	
    }
}