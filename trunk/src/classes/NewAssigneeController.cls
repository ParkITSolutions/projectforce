/**
* @author Andres Canavesi
*/
public class NewAssigneeController{
	
	public String 	assignedToId 	{ set; get; }
	public Integer 	percentage 		{ set; get; }
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
	}

	/**
	* Action method to insert an assignee
	*/
	public void action(){
		
		ProjectTask__c task = DAOFactory.getInstance().getTask( this.taskId );
		DAOFactory.getInstance().insertAssignee( this.taskId, this.assignedToId, task.project__c, this.percentage );
	
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
	* @return percentages list
	*/
	public List<SelectOption> getPercentages(){
		
		List<SelectOption> percentages = new List<SelectOption>();
		
		for( Integer i=0; i<=100; i+=5 ){
			percentages.add( new SelectOption( i.format(), i.format() + '%' ) );
		}
	
		return percentages;
	}
	
	public void loadCandidates(){
		this.candidates = DAOFactory.getInstance().getCandidatesToAssign( this.taskId );
	}
}