/**
* This class manages all about pagination
* @author Andres Canavesi
* @createdAt 01/15/2010
*/
public class Paginator {
	
	public Integer pagesListSize 						{set; get;} //MUST be odd 
	public Integer qPages 								{set; get;} //number of pages
	public Integer pageNumber 							{set; get;} //current page displayed
	private Integer resultSize; 							 		//number of records 
	private Integer recordsPerPage; 							    //records per page
	public List<Integer> pages 							{set; get;} //list that appears between previous and next arrows
	public ApexPages.StandardSetController paginator 	{set; get;}
	public String filter 								{set; get;}
	public String orderBy 								{set; get;}
	public Boolean orderAsc 							{set; get;} // true if the query must return the result ASC
	public Project project 								{set; get;}
	
	/**
	* Constructor
	*/
	public Paginator(){
		
		this.project 			= new project();
		this.recordsPerPage 	= 2;
		this.resultSize 		= 0;
		
	}
		
	/**
	* Goes to a given page
	*/
	public void goToPage(){
		
		paginator.setPageNumber(pageNumber);
		pagesListConstructor();
	}
	
	/**
	* Constructs the list of pages that appears between previous and next arrows
	*/
	public void pagesListConstructor(){
		
		if(Math.mod(this.pagesListSize,2)==0){ //if is even
			this.pagesListSize+=1;
		}
		
		this.pageNumber = paginator.getPageNumber();
		
		paginator.last(); //to know number of pages
		
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
	
	/**
	* Goes to the previous page
	*/
	public void previous(){
		
		paginator.previous();
		pagesListConstructor();
	}
	
	/**
	* Goes to the last page
	*/
	public void last(){
		
		paginator.last();
		pagesListConstructor();
	}
	
	/**
	* Goes to the first page
	*/
	public void first(){
		
		paginator.first();
		pagesListConstructor();
	}
	
	/**
	* Goes to the next page
	*/
	public void next(){
		
		paginator.next();
		pagesListConstructor();
	}
	
	/**
	* @return hasNext
	*/
	public Boolean getHasNext(){
		
		return paginator.getHasNext();
	}
	
	/**
	* @return hasPrevious
	*/
	public Boolean getHasPrevious(){
		
		return paginator.getHasPrevious();
	}
	
	/**
	* @return resultSize
	*/
	public Integer getResultSize(){
	
		return this.resultSize;
	}
	
	/**
	* returns how many records must be displayed per page
	* @return recordsPerPage
	*/
	public Integer getRecordsPerPage(){
	
		return this.recordsPerPage;
	}
	
	/**
	* sets how many records must be displayed per page
	* @param recordsPerPage
	*/
	public void setRecordsPerPage(Integer recordsPerPage){
		
		this.recordsPerPage = recordsPerPage;
		paginator.setPageSize(recordsPerPage);
	}
	
	/**
	* returns the current page displayed
	* @return pageNumber
	*/
	public Integer getPageNumber(){
	
		return paginator.getPageNumber();
	}
	
	/**
	* sets the current page displayed
	* @param pageNumber
	*/
	public void setPageNumber(Integer pageNumber){
	
		paginator.setPageNumber(pageNumber);
	}
	
	/**
	* returns the list of options of records per page displayed
	* @return pageSizeItems
	*/
	public List<SelectOption> getPageSizeItems() {
		
		List<SelectOption> pageSizeItems = new List<SelectOption>();
		
		pageSizeItems.add(new SelectOption('2','2'));
		pageSizeItems.add(new SelectOption('10','10'));
		pageSizeItems.add(new SelectOption('25','25'));
		pageSizeItems.add(new SelectOption('50','50'));
		pageSizeItems.add(new SelectOption('75','75'));
		pageSizeItems.add(new SelectOption('100','100'));
		
		return pageSizeItems;
	}
	
	/**
	* sets paginator values
	*/
	public void setPaginator(){
		
		this.resultSize = this.paginator.getResultSize();
		
		this.pageNumber = 1;
		
		this.paginator.setPageSize(recordsPerPage);//records per page by default
		
		this.resultSize = paginator.getResultSize();

		this.pagesListSize = 7;
		
		this.pagesListConstructor();
	}
	
	/**
	* loads the tasks list
	*/
	public void loadTasksByProject(){
		
		this.orderAsc = !this.orderAsc;
		
		this.paginator = project.getTasks(this.filter, this.orderBy, this.orderAsc);
		
		this.setPaginator();
	}
	
	/**
	* loads project activities list
	*/
	public void loadProjectActivities(){
		
		this.paginator = DAOFactory.getInstance().getActivityForProject( this.project.id );
		this.setPaginator();
		
	}
	
	/**
	* @return tasksByProject
	*/
    public List<Task> getTasksByProject() {
    	
    	return ObjectFormatter.formatTasks( (List<ProjectTask__c>) paginator.getRecords() );
    }
    
    /**
	* @return projectActivities
	*/
    public List<Activity> getProjectActivities() {
    	
    	return ObjectFormatter.formatProjectActivities( (List<Activity__c>) paginator.getRecords() );
    }
    
}