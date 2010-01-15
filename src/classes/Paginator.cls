public class Paginator {
	
	public Integer pagesListSize 			{ set; get; } //MUST be odd 
	
	public Integer qPages {set; get;} //number of pages
	
	public Integer pageNumber {set; get;} //current page displayed
	
	public Integer resultSize {set; get;} //number of records 
	
	public List<Integer> 	pages 			{ set; get; }
	
	public List<ProjectTask__c> 	tasksByProject;
	
	public ApexPages.StandardSetController paginator { set; get; }
	
	public String filter { set; get; }
	
	public String orderBy { set; get; }
	
	public Boolean orderAsc { set; get; }
	
	public Project project { set; get; }
	
	public Paginator(){
		
		this.project = new project();
		
	}
	
	public Paginator(String typeOf){
		
		if(typeOf == 'Tasks'){
			
		}
		
	}
	
	public void refreshTasksByProject(){
		
		this.paginator = project.getTasks(this.filter, this.orderBy, this.orderAsc);
		
		setDefault();
	}
	
	public void loadTasksByProject(){
		
		this.paginator = project.getTasks(this.filter, this.orderBy, this.orderAsc);
		
		this.pageNumber = 1;
			
		this.paginator.setPageSize(2);//records per page
		
		this.resultSize = paginator.getResultSize();

		this.pagesListSize = 7;
		
		pagesListConstructor();
	}
	
	public void setDefault(){
		
		this.pageNumber = 1;
		
		this.resultSize = paginator.getResultSize();

		this.pagesListSize = 7;
		
		pagesListConstructor();
	}
	
	public void goToPage(){
		
		paginator.setPageNumber(pageNumber);
		
		pagesListConstructor();
	}
	
	public void pagesListConstructor(){
		
		if(Math.mod(this.pagesListSize,2)==0){ //if is even
			
			this.pagesListSize+=1;
		}
		
		this.pageNumber = paginator.getPageNumber();
		
		paginator.last(); //to know # of pages
		
		this.qPages = paginator.getPageNumber();
		
		paginator.setPageNumber(pageNumber);
		
		this.pages = new List<Integer>();
		
		this.pages.clear();
		
		Integer half = (Integer)(pagesListSize-1)/2;
		
		if(this.pagesListSize > qPages){
			
			for(Integer i=1; i<=this.qPages; i++){
				this.pages.add(i);
			}
			
		}else{
		
			if(paginator.getPageNumber() >= 1 && paginator.getPageNumber() <= half){
			
			for(Integer i=1; i<=(half*2+1); i++){
				this.pages.add(i);
			}
			}else{
				
				if(paginator.getPageNumber() >= qPages-half && paginator.getPageNumber() <= qPages){
				
					for(Integer i=qPages-(half*2); pages.size()<(half*2+1); i++){
						this.pages.add(i);
					}
				}else{
					
					for(Integer i=paginator.getPageNumber()-half; i<=paginator.getPageNumber()+half; i++){
						
						this.pages.add(i);
					}
				}
			}
		}
		
	}
	
	public void previous(){
		
		paginator.previous();
		
		pagesListConstructor();
	}
	
	public void last(){
		
		paginator.last();
		
		pagesListConstructor();
	}
	
	public void first(){
		
		paginator.first();
		
		pagesListConstructor();
	}
	
	public void next(){
		
		paginator.next();
	
		pagesListConstructor();
	}
	
	public Boolean getHasNext(){
		
		return paginator.getHasNext();
	}
	
	public Boolean getHasPrevious(){
		
		return paginator.getHasPrevious();
	}
	
	public Integer getResultSize(){
	
		return paginator.getResultSize();
	}
	
	public Integer getPageSize(){
	
		return paginator.getPageSize();
	}
	
	public void setPageSize(Integer value){
		
		paginator.setPageSize(value);
	}
	
	public Integer getPageNumber(){
	
		return paginator.getPageNumber();
	}
	
	public void setPageNumber(Integer value){
	
		paginator.setPageNumber(value);
	}
	
	public List<SelectOption> getPageSizeItems() {
		
		List<SelectOption> options = new List<SelectOption>();
		
		options.add(new SelectOption('2','2'));
		
		options.add(new SelectOption('10','10'));
		
		options.add(new SelectOption('25','25'));
		
		options.add(new SelectOption('50','50'));
		
		options.add(new SelectOption('75','75'));
		
		options.add(new SelectOption('100','100'));
		
		return options;
	}
	
	public void refreshPaginator(){
		
		pagesListConstructor();
	}
    
    public List<Task> getTasksByProject() {
    	
    	List<Task> tasks = new List<Task>();
    	
    	for(ProjectTask__c task : (List<ProjectTask__c>) paginator.getRecords()){
    		
    		Task taskAux = new Task();
    		
    		taskAux.id = task.id;
			taskAux.idDisplay = task.Id__c;
			taskAux.name = task.Name; 
			taskAux.isMilestone = task.Milestone__c;
			taskAux.priority = task.Priority__c; 
			taskAux.setPercentCompleted( task.PercentCompleted__c );
			taskAux.durationDisplay = String.valueOf(task.Duration__c);
			
			if( task.Milestone__c ){
				taskAux.endDateDisplay = String.valueOf(task.StartDate__c.format());
				taskAux.endDate = task.StartDate__c;
			}else{
				taskAux.endDateDisplay = String.valueOf(task.EndDate__c.format());
				taskAux.endDate = task.EndDate__c;
			}
			
			//TODO change ProjectMember to TaskAssignee
			List<ProjectMember> assignees = DAOFactory.getInstance().getAssignees(taskAux.id);
			
			taskAux.assignees = assignees;
    		
    		tasks.add(taskAux);
    		
    	}
    	
    	//return (List<ProjectTask__c>) paginator.getRecords();
    	
    	return tasks;
    }
    
}