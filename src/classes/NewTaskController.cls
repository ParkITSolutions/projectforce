public class NewTaskController {
	
	public String 	name 	    { set; get; }
	
	public String 	startDate 	{ set; get; }
	
	public String 	dueDate 	{ set; get; }
	
	public String 	duration 	{ set; get; }
	
	public String 	assignTo 	{ set; get; }
	
	public String 	projectId 	{ set; get; }
	
	private List<ProjectMember__c> projectMembers;
	
	public String currentPage {set; get;}
	
	public String postAction {set; get;}

	public NewTaskController(){
		
		this.projectId = System.currentPageReference().getParameters().get('id');
		
		this.projectMembers = DAOFactory.getInstance().getProjectMembers(projectId);
		
		this.currentPage = Apexpages.currentPage().getUrl();
		
		this.postAction = '';
		
		this.assignTo = '';
		
	}
	
	public void action(){
		
		DAOFactory.getInstance().insertTask(this.name, this.startDate, this.dueDate, this.duration, this.assignTo, this.projectId, false);
		
		if(this.currentPage.contains('TaskList')){
			
			this.postAction = 'TaskCreatedSuccess';
		}
	}
	
	public List<SelectOption> getMembers() {
		
		List<SelectOption> options = new List<SelectOption>();
		
		options.add(new SelectOption('-1', 'Choose a project Member'));
		
		for(ProjectMember__c member: projectMembers) {
    		
    		options.add(new SelectOption(member.User__c, member.User__r.Name)); 
	 	}
		
		return options;
	}
}