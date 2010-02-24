/**
* This class manages all pagination
* @author Andres Canavesi
* @createdAt 01/15/2010
* @group Auxiliary Classes
*/
public class Paginator {
    
    public Integer pagesListSize                        { set; get; } //MUST be odd 
    public Integer qPages                               { set; get; } //number of pages
    public Integer pageNumber                           { set; get; } //current page displayed
    private Integer resultSize;                                       //number of records 
    private Integer recordsPerPage;                                   //records per page
    public List<Integer> pages                          { set; get; } //list that appears between previous and next arrows
    public ApexPages.StandardSetController paginator    { set; get; }
    public String filter                                { set; get; }
    public String orderBy                               { set; get; }
    public String letterChoosen                         { set; get; }
    public Boolean orderAsc                             { set; get; } // true if the query must return the result ASC
    public Project project                              { set; get; }
    public List<Letter> letters                         { set; get; }
    private List<String> lettersList;
    private String orderByOld;
    public Boolean orderByRequest                       { set; get; } //tells if user did click on a column to sort
    
    //Only for use when searching Projects and Tasks
    private String searchTerm;
    
    /**
    * Constructor
    */
    public Paginator(){
        this.project            = new project();
        this.project.id			='';
        this.recordsPerPage     = 2;
        this.resultSize         = 0;
        this.lettersList        = new List<String>{'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'};
        this.letterChoosen      = 'All'; //value by default
        this.orderByOld = null;
        this.orderAsc = true;
        this.orderByRequest = false;
    }
    
    /**----------------------------------------------- Paginator functions -------------------------------------------------------*/
        
    /**
    * Goes to a given page
    */
    public void goToPage(){
        
        paginator.setPageNumber( pageNumber );
        pagesListConstructor();
    }
    
    /**
    * Constructs the list of pages that appears between previous and next arrows
    */
    public void pagesListConstructor(){
        
        if( Math.mod( this.pagesListSize,2 ) == 0 ){ //if is even, it makes odd
            this.pagesListSize+=1;
        }
        
        this.pageNumber = paginator.getPageNumber();
        paginator.last(); //to know number of pages
        
        this.qPages = paginator.getPageNumber();
        paginator.setPageNumber( pageNumber );
        
        this.pages = new List<Integer>();
        this.pages.clear();
        Integer half = (Integer)( pagesListSize - 1 ) / 2;
        
        if( this.pagesListSize > qPages ){
            
            for( Integer i=1; i<=this.qPages; i++ ){
                this.pages.add(i);
            }
            
        }else{
        
            if( paginator.getPageNumber() >= 1 && paginator.getPageNumber() <= half ){
            
            for( Integer i=1; i<=(half*2+1); i++ ){
                this.pages.add(i);
            }
            }else{
                
                if( paginator.getPageNumber() >= qPages-half && paginator.getPageNumber() <= qPages ){
                
                    for( Integer i = qPages - ( half * 2 ); pages.size() < ( half * 2 + 1 ); i++ ){
                        this.pages.add(i);
                    }
                }else{
                    
                    for( Integer i = paginator.getPageNumber() - half; i<= paginator.getPageNumber() + half; i++ ){
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
        
        paginator.setPageNumber(pageNumber-1);
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
        
        paginator.setPageNumber(pageNumber+1);
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
    public void setRecordsPerPage( Integer recordsPerPage ){
        
        this.recordsPerPage = recordsPerPage;
        paginator.setPageSize( recordsPerPage );
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
    public void setPageNumber( Integer pageNumber ){
    
        paginator.setPageNumber( pageNumber );
    }
    
    /**
    * returns the list of options of records per page displayed
    * @return pageSizeItems
    */
    public List<SelectOption> getPageSizeItems() {
        
        List<SelectOption> pageSizeItems = new List<SelectOption>();
        
        pageSizeItems.add( new SelectOption( '2','2' ) );
        pageSizeItems.add( new SelectOption( '10','10' ) );
        pageSizeItems.add( new SelectOption( '25','25' ) );
        pageSizeItems.add( new SelectOption( '50','50' ) );
        pageSizeItems.add( new SelectOption( '75','75' ) );
        pageSizeItems.add( new SelectOption( '100','100' ) );
        
        return pageSizeItems;
    }
    
    /**
    * sets paginator values
    */
    public void setPaginator(){
        
        this.resultSize = this.paginator.getResultSize();
        this.pageNumber = 1;
        
        this.paginator.setPageSize( recordsPerPage );//records per page by default
        this.resultSize = paginator.getResultSize();
        this.pagesListSize = 7;

        this.pagesListConstructor();
    }
    
    /**
    * sets sorting criteria
    */
    private void setSorting(){
        if(this.orderByRequest){
            //user did click on a column to sort
            if(this.orderByOld == this.orderBy){
                //user pressed on the same order by link
                this.orderAsc = !this.orderAsc;
            }
        }
    }
    
    /**
    * sets some variables after loading
    */
    private void postLoad(){
        this.setPaginator();
        pagesListConstructor();
        this.orderByOld = this.orderBy;
        this.orderByRequest = false;
    }
    
    /**----------------------------------------------- End paginator functions -------------------------------------------------------*/
    
    /**----------------------------------------------- Letter filter functions -------------------------------------------------------*/
    
    /**
    * Constructs the list of letters and highlights letters that have currencies
    * @param records list
    */
    private void letterCurrenciesConstructor(List<String> records){
        this.letters = new List<Letter>();
        Map<String,Boolean> letterCurrencies = new Map<String, Boolean>();
        String firstLetter;
        //goes through the records and marks letters that have currencies
        for(String record: records){
            firstLetter = record.substring(0,1).toUpperCase();
            if(!letterCurrencies.containsKey(firstLetter)){
                letterCurrencies.put(firstLetter, true);
            }
        }
        for(String letter:this.lettersList){
            if(letterCurrencies.containsKey(letter)){
                Letter l = new Letter(letter,true);
                this.letters.add(l);
            }else{
                Letter l = new Letter(letter,false);
                this.letters.add(l);
            }
        }
    }
    
    /**
    * loads letter currencies
    * @param load type
    */
    private void loadLetterCurrencies(String loadType){
        Integer recordsPerPageAux = this.recordsPerPage;
        this.recordsPerPage=0; //this in order to bring all data
        List<String> records = new List<String>();
        if(loadType == 'TasksByProject'){
            this.paginator = project.getTasks( this.filter, this.orderBy, this.orderAsc, 'All' ); //'All' means letterChoosen='All'
            List<ProjectTask__c> tasks = (List<ProjectTask__c>) paginator.getRecords();
            for(ProjectTask__c task:tasks){
                records.add(task.Name);
            }
        }
        if(loadType == 'MembersByProject'){
            this.paginator = project.getMembers( this.filter, this.orderBy, this.orderAsc, 'All'); 
            for(ProjectMember__c member:(List<ProjectMember__c>) paginator.getRecords()){
                records.add(member.Name);
            }
        }
        
        if(loadType == 'TasksByUser'){
            this.paginator = DAOFactory.getInstance().loadTasksByUser( this.filter, this.orderBy, this.orderAsc, this.project.id, 'All' );
            List<ProjectAssignee__c> tasks = (List<ProjectAssignee__c>) paginator.getRecords();
            for(ProjectAssignee__c task:tasks){
                records.add(task.ProjectTask__r.name);
            }
        }
        letterCurrenciesConstructor(records);
        this.recordsPerPage = recordsPerPageAux;
    }
    
    /**----------------------------------------------- End letter filter functions -------------------------------------------------------*/
    
    /**----------------------------------------------- Data loaders functions ------------------------------------------------------------*/
    
    /**
    * loads the tasks list
    */
    public void loadTasksByProject(){
        loadLetterCurrencies('TasksByProject');
        setSorting();
        this.paginator = project.getTasks( this.filter, this.orderBy, this.orderAsc, this.letterChoosen );
        postLoad();
    }
    
    /**
    * loads members by project
    */
    public void loadMembersByProject(){
        loadLetterCurrencies('MembersByProject');
        setSorting();
        this.paginator = project.getMembers( this.filter, this.orderBy, this.orderAsc, this.letterChoosen );
        postLoad();
    }
    
    /**
    * loads project activities list
    */
    public void loadProjectActivities(){
        
        this.paginator = DAOFactory.getInstance().getActivityForProject( this.project.id );
        this.setPaginator();
        
    }
    
    /**
    * loads tasks search result
    */
    public void loadTaskSearchResults( String searchTerm, String namespace  ){
        
        this.searchTerm = searchTerm;
        this.paginator = DAOFactory.getInstance().searchForTaskByProject( this.project.id, searchTerm, namespace );
        this.setPaginator();
        
    }
    
    /**
    * loads project search result
    */
    public void loadProjectSearchResults( String searchTerm, String namespace  ){
        
        this.searchTerm = searchTerm;
        this.paginator = DAOFactory.getInstance().searchForProjects( searchTerm, namespace );
        this.setPaginator();
        
    }
    
    /**
    * loads the tasks list by user
    */
    public void loadTasksByUser(){
        loadLetterCurrencies('TasksByUser');
        setSorting();
        this.paginator = DAOFactory.getInstance().loadTasksByUser( this.filter, this.orderBy, this.orderAsc, this.project.id, this.letterChoosen ); 
        postLoad();
        
    }
    
    /**----------------------------------------------- End data loaders functions ------------------------------------------------------------*/
    
    /**----------------------------------------------- Data getters functions ----------------------------------------------------------------*/
    
    /**
    * @return search result
    */
    public List<SearchResults> getSearchResults (){

        if( this.project.id != null ){
            return ObjectFormatter.formatSearchResults( this.searchTerm, paginator.getRecords(), 'projectTask' );
        }
        else{
            return ObjectFormatter.formatSearchResults( this.searchTerm, paginator.getRecords(), 'project' );
        }
        
    }
    
    /**
    * @return tasks by project
    */
    public List<Task> getTasksByProject() {
        
        return ObjectFormatter.formatTasks( (List<ProjectTask__c>) paginator.getRecords() );
    }
    
    /**
    * @return members by project
    */
    public List<ProjectMember__c> getMembersByProject() {
        
        return (List<ProjectMember__c>) paginator.getRecords();
    }
    
    /**
    * @return projectActivities
    */
    public List<Activity> getProjectActivities() {
        
        return ObjectFormatter.formatProjectActivities( (List<Activity__c>) paginator.getRecords() );
    }
    
    /**
    * @return projectActivities
    */
    public  List<Task> getTasksByUser(){
        if( paginator.getRecords() != null && paginator.getRecords().size() == 0 )
            return  ObjectFormatter.formatAssigneeTask( new List<ProjectAssignee__c>() );
        else
            return  ObjectFormatter.formatAssigneeTask(( List<ProjectAssignee__c>) paginator.getRecords());
    }
    
    /**----------------------------------------------- End data getters functions ----------------------------------------------------------------*/
    
}