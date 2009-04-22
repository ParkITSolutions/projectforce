/**
*@author original Bruno Fagundez @ 06/23/2008
* refactored class from team
*/
public with sharing class ProjectTaskListController {
    
    public Project2__c project = null;
    public Id USERID = UserInfo.getUserId(); 
    public Boolean editDeletePer = false;
    public boolean isProjectMember = false;
    public String PROJECTID = System.currentPageReference().getParameters().get('id');
    public String filter = System.currentPageReference().getParameters().get('filter');
    List<ProjectTask__c> ListTask = new List<ProjectTask__c>();
    public Map<String, User> mapAsignees = new Map<String, User>();
    List<TaskDetails> taskList = new List<TaskDetails>();
    String option = 'all';
    public UserPermissions userPermissions = new UserPermissions();
    public Boolean sortByDesc = false;
    public String sortBy;
    public String oldSortBy;
    
    /**
    * Set of Integers to control pagination
    */
    public Integer totalItemsNumber = taskList.size();
    public Integer numberOfItemsToShow = 18;
    public Integer cntPagination = 0;
    public Integer currentPagination = 1;
    public Integer firstRow = 0;
    
    /**
    * Set of Booleans to show or not prev / next links
    */
    public boolean prevPageLinkShow = false;
    public boolean prevPageShow  = false;
    public boolean nextPageLinkShow  = false;
    public boolean nextPageShow  = false;
    
    
    /**
    *Constructor
    */
    public ProjectTaskListController(){
        genPermissions();   
        editDeletePer = userPermissions.getCanManage();
        if(filter != null) {
        	if(filter == 'all'){
        		option = 'all';
        	}else if (filter == 'allMilestones'){
        		option = 'allMilestones';
        	}
        }
        sortBy = 'EndDate__c';
        loadProject();
		refreshTaskList();
		
        genCntPagination();
        getUserProfile();    
    }    



    /** This method recreates the task list, filtering and sorting it.
     */
    public void refreshTaskList() {
    	filterTaskList(createSortedTaskList());
    }
    
    public void loadProject(){
    	project = [Select p.Name From Project2__c p where p.id =: PROJECTID];	
    }
    

    /**
    *Clear the task list
    */
    public void reConstruct(){
        ListTask.clear();
    }

    /**
    *Get option
    *@return String
    */
    public String getOption() {
        return option;
    }
    
    /**
    *Set option
    *@param String
    */
    public void setOption(String option) {
        this.option = option;
    }
    
    /**
    *Get project id
    *@return String 
    */
    public String getProjectId() {
        return PROJECTID;
    }
    
    /**
    *Set project id
    *@param String
    */
    public void setProjectId(String sPROJECTID) {
        PROJECTID = sPROJECTID;
    }
    
    /**
    *Set user id
    *@param String
    */
    public void setUserId(String sUSERID) {
        USERID = sUSERID;
    }
    
    /**
    *Returns true if has edit/delete permission
    *@return Boolean
    */
    public Boolean getEditDeletePer(){
        return editDeletePer;
    }
    
    /**
    *Returns true if user is project member
    *@return Boolean
    */
    public Boolean getIsProjectMember(){
        return isProjectMember;
    }

    /**
    *Get user profile
    */
    public void getUserProfile(){
        
        List<ProjectMember__c> members = new List<ProjectMember__c>();
        
        members = [select tm.Id, tm.Name, tm.Profile__c 
                    from ProjectMember__c tm 
                    where tm.Project__c =: PROJECTID and tm.User__c =: USERID];
        
        if(members.size() > 0){
            isProjectMember = true;
            List<ProjectProfile__c> profile = new List<ProjectProfile__c>();
            profile = [select p.Id, p.Name 
                                        from ProjectProfile__c p
                                        where p.Id =: members[0].Profile__c];       
        }       
    }
    
    
  
 
    
    /**
    *Generates user permissions
    */
    public void genPermissions () {
        userPermissions.setId(UserInfo.getUserId());
        userPermissions.setProject(PROJECTID);
        userPermissions.setObjectType('Project');
        userPermissions.setPermissions();       
    }
    
    /**
    *Get user permissions
    *return UserPermission
    */
    public UserPermissions getUserPermissions () {
        return userPermissions;
    }
    /* ---------------------------- */  
    

    /**
    *Get task list
    *@return List<TaskDetails>
    */
    public List<TaskDetails> getTaskList(){
        return taskList;
    }
    
    /**
    *Get project's name
    *@return String
    */
    public String getNameProject(){
        return project.Name;
    }
    
    /**
    *Set project's name
    *@param String
    */
      
    
    /**
    *Set the map assignes Map<userID, User> 
    */
    public void setAllUsers() {
        // LOADING THE ASIGNEES ONLY ONCE
        if(mapAsignees.size() == 0) {
            for(User a: [select Id, Name, (select Picture__c from Project__r) from User]) {
                mapAsignees.put(a.Id, a);                           
            }
        }
    }


    
    
    /**
    *Generates number of pages
    */
    public void genCntPagination () {
        cntPagination = (totalItemsNumber - (Math.mod(totalItemsNumber, numberOfItemsToShow))) / numberOfItemsToShow;
        if (Math.mod(totalItemsNumber, numberOfItemsToShow) != 0 ) {
            cntPagination++;
        }   
    }
    
    /**
    *Set next page
    */
    public void nextPage () {
        currentPagination++;
        firstRow = firstRow + numberOfItemsToShow;          
    }
    
    /**
    *Set previous page
    */
    public void prevPage () {
        currentPagination--;
        firstRow = firstRow - numberOfItemsToShow;  
    }
    
    public void refreshPages () {
        
    }
    /**
    * Pagination Integer Getters
    */
    
    
    /**
    *Get the current page
    *@return Integer
    */
    public Integer getCurrentPagination () {
        return currentPagination;
    }

    /**
    *Get the number of pages
    *@return Integer
    */
    public Integer getCntPagination () {
        return cntPagination;
    }
    
    /**
    *Get the number of items to show
    *@return Integer
    */
    public Integer getNumberOfItemsToShow () {
        return numberOfItemsToShow;
    }
    
    /**
    *Get the number of first row in page
    *@return Integer
    */
    public Integer getFirstRow () {
        return firstRow;
    }
    
    /**
    * Pagination Boolean Getters
    */
    
    /**
    *Returns true if should show prev page link
    *@return Boolean
    */
    public boolean getPrevPageLinkShow () {
        if(currentPagination == 1){
            prevPageLinkShow = false;       
        } else {
            prevPageLinkShow = true;
        }
        return prevPageLinkShow;
    }
    
    /**
    *Returns true if should show prev page
    *@return Boolean
    */
    public boolean getPrevPageShow () {
        if(currentPagination == 1){ 
            prevPageShow = true; 
        } else {
            prevPageShow = false;
        }
        return prevPageShow;
    }
    
    /**
    *Returns true if should show next page link
    *@return Boolean
    */
    public boolean getNextPageLinkShow () {
        if((currentPagination == cntPagination) || (cntPagination == 0)){   
            nextPageLinkShow = false; 
        } else { 
            nextPageLinkShow = true;
        }          
        return nextPageLinkShow;
    }
    
    /**
    *Returns true if should show next page
    *@return Boolean
    */
    public boolean getNextPageShow () {
        if((currentPagination == cntPagination) || (cntPagination == 0)){ 
            nextPageShow = true; 
        } else { 
            nextPageShow = false;
        } 
        return nextPageShow;
    }
  
     
    public void setSortBy(String sortBy) {
    	if (this.oldSortBy != null && oldSortBy.equals(sortBy))
    		sortByDesc = !sortByDesc;
    	else
    		sortByDesc = false;
    		
    	this.oldSortBy = sortBy;
    	this.sortBy = sortBy;
    }
    
    /**
    *Returns true if is sort by description
    *@return Boolean
    */
    public Boolean getSortByDesc () {
        return !sortByDesc;
    }
    
    /**
    *Returns sort criteria
    *@return String
    */
    public String getSortBy () {
        String sbCol = '';
        if (sortBy == null || sortBy == 'Milestone__c') 
            sbCol = 'type'; 
        if (sortBy == 'Priority__c') 
            sbCol = 'priority'; 
        if (sortBy == 'Name') 
            sbCol = 'name'; 
        if (sortBy == 'User__c.Name') 
            sbCol = 'assigned'; 
        if (sortBy == 'Percent_Completed__c') 
            sbCol = 'completed';    
        if (sortBy == 'Duration__c') 
            sbCol = 'est';  
        if (sortBy == 'EndDate__c') 
            sbCol = 'date'; 
        return sbCol;
    }
    
    public String SORTBYPARAM = '';
    
    public boolean sortByParamSet = false;
    
    /**
    *Set Sort criteria
    *@param String
    */
    public void setSORTBYPARAM (String SortVal){
        sortByParamSet = true;
        SORTBYPARAM = SortVal;
    }
    
    String sortByExt ;
    
    /**
    *@param s sort by prev
    */
    public void setSortByPrev(String s){
        sortByExt = s;
    }
    
    
    /**
     * This is a temporary method to cover us until dynamic apex is back.  This will use hard coded
     * SOQL statements in place of the dynamic statements
     */
    public List<ProjectTask__c> createSortedTaskList () {
    	
        List<ProjectTask__c> resultTaskList = new List<ProjectTask__c>();
        
        setAllUsers();
        
        if (sortByDesc) {
            if (sortBy == 'Milestone__c') {
                resultTaskList = [Select 
                                         p.Project__c,
                                         p.Priority__c, 
                                         p.PercentCompleted__c,
                                         p.OwnerId, 
                                         p.Name, 
                                         p.Milestone__c, 
                                         p.Id,
                                         p.EndDate__c,
                                         p.Duration__c,
                                         (Select Id, 
                                                 User__r.Name,
                                                 User__r.Id,
                                                 User__c 
                                            From ProjectsAssignees__r), 
                                         p.Description__c 
                                         From ProjectTask__c p 
                                         where Project__c =: PROJECTID  
                                         order by Milestone__c desc];
            }
            else if (sortBy == 'Priority__c') {
                resultTaskList = [Select
                                         p.Project__c,
                                         p.Priority__c, 
                                         p.PercentCompleted__c,
                                         p.OwnerId, 
                                         p.Name, 
                                         p.Milestone__c, 
                                         p.Id,
                                         p.EndDate__c,
                                         p.Duration__c,
                                         (Select Id, 
                                                 User__r.Name,
                                                 User__r.Id,
                                                 User__c 
                                          From ProjectsAssignees__r), 
                                         p.Description__c 
                                         From ProjectTask__c p 
                                         where Project__c =: PROJECTID];               
            }   
            else if (sortBy == 'Name') {
                resultTaskList = [Select 
                                         p.Project__c,
                                         p.Priority__c, 
                                         p.PercentCompleted__c,
                                         p.OwnerId, 
                                         p.Name, 
                                         p.Milestone__c, 
                                         p.Id,
                                         p.EndDate__c,
                                         p.Duration__c,
                                         (Select Id, 
                                                 User__r.Name,
                                                 User__r.Id,
                                                 User__c 
                                          From ProjectsAssignees__r), 
                                         p.Description__c 
                                         From ProjectTask__c p 
                                         where Project__c =: PROJECTID  
                                         order by Name desc];               
            }
            else if (sortBy == 'User__c.Name') {// This one just does not work.  AssignTo cant be sorted on since it can be more then one
                resultTaskList = [Select 
                                         p.Project__c,
                                         p.Priority__c, 
                                         p.PercentCompleted__c,
                                         p.OwnerId, 
                                         p.Name, 
                                         p.Milestone__c, 
                                         p.Id,
                                         p.EndDate__c,
                                         p.Duration__c,
                                         (Select Id, 
                                                 User__r.Name,
                                                 User__r.Id,
                                                 User__c 
                                          From ProjectsAssignees__r), 
                                         p.Description__c 
                                         From ProjectTask__c p 
                                         where Project__c =: PROJECTID  
                                         order by Name desc];               
            }
            else if (sortBy == 'Percent_Completed__c') {
                resultTaskList = [Select 
                                         p.Project__c,
                                         p.Priority__c, 
                                         p.PercentCompleted__c,
                                         p.OwnerId, 
                                         p.Name, 
                                         p.Milestone__c, 
                                         p.Id,
                                         p.EndDate__c,
                                         p.Duration__c,
                                         (Select Id, 
                                                 User__r.Name,
                                                 User__r.Id,
                                                 User__c 
                                          From ProjectsAssignees__r), 
                                         p.Description__c 
                                         From ProjectTask__c p 
                                         where Project__c =: PROJECTID  
                                         order by PercentCompleted__c desc];                                     
            }
            else if (sortBy == 'Duration__c') {
                resultTaskList = [Select 
                                         p.Project__c,
                                         p.Priority__c, 
                                         p.PercentCompleted__c,
                                         p.OwnerId, 
                                         p.Name, 
                                         p.Milestone__c, 
                                         p.Id,
                                         p.EndDate__c,
                                         p.Duration__c,
                                         (Select Id, 
                                                 User__r.Name,
                                                 User__r.Id,
                                                 User__c 
                                          From ProjectsAssignees__r), 
                                         p.Description__c 
                                         From ProjectTask__c p 
                                         where Project__c =: PROJECTID  
                                         order by Duration__c desc];                  
            }
            else if (sortBy == 'EndDate__c') {
                resultTaskList = [Select 
                                         p.Project__c,
                                         p.Priority__c, 
                                         p.PercentCompleted__c,
                                         p.OwnerId, 
                                         p.Name, 
                                         p.Milestone__c, 
                                         p.Id,
                                         p.EndDate__c,
                                         p.Duration__c,
                                         (Select Id, 
                                                 User__r.Name,
                                                 User__r.Id,
                                                 User__c 
                                          From ProjectsAssignees__r), 
                                         p.Description__c 
                                         From ProjectTask__c p 
                                         where Project__c =: PROJECTID  
                                         order by EndDate__c desc];             
            }
        }
        else {
            if (sortBy == 'Milestone__c') {
                resultTaskList = [Select 
                                         p.Project__c,
                                         p.Priority__c, 
                                         p.PercentCompleted__c,
                                         p.OwnerId, 
                                         p.Name, 
                                         p.Milestone__c, 
                                         p.Id,
                                         p.EndDate__c,
                                         p.Duration__c,
                                         (Select Id, 
                                                 User__r.Name,
                                                 User__r.Id,
                                                 User__c 
                                          From ProjectsAssignees__r), 
                                         p.Description__c 
                                         From ProjectTask__c p 
                                         where Project__c =: PROJECTID  
                                         order by Milestone__c];                
            }
            else if (sortBy == 'Priority__c') {
                resultTaskList = [Select  
                                         p.Project__c,
                                         p.Priority__c, 
                                         p.PercentCompleted__c,
                                         p.OwnerId, 
                                         p.Name, 
                                         p.Milestone__c, 
                                         p.Id,
                                         p.EndDate__c,
                                         p.Duration__c,
                                         (Select Id, 
                                                 User__r.Name,
                                                 User__r.Id,
                                                 User__c 
                                          From ProjectsAssignees__r), 
                                         p.Description__c 
                                         From ProjectTask__c p 
                                         where Project__c =: PROJECTID];
                                        
                                                   
            }   
            else if (sortBy == 'Name') {
                resultTaskList = [Select  
                                         p.Project__c,
                                         p.Priority__c, 
                                         p.PercentCompleted__c,
                                         p.OwnerId, 
                                         p.Name, 
                                         p.Milestone__c, 
                                         p.Id,
                                         p.EndDate__c,
                                         p.Duration__c,
                                         (Select Id, 
                                                 User__r.Name,
                                                 User__r.Id,
                                                 User__c 
                                          From ProjectsAssignees__r), 
                                         p.Description__c 
                                         From ProjectTask__c p 
                                         where Project__c =: PROJECTID  
                                         order by Name];                
            }
            else if (sortBy == 'User__c.Name') {
                resultTaskList = [Select  
                                         p.Project__c,
                                         p.Priority__c, 
                                         p.PercentCompleted__c,
                                         p.OwnerId, 
                                         p.Name, 
                                         p.Milestone__c, 
                                         p.Id,
                                         p.EndDate__c,
                                         p.Duration__c,
                                         (Select Id, 
                                                 User__r.Name,
                                                 User__r.Id,
                                                 User__c 
                                          From ProjectsAssignees__r), 
                                         p.Description__c 
                                         From ProjectTask__c p 
                                         where Project__r.Id =: PROJECTID  
                                         order by Name];
                                                        
            }
            else if (sortBy == 'Percent_Completed__c') {
                resultTaskList = [Select 
                                         p.Project__c,
                                         p.Priority__c, 
                                         p.PercentCompleted__c,
                                         p.OwnerId, 
                                         p.Name, 
                                         p.Milestone__c, 
                                         p.Id,
                                         p.EndDate__c,
                                         p.Duration__c,
                                         (Select Id, 
                                                 User__r.Name,
                                                 User__r.Id,
                                                 User__c 
                                          From ProjectsAssignees__r), 
                                         p.Description__c 
                                         From ProjectTask__c p 
                                         where Project__c =: PROJECTID  
                                         order by PercentCompleted__c];                 
            }
            else if (sortBy == 'Duration__c') {
                resultTaskList = [Select 
                                         p.Project__c,
                                         p.Priority__c, 
                                         p.PercentCompleted__c,
                                         p.OwnerId, 
                                         p.Name, 
                                         p.Milestone__c, 
                                         p.Id,
                                         p.EndDate__c,
                                         p.Duration__c,
                                         (Select Id, 
                                                 User__r.Name,
                                                 User__r.Id,
                                                 User__c 
                                          From ProjectsAssignees__r), 
                                         p.Description__c 
                                         From ProjectTask__c p 
                                         where Project__c =: PROJECTID  
                                         order by Duration__c];               
            }
            else if (sortBy == 'EndDate__c') {
                resultTaskList = [Select 
                                         p.Project__c,
                                         p.Priority__c, 
                                         p.PercentCompleted__c,
                                         p.OwnerId, 
                                         p.Name, 
                                         p.Milestone__c, 
                                         p.Id,
                                         p.EndDate__c,
                                         p.Duration__c,
                                         (Select Id, 
                                                 User__r.Name,
                                                 User__r.Id,
                                                 User__c 
                                          From ProjectsAssignees__r), 
                                         p.Description__c 
                                         From ProjectTask__c p 
                                         where Project__c =: PROJECTID  
                                         order by EndDate__c];              
            }           
        }                
        
        
        // Sorting by priority or assignee name can't be implemented in the SOQL query
        // and require a bit of tricky
        if (sortBy == 'Priority__c')
            insertionSort(resultTaskList,sortByDesc);
		else if (sortBy.equals('User__c.Name')) {
            
            Integer n;
            Integer i;
            Integer j;
            
            n = resultTaskList.size() - 1;
              
            for (i = 1; i <= n; i++) {  
                for (j = n; j >= i ; j--) {
                    if (sortByDesc) {
                    	
                    	if (mapAsignees.get(resultTaskList[j].ProjectsAssignees__r[0].User__c).name >=
                    		mapAsignees.get(resultTaskList[j-1].ProjectsAssignees__r[0].User__c).name) {
                        	ProjectTask__c tempProjectTask;
                        	
                        	tempProjectTask = resultTaskList[j-1];
                        	resultTaskList[j-1] = resultTaskList[j];
                        	resultTaskList[j] = tempProjectTask;
                        }   
                    }
                    else {
                       if (mapAsignees.get(resultTaskList[j].ProjectsAssignees__r[0].User__c).name <=
                    		mapAsignees.get(resultTaskList[j-1].ProjectsAssignees__r[0].User__c).name) {
                        	ProjectTask__c tempProjectTask;
                        	
                        	tempProjectTask = resultTaskList[j-1];
                        	resultTaskList[j-1] = resultTaskList[j];
                        	resultTaskList[j] = tempProjectTask;
                        }   
                    }
                }
            }
        }
        		
		return resultTaskList;
    }
     
    
    /**
    *Set map piority
    *@param String key
    *@param Boolean search criteria is Description
    *@return Integer
    */
    private Integer mapPriority(String key, Boolean sortByDesc){
        if (!sortByDesc){
            if (key == 'High')
                return 3;
            else if (key == 'Medium')
                return 2;
            else if (key == 'Low')
                return 1;
            else return 4; // null value
        }else{
            if (key == 'High')
                return 1;
            else if (key == 'Medium')
                return 2;
            else if (key == 'Low')
                return 3;
            else 
                return 4; // null value
        }
    }
     
    /**
    *Sort list of task 
    *@param List<ProjectTask__c>
    *@param Boolean search criteria is Description
    */
    private void insertionSort(List<ProjectTask__c> listToOrder, Boolean sortByDesc) {
    	
        Integer i, j, current_prio;
        ProjectTask__c current;
        Integer list_size = listToOrder.size();
        
        for (i=1; i < list_size; i++){
        	
            current = listToOrder.get(i);
            current_prio = mapPriority(listToOrder.get(i).Priority__c,sortByDesc);
            
            j = i; // index of the end of sorted region
            
            while ((j > 0) && (mapPriority(listToOrder.get(j-1).Priority__c,sortByDesc) > current_prio)){
                listToOrder.set(j,listToOrder.get(j-1));
                j = j - 1;
            }
            
            listToOrder.set(j,current);
        }
    }
    
    /**
    * Get sort list option
    */
    public void filterTaskList (List<ProjectTask__c> resultTaskList) {
        List<TaskDetails> td = new List<TaskDetails>();
        List<TaskDetails> tdoTask = new List<TaskDetails>();
        List<TaskDetails> tdoMile = new List<TaskDetails>();
        List<TaskDetails> tdoComplete = new List<TaskDetails>();
        List<TaskDetails> tdoUser = new List<TaskDetails>();
        List<TaskDetails> listAllMilestones = new List<TaskDetails>();
        String opciones = this.getOption();
        
        for(Integer i=0; i < resultTaskList.size();i++){
            TaskDetails TaskDetail = new TaskDetails();
            TaskDetail.id = resultTaskList[i].Id;
            
            if(resultTaskList[i].ProjectsAssignees__r.size() > 0) {
                if(resultTaskList[i].ProjectsAssignees__r[0]!=null )
                    TaskDetail.setAsigneeName(mapAsignees.get(resultTaskList[i].ProjectsAssignees__r[0].User__c));
            } 

            TaskDetail.Name = resultTaskList[i].Name;
            String picture = TaskDetail.getAsigneeName();
            
            TaskDetail.Priority = resultTaskList[i].Priority__c;
            
            if(resultTaskList[i].EndDate__c != null) {
                // TODO cambiar a formato de mm/dd/yyyy
                TaskDetail.DueDate = ((resultTaskList[i].EndDate__c).format());
            }else {
                TaskDetail.DueDate = '';
            }
            
            TaskDetail.Estimate = (resultTaskList[i].Duration__c).intValue();
            TaskDetail.Description = resultTaskList[i].Description__c;
            TaskDetail.Milestone = resultTaskList[i].Milestone__c;
            
            if(resultTaskList[i].PercentCompleted__c!=null){
                TaskDetail.Percent_Completed= (resultTaskList[i].PercentCompleted__c).intValue();
            }else{
                TaskDetail.Percent_Completed= 0;
            }
            
            if(resultTaskList[i].EndDate__c < System.today()){
                TaskDetail.comparoFecha=true;
                TaskDetail.cantDias = resultTaskList[i].EndDate__c.daysBetween(System.today());
                
            }else{
                TaskDetail.comparoFecha=false;  
            }
            
            if(TaskDetail.comparoFecha==true && opciones.equals('oTask'))
                tdoTask.add(TaskDetail);
            if(TaskDetail.comparoFecha==true && TaskDetail.Milestone==true && opciones.equals('oMiles'))
                tdoMile.add(TaskDetail);
            if(opciones.equals('all'))
                td.add(TaskDetail);
            if(TaskDetail.Milestone && opciones.equals('allMilestones'))
                listAllMilestones.add(TaskDetail);
            if(TaskDetail.Percent_Completed==100 && opciones.equals('complete'))
                tdoComplete.add(TaskDetail);
                
            if(TaskDetail.userTask != null){   
                if(TaskDetail.userTask.Id==USERID && opciones.equals('my'))
                tdoUser.add(TaskDetail);
            }
        }
        
        if( opciones.equals('oTask')){
            totalItemsNumber = tdoTask.size();
            this.taskList=tdoTask;
        }
        if(opciones.equals('oMiles')){
            totalItemsNumber = tdoMile.size();
            this.taskList=tdoMile;
        }
        if(opciones.equals('all')){
            totalItemsNumber = td.size();
            this.taskList=td;
        }
        if(opciones.equals('allMilestones')){
            totalItemsNumber = listAllMilestones.size();
            //THERE MUST BE A SORTING BY DATE ASC
            this.taskList = listAllMilestones;
        }
        if(opciones.equals('complete')){
            totalItemsNumber = tdoComplete.size();
            this.taskList=tdoComplete;
        }
        if(opciones.equals('my')){
            totalItemsNumber = tdoUser.size();
            this.taskList=tdoUser;
        }

        firstRow = 0;
        currentPagination = 1;
        if (totalItemsNumber == 0) {
            cntPagination = 0;  
        } else {
            genCntPagination(); 
        } 
    }
  
    /* ---------------------------- */
    /*        MARK COMPLETE         */
    /* ---------------------------- */
    public String idTaskToComplete = '';
    
    /**
    *Get task to complete
    *@return String task id
    */
    public String getIdTaskToComplete () {
        return idTaskToComplete;    
    }
    
    /**
    *Set task to complete
    *@param String idTaskToComplete
    */
    public void setIdTaskToComplete (String idTaskToComplete) {
        this.idTaskToComplete = idTaskToComplete;   
    }
    
    
    /**
    * Mark Complete
    */
    public void markComplete () {
        List<String> idsUpdate = new List<String>();
        
        if (idTaskToComplete != '' && idTaskToComplete != null) {
            idsUpdate = idTaskToComplete.split(':'); 
        }
        
        if(idsUpdate.size()>0){
            List<ProjectTask__c> tasksUpdate = [select (Select User__c from ProjectsAssignees__r ), id from ProjectTask__c where id in: idsUpdate];
            
            if (tasksUpdate.size() > 0) {
                for (ProjectTask__c iterTask : tasksUpdate) {
                    Boolean cantEditAndDelete = false;
                    Integer countAssignee = 0;
                    while (!cantEditAndDelete && countAssignee < iterTask.ProjectsAssignees__r.size()) {
                        if(iterTask.ProjectsAssignees__r[countAssignee].User__c != USERID) {
                            cantEditAndDelete =  true;
                        }else {
                            countAssignee++;
                        }
                    }
                    
                    if(!cantEditAndDelete || editDeletePer || iterTask.createdById == USERID){
                        iterTask.PercentCompleted__c = 100;
                    }else {
                        throw new CustomException('Insufficient Privileges');   
                    }
                        
                }   
                update tasksUpdate;
            }else{
                throw new CustomException('Insufficient Privileges');
            }
        }
        idTaskToComplete = '';
    }
 	    
    /**
    *Class TaskDetails
    *@author Bruno Fagundez
    */
    public class TaskDetails {

            // Task Id
            public String id { get; set; }
            
            // Task Asignee
            public String AsigneeName = null;         
            
            /**
            *Assignes user to task
            *@param User
            */
            public void setAsigneeName(User u){ 
                this.userTask = u;
            }            
            
            /**
            *Get User assigned to task
            *@return String
            */
            public String getAsigneeName (){
                if(this.userTask != null){
                    if(userTask.Project__r.size() <= 0){
                        return '';
                    }else {
                        return userTask.Project__r[0].Picture__c;
                    }
                }else {
                    return '';
                }
             
            }

            // Is Task Owner
            public boolean isTaskOwner {
                get;
                set ;
            }
            
            // Task Name
            public String Name { get; set; }
                        
            // Project Name
            public String ProjectName { get; set; }
            
            // Priority
            public String Priority { get; set; }
            
            // Start Date
            public String StartDate { get; set; }
            
            // Due Date
            public String DueDate { get; set; } 
            
            // Estimated Time 
            public Integer Estimate { get; set; }
            
            // Description 
            public String Description { get; set; } 
            
            public boolean Milestone { 
                get { 
                    return Milestone; 
                }
                set {
                    Milestone = value;
                }
            }
            
            public Integer Percent_Completed { 
                get; set; 
            }  
            
            public boolean comparoFecha { 
                get; set; 
            }
            
            public Integer cantDias { 
                get; set; 
            }  
            
            public User userTask { 
                get; set; 
            }  
            
            public Boolean canEditAndDelete { 
                get; set; 
            } 
                
    }
    
}