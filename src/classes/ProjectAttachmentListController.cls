/**
* @author Matias Menafra 
*/
public with sharing class ProjectAttachmentListController {
	
	public Boolean  isProduction 			{ set; get; }
	public Project project	 				{ set; get; }
	public String projectId 				{ set; get; }
	public boolean isManager 				{ set; get; }
	public Pagination paginator 			{ set; get; }
	public List<AttachmentObj> attachments	{ set; get; }
	private String projectName;
    private UserPermissions userPermission;
	
	/**
	* Constructor
	*/
	public ProjectAttachmentListController(){
		
		this.isProduction	= ProjectUtil.isProduction;
		this.project		= new Project();
		this.projectId	 	= System.currentPageReference().getParameters().get( 'id' );
		this.project.id		= this.projectId;
		
		this.userPermission = new UserPermissions();
		this.isManager 		= this.userPermission.getCanManage();
		
		this.paginator 		= new Pagination();
		
		this.loadAttachmentList();
	}
	
	public void loadAttachmentList(){
	
		this.attachments = this.project.getAttachments();
		 	
        // set pagination vars
        this.paginator.resetVars();
        this.paginator.totalItemsNumber = this.attachments.size();
        this.paginator.genCntPagination();
	}
	
    /**
    *
    * @return String
    */
    public String getProjectName(){
		String pName;
		//TODO refactor this to get project name from Project Class
		pName = [Select Id, Name from Project2__c where id =: projectId].Name;    	
		
		if( pName.length() > 24 )
			pName = pName.substring( 0, 23 );
				
		return pName;
    }
    
    /**
    * @return UserPermission
    */
    public UserPermissions getUserPermission(){
    	genPermissions();
        return this.userPermission;
    }
    
    /**
    * Static function for widgets controllers use
    * @return UserPermissions
    */
    public UserPermissions getUserPermissions(){
        return this.userPermission;
    }
	
	/**
    * Load permission for current user
    */
 	public void genPermissions(){
 		
        this.userPermission.setId( UserInfo.getUserId() );
        this.userPermission.setProject( this.projectId );
        this.userPermission.setObjectType( 'Project' );
        this.userPermission.setPermissions();
    }
    
     /**
     * Inner Classe for handling Pagination of Attachment objects 
     * in the attachment list Page 
     * @author Matias Menafra
     */
     public class Pagination{
   
	    public Integer totalItemsNumber		{ set; get; }
	    public Integer jumpPage 			{ set; get; }
	   	
	    public Integer numberOfItemsToShow	{ set; get; }
	    public Integer cntPagination		{ set; get; }
	    public Integer currentPagination 	{ set; get; }
	    public Integer firstRow 			{ set; get; }
	    
	    public boolean prevPageShow 		{ set; get; }
	    public boolean nextPageShow 		{ set; get; }
	    public boolean disabledInput 		{ set; get; } 
	    
	    /**
	    * Constructor
	    */
	    public Pagination(){
	    	
	    	this.totalItemsNumber		= 0;
		    this.jumpPage 				= 1;
		   	
		    this.numberOfItemsToShow 	= 2; 
		    this.currentPagination 		= 1;
		    this.firstRow 				= 0;
		    
		    this.prevPageShow  			= false;
		    this.nextPageShow  			= false;
		    this.disabledInput  		= false;
	    }
	    
	    /**
	    * Get disabled input (uses in jump to page)
	    * @return disbledInput
	    */
	    public boolean getDisabledInput(){
	    	
	        if( this.nextPageShow && this.prevPageShow ){
	            this.disabledInput = true;
	        }
	        else{
	            this.disabledInput = false;
	        }
	        
	        return this.disabledInput;
	    }
	       
	    /**
	    * Set total num of pages
	    */
	    public void genCntPagination(){
	    	
	        this.cntPagination = ( this.totalItemsNumber - ( Math.mod( this.totalItemsNumber, this.numberOfItemsToShow ) ) ) / this.numberOfItemsToShow;   
	        if( Math.mod( this.totalItemsNumber, this.numberOfItemsToShow ) != 0 ){
	            this.cntPagination++;
	        }  
	    }
	   
	    /**
	    * Clear pagination for re-use instance
	    */
	    public void clearPagination(){
	    	
	        this.firstRow 			= 0;
	        this.currentPagination 	= 1;
	    }
	   
	    /**
	    * Move to next page
	    */
	    public void nextPage(){
	    	
	        this.currentPagination++;
	        this.jumpPage = this.currentPagination;
	        this.firstRow = this.firstRow + this.numberOfItemsToShow;         
	    }
	   
	    /**
	    * Move to previus page
	    */
	    public void prevPage(){
	    	
	        this.currentPagination--;
	        this.jumpPage = this.currentPagination;
	        this.firstRow = this.firstRow - this.numberOfItemsToShow; 
	    }
	
	    /**
	    * Move to last page
	    */
	    public void lastPage(){
	    	
	        this.currentPagination 	= this.cntPagination;
	        this.jumpPage 			= this.cntPagination;
	        this.firstRow 			= ( this.jumpPage - 1 ) * this.numberOfItemsToShow;    
	    }
	   
	    /**
	    * Move to first page
	    */
	    public void firstPage(){
	    	
	        this.currentPagination 	= 1;
	        this.jumpPage 			= 1;
	        this.firstRow 			= ( this.jumpPage - 1 ) * this.numberOfItemsToShow;
	    }
	
	    public void refreshPages(){}
	   
	    /**
	    * Get first item
	    * @return firstRow
	    */
	    public Integer getFirstItem(){
	        return this.firstRow;
	    }
	   
	    /**
	    * Returns last item
	    * @return lastItem
	    */
	    public Integer getLastItem(){
	    	
	        Integer lastItem;
	        
	        if( ( this.currentPagination == this.cntPagination ) || ( this.currentPagination == 1 && ( this.totalItemsNumber < this.numberOfItemsToShow ) ) ){
	            lastItem = this.firstRow + Math.mod( this.totalItemsNumber, this.numberOfItemsToShow );
	        }
	        else{
	            lastItem = this.firstRow + this.numberOfItemsToShow;
	        }
	        return lastItem;
	    }
	   
	    /**
	    * Get first row
	    * @return firstRow
	    */
	    public Integer getFirstRow(){
	        return this.firstRow;
	    }
	   
	    /**
	    * Get show previus page
	    * @return prevPageShow
	    */
	    public boolean getPrevPageShow(){
	    	
	        if( this.currentPagination == 1 ){
	            this.prevPageShow = false;
	        }
	        else{
	            this.prevPageShow = true;
	        }
	        
	        return this.prevPageShow;
	    }
	
	    /**
	    * Get show next page link
	    * @return prevPageShow
	    */   
	    public boolean getNextPageShow(){
	    	
	        if( ( this.currentPagination == this.cntPagination ) || ( this.cntPagination == 0 ) ){
	            this.nextPageShow = false;
	        }
	        else{
	            this.nextPageShow = true;
	        }
	        return this.nextPageShow;
	    }  
	   
	    /**
	    * Jump to page
	    */
	    public void JumpToPage(){
	    	
	        if( this.jumpPage > this.cntPagination ){
	            this.currentPagination 	= this.cntPagination;
	            this.jumpPage 			= this.cntPagination;
	        }
	        else{
	            if( this.jumpPage < 1 ){
	                this.currentPagination 	= 1;
	                this.jumpPage 			= 1;
	            }
	            else{ 
	                this.currentPagination = this.jumpPage;
	            }
	        }
	        this.firstRow = ( this.jumpPage - 1 ) * this.numberOfItemsToShow;
	    }
	
	    /**
	    * Reset All vars
	    */       
	    public void resetVars(){
	    	
	        this.currentPagination 	= 1;
	        this.jumpPage 			= 1;
	        this.firstRow 			= 0;   
	    }
	}
	
	/*
    * Test Project Attachment List Controller
    */
    public static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
    	
    	System.currentPageReference().getParameters().put( 'id', GenerateEnvironmentTest.project.Id );
    	ProjectAttachmentListController prjAtt = new ProjectAttachmentListController();
    	
		prjAtt.loadAttachmentList();
		String prjName = prjAtt.getProjectName();
    	UserPermissions permissions = prjAtt.getUserPermission();
    	permissions = prjAtt.getUserPermissions();
    	prjAtt.genPermissions();
    	
    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    }     	
}