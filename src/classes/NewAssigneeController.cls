/**
* @author Andres Canavesi
*/
public class NewAssigneeController{
	
	public String[] assignees		{ set; get; }
	public String   postAction 	    { set; get; }
	public String   taskId 	    	{ set; get; }
	public String   projectId 	    { set; get; }
	private List<ProjectMember__c> candidates;
	
	/**
	* Constructor
	*/
	public NewAssigneeController(){
		
		this.taskId 	= System.currentPageReference().getParameters().get( 'id' ); 
		this.candidates = new List<ProjectMember__c>();
		this.assignees 	= new String[]{};
	}

	/**
	* Action method to insert an assignee
	*/
	public void action(){
		
		ProjectTask__c task = DAOFactory.getInstance().getTask( this.taskId );
		DAOFactory.getInstance().insertAssignees( this.taskId, this.assignees, task.project__c );
		
		this.postAction = 'MemberAssignedSuccess';
	
	}
	
	/**
	* @return members candidates to assigned
	*/
	public List<SelectOption> getCandidatesToAssign(){
		
		List<SelectOption> members = new List<SelectOption>();
		
		for( ProjectMember__c candidate :this.candidates ){
			members.add( new SelectOption( candidate.User__c, candidate.Name ) ); 
		}
		
		return members;
	}
	
	/**
	* 
	*/
	public void loadCandidates(){
		this.candidates = DAOFactory.getInstance().getCandidatesToAssign( this.taskId );
	}
	
	/**
    * Test new assignee overlay component
    */
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
    	
    	System.currentPageReference().getParameters().put( 'id', GenerateEnvironmentTest.task.Id );
		NewAssigneeController newAssignee = new NewAssigneeController();
		
		newAssignee.loadCandidates();
		List<SelectOption> members = newAssignee.getCandidatesToAssign();
		newAssignee.assignees.add( members.get(0).getValue() ); 
		newAssignee.action();
		
		System.assertEquals( 'MemberAssignedSuccess', newAssignee.postAction );
		
    	Test.stopTest();
		ProjectUtil.setIsTest( false );    	
    }
}