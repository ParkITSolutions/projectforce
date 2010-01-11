public class TaskListController {
	
	public List<Task> 	tasks 			{ set; get; }
	
	public String 	projectId 			{ set; get; }
	
	public String 	url 				{ set; get; }
	
	public Project 	project 			{ set; get; }
	
	public Project 	exceptionMessage 	{ set; get; }
	
	public String filter 				{ set; get; } //param to show all tasks by default
	
	public String orderBy 				{ set; get; }
	
	public Integer listIndex 			{ set; get; } //param to show the first page by default
	
	public Integer qtyPerPage 			{ set; get; } //quantity of tasks per page 
	
	public Boolean orderAsc 			{ set; get; }
	
	public TaskListController(){
		
		this.tasks = new List<Task>();
		
		this.projectId = System.currentPageReference().getParameters().get('id');
		
		if(this.projectId==null || this.projectId==''){
			throw new CustomException('There is not a project selected');
		}
		
		this.project = new Project(projectId);
		
		this.url = ProjectUtil.getUrl();
		
		this.filter = '1'; 
		
		this.orderBy = 'Name';
		
		this.listIndex = 0; 
		
		this.qtyPerPage = 4; 
		
		this.orderAsc = true;
		
		getTasks();
		
	}
	
	public void getTasks(){
		
		this.tasks = project.getTasks(this.filter, this.orderBy, this.orderAsc, this.listIndex, this.qtyPerPage);
	}
	
	public List<SelectOption> getFilterItems() {
		
		List<SelectOption> options = new List<SelectOption>();
		
		options.add(new SelectOption('1','All tasks'));
		
		options.add(new SelectOption('2','All milestones'));
		
		options.add(new SelectOption('3','My tasks'));
		
		options.add(new SelectOption('4','Completed tasks'));
		
		options.add(new SelectOption('5','Overdue tasks'));
		
		options.add(new SelectOption('6','Overdue milestones'));
		
		return options;
	}
	
	public void generateCSV(){
	
	}
	
	public void orderById(){
		
		this.orderAsc = !this.orderAsc;
		
		this.orderBy = 'Id__c';
		
		getTasks();
		
	}
	
	public void orderByPriority(){
		
		this.orderAsc = !this.orderAsc;
		
		this.orderBy = 'Priority__c';
		
		getTasks();
	
	}
	
	public void orderByName(){
		
		this.orderAsc = !this.orderAsc;
		
		this.orderBy = 'Name';
		
		getTasks();
	
	}
	
	public void orderByCompletedPercentage(){
		
		this.orderAsc = !this.orderAsc;
		
		this.orderBy = 'PercentCompleted__c';
		
		getTasks();
	
	}
	
	public void orderByDuration(){
		
		this.orderAsc = !this.orderAsc;
		
		this.orderBy = 'Duration__c';
		
		getTasks();
	
	}
	
	public void orderByEndDate(){
		
		this.orderAsc = !this.orderAsc;
		
		this.orderBy = 'EndDate__c';
		
		getTasks();
	
	}
	
}