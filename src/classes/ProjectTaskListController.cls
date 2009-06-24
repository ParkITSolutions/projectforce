/** 
* Project Task List
*@author original Bruno Fagundez @ 06/23/2008
*/
public with sharing class ProjectTaskListController {
    
    public Project2__c project = null ;
    public Id USERID = UserInfo.getUserId(); 
    public Boolean editDeletePer = false;
    public boolean isProjectMember = false;
    public String PROJECTID = System.currentPageReference().getParameters().get('id');
    public String csvFileId = '';
    
    public String filter = System.currentPageReference().getParameters().get('filter');
    public Filter advanceFilter = new Filter(PROJECTID);
    public Boolean filterApplyed = false;
    
    public List<ProjectTask__c> ListTask = new List<ProjectTask__c>();
    public Map<String, User> mapAsignees = new Map<String, User>();
    public List<TaskDetails> taskList = new List<TaskDetails>();

    public UserPermissions userPermissions = new UserPermissions();
    
    public String option = 'all';    
    public Boolean sortByDesc = false;
    public String sortBy;
    public String oldSortBy;
    public String idTaskToComplete = '';
    
    public String domain = ProjectUtil.getDomain();

    /**
    * Set of Integers to control pagination
    */
    public Integer totalItemsNumber = taskList.size();
    public Integer numberOfItemsToShow = 10;
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
    * Constructor
    */
    public ProjectTaskListController(){
    	        
        //Read permissions
        genPermissions();   
        
        //Set edit/delete permissions
        editDeletePer = userPermissions.getCanManage();
        
        //Quick filter
        if(filter != null) {
        	if(filter == 'all'){
        		option = 'all';
        	}else if (filter == 'allMilestones'){
        		option = 'allMilestones';
        	}
        }
        
        //Set default order
        sortBy = 'EndDate__c';
        
        //Read Project
        loadProject();
        
        //Read Project Task
		refreshTaskList();
		
		//Generate Pagination
        genCntPagination();
        
        //Read current user profile
        getUserProfile();

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
    *@return csv file id
    */
    public String getCsvFileId(){
    	return csvFileId;
    }
    
    /**
    *@return Filter Instance
    */
    public Filter getFilter(){
    	return advanceFilter;
    }
    
    /**
    *@param advance filter
    */
    public void setFilter (Filter f){
    	advanceFilter = f;
    }
    
    /**
    *@return filter is applyed
    */
    public Boolean getFilterApplyed (){
    	return filterApplyed;
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
    *Returns the Task list size
    *@return Integer
    */
    public Integer getTotalItemsNumber(){
        return totalItemsNumber;
    }

    /**
    *Get user profile
    */
    public void getUserProfile(){
        
        List<ProjectMember__c> members = new List<ProjectMember__c>();
        members = [select tm.Id, tm.Name, tm.Profile__c from ProjectMember__c tm where tm.Project__c =: PROJECTID and tm.User__c =: USERID];
        
        if(members.size() > 0){
            isProjectMember = true;
            List<ProjectProfile__c> profile = new List<ProjectProfile__c>();
            profile = [select p.Id, p.Name from ProjectProfile__c p where p.Id =: members[0].Profile__c];       
        }       

    }

    /** This method recreates the task list, filtering and sorting it.
     */
    public void refreshTaskList() {
    	filterTaskList(createSortedTaskList());
    }
    
    public void loadProject(){
    	Project2__c prTemp = new Project2__c();

    	
    	if(project == null)
    		prTemp = [ select p.Name from Project2__c p where p.id =: PROJECTID limit 1 ];
    		project = prTemp;	
    }
    
    /**
    *Clear the task list
    */
    public void reConstruct(){
        ListTask.clear();
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
    
    public void refreshPages () {}

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
        if (sortBy == 'Id__c') 
            sbCol = 'autoId'; 
        if (sortBy == 'Priority__c') 
            sbCol = 'priority'; 
        if (sortBy == 'Name') 
            sbCol = 'name'; 
        if (sortBy == 'Status__c') 
            sbCol = 'status'; 
        if (sortBy == 'User__c.Name') 
            sbCol = 'assigned'; 
        if (sortBy == 'PercentCompleted__c') 
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
    *@return String
    */
    public String getDomain(){
    	return this.domain;
    }
    
    /**
     * This is a temporary method to cover us until dynamic apex is back.  This will use hard coded
     * SOQL statements in place of the dynamic statements
     */
    public List<ProjectTask__c> createSortedTaskList () {
    	
    	setAllUsers();
        List<ProjectTask__c> resultTaskList = new List<ProjectTask__c>();
			
		/* ### Apply filter ### */
			
		String filter = '';
       		
		//Filter by Name
		if(advanceFilter.name != null && !advanceFilter.name.equals(''))
			filter += ' and Name like \'' + advanceFilter.name + '%\'';
				
		//Filter by Pririty
		if(advanceFilter.priority != null && !advanceFilter.priority.equals(''))
			filter += ' and Priority__c = \'' + advanceFilter.priority + '\'';				
		
		//Filter by Status
		if(advanceFilter.status != null && !advanceFilter.status.equals(''))
			filter += ' and Status__c = \'' + advanceFilter.status + '\'';
				
		//Filter by Estimate
		if(advanceFilter.estimate != null && !advanceFilter.estimate.equals(''))
			filter += ' and Duration__c = ' + Double.valueOf(advanceFilter.estimate);				

		//Set flag true if filter is applyed
		if(!filter.equals('')){
			filterApplyed = true;
		}
		else
			filterApplyed = false;
			
	    /* ### Build dynamic query ### */
		    
	    Map<String, Schema.SObjectField> projectFields = Schema.SObjectType.ProjectTask__c.fields.getMap();
	    String fields = '';
	    String query = '';
	    
	    //Set object fields
	    for(Schema.SObjectField field : projectFields.values()){
	    	if(field != null)
	    		fields += (field + ', ');
	    }				
			
		//Build query statement
		query += 'select ' + fields + '(SELECT Id, User__r.Name, User__r.Id, User__c FROM ProjectsAssignees__r)';
		query += ' from ProjectTask__c where Project__c = \'' + PROJECTID + '\'' + filter;
		
		//Set order clause
		if( sortBy != 'Priority__c' && !sortBy.equals('User__c.Name'))
			query +=	' order by ' + sortBy + ' ' + ( sortByDesc ? ' desc ' : ' asc ');
					
		//Execute query
		resultTaskList = Database.query(query);
		
        /* ### Apply Sort ### */
        
        // Sorting by priority or assignee name can't be implemented in the SOQL query
        // and require a bit of tricky
        if (sortBy == 'Priority__c'){
            insertionSort(resultTaskList,sortByDesc);
		}else if (sortBy.equals('User__c.Name')){
   			
            Integer n;
            Integer i;
            Integer j;
            Integer k;
            String tempName = '';
            
            n = resultTaskList.size() - 1;
            for (i = 1; i <= n; i++) {  
                for (j = n; j >= i ; j--) {
                    if (sortByDesc) {
                    	if( resultTaskList[j-1].ProjectsAssignees__r.size() > 0 && resultTaskList[j].ProjectsAssignees__r.size() > 0 ){
	                    	if (mapAsignees.get(resultTaskList[j].ProjectsAssignees__r[0].User__c).name >=
	                    		mapAsignees.get(resultTaskList[j-1].ProjectsAssignees__r[0].User__c).name) {
	                        	ProjectTask__c tempProjectTask;
	                        	
	                        	tempProjectTask = resultTaskList[j-1];
	                        	resultTaskList[j-1] = resultTaskList[j];
	                        	resultTaskList[j] = tempProjectTask;
	                        }
                    	}else{
                    		k = 1;
                    		for( Integer l = j-1; l > 0; l--){
                    			if( resultTaskList[ j-k ].ProjectsAssignees__r.size() > 0 ){
	                    			tempName = mapAsignees.get(resultTaskList[j-k].ProjectsAssignees__r[0].User__c).name;
	                    			break;
	                    		}else{
	                    			tempName = '';
	                    		}
								k++;					
                    		}
							if (tempName >= '') {
	                        	ProjectTask__c tempProjectTask;
	                        	
	                        	tempProjectTask = resultTaskList[j-k];
	                        	resultTaskList[j-k] = resultTaskList[j];
	                        	resultTaskList[j] = tempProjectTask;
	                        }	                    	
                    	}
                    } else {
                    	if( resultTaskList[j-1].ProjectsAssignees__r.size() > 0 && resultTaskList[j].ProjectsAssignees__r.size() > 0 ){
	                       	if (mapAsignees.get(resultTaskList[j].ProjectsAssignees__r[0].User__c).name <=
	                    		mapAsignees.get(resultTaskList[j-1].ProjectsAssignees__r[0].User__c).name) {
	                        	ProjectTask__c tempProjectTask;
	                        	
	                        	tempProjectTask = resultTaskList[j-1];
	                        	resultTaskList[j-1] = resultTaskList[j];
	                        	resultTaskList[j] = tempProjectTask;
	                    	}
                    	}else{
                    		k = 1;
                    		for( Integer l = j-1; l > 0; l--){
                    			if( resultTaskList[ j-k ].ProjectsAssignees__r.size() > 0 ){
	                    			tempName = mapAsignees.get(resultTaskList[j-k].ProjectsAssignees__r[0].User__c).name;
	                    			break;
	                    		}else{
	                    			tempName = '';
	                    		}
								k++;					
                    		}
							if (tempName <= '') {
	                        	ProjectTask__c tempProjectTask;
	                        	
	                        	tempProjectTask = resultTaskList[j-k];
	                        	resultTaskList[j-k] = resultTaskList[j];
	                        	resultTaskList[j] = tempProjectTask;
	                        }	                    	
                    	}  
                    }
                }
            }
        }
			
		//Filter by Assignee - Ninja Way 
		if(advanceFilter.assignee != null && !advanceFilter.assignee.equals('')){
			filterApplyed = true;
			List<ProjectTask__c> teampTaskList = new List<ProjectTask__c>(); 
			//Iterate Task
			for(ProjectTask__c task : resultTaskList){
				//Iterate Assignees
				for(ProjectAssignee__c taskAssignee : task.ProjectsAssignees__r){
					if(taskAssignee.User__c == advanceFilter.assignee){
						teampTaskList.add(task);
					}
				}
			}
			resultTaskList.clear();
			resultTaskList = teampTaskList;
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
    	System.debug( '>>' + listToOrder.size());
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
    	System.debug( '>*>' + listToOrder.size());
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

       	//Test for dynamic columns
		List<String> selectedFields = new List<String> {'Name', 'Priority__c', 'EndDate__c'};
        
        for(Integer i=0; i < resultTaskList.size();i++){
            
            //Test for dynamic columns
            for(String field : selectedFields){
            	System.debug('HERE: ' + field + ' value: ' + resultTaskList[i].get(field));
            }
            
            TaskDetails TaskDetail = new TaskDetails();
            TaskDetail.id = resultTaskList[i].Id;
            
            //Task Assignees
            if(resultTaskList[i].ProjectsAssignees__r.size() > 0) {
                if(resultTaskList[i].ProjectsAssignees__r[0] != null )
                    TaskDetail.setAsigneeName(mapAsignees.get(resultTaskList[i].ProjectsAssignees__r[0].User__c));
            	//All assignees names for tooltip
            	String allAssigneesNames = 'All Assignees: ';
            	for(ProjectAssignee__c taskAssignee : resultTaskList[i].ProjectsAssignees__r){
            		allAssigneesNames += mapAsignees.get(taskAssignee.User__c).Name + ', '; 	
            	}
            	TaskDetail.setAllAssingneesNames(allAssigneesNames.substring(0, (allAssigneesNames.length() - 2)));
            } 

            TaskDetail.Name = resultTaskList[i].Name;
            String picture = TaskDetail.getAsigneeName();
            
            //Pririty
            TaskDetail.Priority = resultTaskList[i].Priority__c;
            
            //End Date
            if(resultTaskList[i].EndDate__c != null) {
                // TODO cambiar a formato de mm/dd/yyyy
                TaskDetail.DueDate = ((resultTaskList[i].EndDate__c).format());
            }else {
                TaskDetail.DueDate = '';
            }
            
            TaskDetail.Estimate = resultTaskList[i].Duration__c;
            TaskDetail.Description = resultTaskList[i].Description__c;
            TaskDetail.Milestone = resultTaskList[i].Milestone__c;
            TaskDetail.status = resultTaskList[i].status__c;
            TaskDetail.autoId = resultTaskList[i].id__c;
            
            TaskDetail.isTaskOwner = resultTaskList[i].createdById == USERID;
            
            if(resultTaskList[i].ProjectsAssignees__r.size() > 0)
            	TaskDetail.canEditAndDelete = (resultTaskList[i].ProjectsAssignees__r[0].User__c == USERID ) ? true : false;
			
			System.debug( '[1>' + resultTaskList[i].PercentCompleted__c );
            if(resultTaskList[i].PercentCompleted__c != null){
                TaskDetail.PercentCompleted= (resultTaskList[i].PercentCompleted__c).intValue();
            }else{
                TaskDetail.PercentCompleted= 0;
            }
			System.debug( '[2>' + resultTaskList[i].PercentCompleted__c );
            
            if(resultTaskList[i].EndDate__c < System.today()){
                TaskDetail.comparoFecha=true;
                TaskDetail.cantDias = resultTaskList[i].EndDate__c.daysBetween(System.today());
                
            }else{
                TaskDetail.comparoFecha = false;  
            }
            
            if(TaskDetail.comparoFecha == true && opciones.equals('oTask'))
                tdoTask.add(TaskDetail);
            if(TaskDetail.comparoFecha == true && TaskDetail.Milestone==true && opciones.equals('oMiles'))
                tdoMile.add(TaskDetail);
            if(opciones.equals('all'))
                td.add(TaskDetail);
            if(TaskDetail.Milestone && opciones.equals('allMilestones'))
                listAllMilestones.add(TaskDetail);
            if(TaskDetail.PercentCompleted==100 && opciones.equals('complete'))
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
    public void setIdTaskToComplete (String i) {
         this.idTaskToComplete = i;   
     }    

    /**
    * Mark Complete
    */
    public void markComplete () {
        List<String> idsUpdate = new List<String>();
                    
        if (idTaskToComplete != '' && idTaskToComplete != null) {
            idsUpdate = getIdTaskToComplete().split(':'); 
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
    * Export the task list into a csv file
    */
 	public void generateTaskListCsv() {
    	
	    String csvText = 'ID,Type,Priority,Name,Description,Status,AssignedTo,PercentCompleted,Duration,DueDate,DaysLate\n';		        
              
	    for (TaskDetails iterTask : taskList) {
	    	
	    	csvText += iterTask.autoId + ',';            
	    	
	    	if (iterTask.Milestone)            
	    		csvText += 'Milestone,';
	    	else            
	    		csvText += 'Task,';
	    		
	    	csvText += iterTask.Priority + ',';            
	    	csvText += iterTask.Name + ',';   
	    	
	    	String description;
	    	if(iterTask.Description != null){
	    		description  = iterTask.Description.replaceAll('\r\n', ' ');
	    		description  = description.replaceAll(',', ' ');
	    	}
	    	
	    	csvText += description + ',';            
	    	csvText += iterTask.Status + ',';            
	    	csvText += iterTask.UserTask.name + ',';
	    	csvText += iterTask.PercentCompleted + ',';
	    	csvText += iterTask.Estimate + ',';
	    	csvText += iterTask.DueDate + ',';
	    	csvText += iterTask.CantDias + '\n';           
	              
	    }
	    
	    List<Attachment> attachs =  new List<Attachment>();
	    Attachment doc = null;
	    
	    attachs = [select Id, Name from Attachment where Name = 'pf__export.csv'];
	    if(attachs.size() > 0)
	    	doc = attachs[0];
	    else{
	    	doc = new Attachment();
	    	doc.ParentId = PROJECTID;
			doc.Name = 'pf__export.csv';
	    }

	    doc.Body = Blob.valueOf(csvText);
	    doc.ContentType = 'text/csv';
	    
	    upsert doc;
	    csvFileId = doc.Id;
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
	    public String allAssignees = null;       
    
	    /**
	    *Assignes user to task
	    *@param User
	    */
	    public void setAsigneeName(User u){ 
	        this.userTask = u;
	    }            
    
	    /**
	    *@return all assignees name for title attr.
	    */
	    public String getAllAssingneesNames (){
	    	return allAssignees;
	    }
	    
	    /**
	    *@param assignees names
	    */
	    public void setAllAssingneesNames(String names){
	    	allAssignees = names;	
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
        public String ProjectName { get; set;}
        
        // Priority
        public String Priority { get; set; }
        
        // Start Date
        public String StartDate { get; set; }
        
        // Due Date
        public String DueDate { get; set; } 
        
        // Estimated Time 
        public Double Estimate { get; set; }
            
        // Auto generate Id
        public String autoId { get; set; }
            
 		// Sprint
        public String sprint { get; set; }            

		// Status
        public String status { get; set; }
        
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
            
        public Integer PercentCompleted { 
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
    
    /**
    *@author Nicolas Gunther - May 27, 2009
    */
    public class Filter {

		public String project; 

    	public String sprint {get; set;}
    	public String name {get; set;}
    	public String priority {get; set;}
    	public String estimate {get; set;}
    	public String status {get; set;}
    	public String assignee {get; set;}
    	public String rank {get; set;}
    	public String applyFilter {get; set;}
    	public Boolean svFilter;
    	
    	public ProjectFilter__c newFilter = new ProjectFilter__c(); 
    	
    	/**
    	* Constructor
    	*/
    	public Filter(String id){
    		project = id;
    	}
    	
    	/**
    	*@param  project filter
    	*/
    	public void setNewFilter(ProjectFilter__c f){
    		newFilter = f;
    	}
    	
    	/**
    	*@return project filter 
    	*/
    	public ProjectFilter__c getNewFilter(){
    		return newFilter;
    	}
    	
    	/**
    	*@return members asoc. to project options 
    	*/
    	public List<SelectOption> getAssignees(){
    		List<ProjectMember__c> members = new List<ProjectMember__c>();
    		List<SelectOption> options = new List<SelectOption>();
    		
    		members = [select m.Id, m.Name, User__r.Id from ProjectMember__c m where m.Project__c =: project order by m.Name asc];
    		options.add(new SelectOption('', '-- Any --'));
    		for (ProjectMember__c member : members){
    			options.add(new SelectOption(member.User__r.Id, member.Name));		
    		}	
    		return options;
    	}
    	
    	/**
    	*@return priority picklist options
    	*/
    	public List<SelectOption> getPriorities(){
    		List<SelectOption> priorityOptions = new List<SelectOption>();
    		
    		Schema.DescribeFieldResult describe = ProjectTask__c.Priority__c.getDescribe();
    		List<Schema.PicklistEntry> priorityValues = describe.getPicklistValues();
    		priorityOptions.add(new SelectOption('', '-- Any --'));
    		for(PicklistEntry value : priorityValues){
    			priorityOptions.add(new SelectOption(value.getValue(), value.getValue()));	
    		}
    		return priorityOptions;
    	}
    	
    	/**
    	*@return task status picklist options
    	*/
    	public List<SelectOption> getStatusValues(){
    		List<SelectOption> statusOptions = new List<SelectOption>();
    		
    		Schema.DescribeFieldResult describe = ProjectTask__c.Status__c.getDescribe();
    		List<Schema.PicklistEntry> statusValues = describe.getPicklistValues();
    		statusOptions.add(new SelectOption('', '-- Any --'));
    		for(PicklistEntry value : statusValues){
    			statusOptions.add(new SelectOption(value.getValue(), value.getValue()));	
    		}
    		return statusOptions;
    	}
    	
    	/**
    	*@return saved filters options
    	*/
    	public List<SelectOption> getSavedFilters(){
    		List<ProjectFilter__c> filters = new List<ProjectFilter__c>();
    		List<SelectOption> filterOptions = new List<SelectOption>();
    		
    		filters = [select Id, Filter__c, Name from ProjectFilter__c where Project__c =: project];
    		filterOptions.add(new SelectOption('', '-- Select Filter --'));
    		for(ProjectFilter__c filter : filters){
    			filterOptions.add(new SelectOption(filter.Id, filter.Name));	
    		}
    		return filterOptions;	
    	}
    	
    	/**
    	* Save new Filter
    	*/
    	public void saveFilter(){
    		newFilter.Project__c = project;
    		newFilter.Filter__c = generateFilterContent();
    		insert newFilter;
    		newFilter = new ProjectFilter__c();
    	}
    	
    	/**
    	* Delete Filter
    	*/
    	public void deleteFilter(){
    		List<ProjectFilter__c> filter = new List<ProjectFilter__c>();  
    		filter = [select Id from ProjectFilter__c where Id =: applyFilter];
    		if( filter.size() > 0 )
    		delete filter;
    	}
    	
    	/**
    	* Parse filter option to save it
    	*/
    	public String generateFilterContent(){
			String filterContent = '';
			
			//Filter by Name
			if(name != null && !name.equals(''))
				filterContent += 'Name:' + name + '|';
				
			//Filter by Pririty
			if(priority != null && !priority.equals(''))
				filterContent += 'Priority:' + priority + '|';				
			
			//Filter by Status
			if(status != null && !status.equals(''))
				filterContent += 'Status:' + status + '|';
				
			//Filter by Sprint
			System.debug( '$>>' + sprint );
			if(sprint != null && !sprint.equals(''))
				filterContent += 'Sprint:' + sprint + '|';

			//Filter by Estimate
			if(estimate != null && !estimate.equals(''))
				filterContent += 'Duration:' + estimate + '|';
			
			if(assignee != null && !assignee.equals(''))
				filterContent += 'Assignee:' + assignee + '|';			
	
    		return filterContent;
    	}
    
    	/**
    	* Read and Set Filter
    	*/
    	public void readFilterContent(){
			
			List<ProjectFilter__c> filter = new List<ProjectFilter__c>();
			filter = [select Id, Filter__c from ProjectFilter__c where Id =: applyFilter];
			List<String> test = new List<String>();
			
			if( filter.size() > 0 )
				test = filter[0].Filter__c.split('[|]');
			
			List<String> value = new List<String>();
			for(String values : test){
				value = values.split(':');
				
				//Set Saved Filter attributes.
				if(value.size() > 0){
					//By Name
					if(value[0].equals('Name'))
						name = value[1]; 
					else
						name = '';
					
					//By Assingnee
					if(value[0].equals('Assignee'))
						assignee = value[1];
					else
						assignee = '';
					
					//By Duration
					if(value[0].equals('Duration'))
						estimate = value[1]; 
					else
						estimate = '';

					//By Status
					if(value[0].equals('Status'))
						status = value[1];
					else
						status = '';

					//By Priority
					if(value[0].equals('Priority'))
						priority = value[1];
					else
						priority = ''; 						 
				}
			}
    	}    
    
    	public void setSvFilter( Boolean pa){ 
    		svFilter = pa;
    	}
    	public Boolean getSvFilter(){ 
    		return svFilter;
    	}
    }
    
}