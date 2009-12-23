public class NewTaskController {
	
	public String 	name 	    { set; get; }
	
	public String 	startDate 	{ set; get; }
	
	public String 	dueDate 	{ set; get; }
	
	public String 	duration 	{ set; get; }
	
	public String 	assignTo 	{ set; get; }
	
	public String 	projectId 	{ set; get; }
	
	private List<ProjectMember__c> projectMembers;

	public NewTaskController(){
		
		this.projectId = System.currentPageReference().getParameters().get('id');
		
		this.projectMembers = DAOFactory.getInstance().getProjectMembers(projectId);
		
	}
	
	public void action(){
		DAOFactory.getInstance().addTask(this.name, this.startDate, this.dueDate, this.duration, this.assignTo, this.projectId);
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