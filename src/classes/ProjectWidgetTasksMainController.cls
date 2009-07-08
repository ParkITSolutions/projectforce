/**
*@author Martin Prado @ 06/17/2008
*/
public class ProjectWidgetTasksMainController {

	
	String teamId;
	public Boolean sidebar = false;
	Integer listSize = 0;
	public UserPermissions userPermissions = ProjectDetailController.userPermission.clone();
	List<ProjectTask__c> tasks = new List<ProjectTask__c>();
	List<ProjectTask> taskResults = new List<ProjectTask>();
	
	/**
	* Constructor
	*/	
	public ProjectWidgetTasksMainController(){
		if(getTeamId()== null) teamId = System.currentPageReference().getParameters().get('id');  
		getAllProjectTasks();
		genPermissions();		
	}
		
	/**
	*@param String id
	*@return void
	*/
	public void setTeamId(String id) {
		if(teamId == null || teamId != id){
			teamId = id;
		}
	}
	
	/**
	*@return String
	*/
	public String getTeamId(){
		return teamId;
	}
	
	/**
	* Set Sidebar
	*@param Boolean
	*@return void
	*/
	public void setSidebar (Boolean b){
		sidebar = b;
	}
	
	/**
	* Get Sidebar
	*@return Boolean
	*/
	public Boolean getSidebar(){
		return sidebar;
	}	
	 
	
	/**
	*@return List<ProjectTask> taskResults
	*/
	public List<ProjectTask> getTaskResults(){
		return taskResults;
	}
	
	/**
	*@param List<ProjectTask> pt
	*@return void
	*/
	public void setTaskResults(List<ProjectTask> pt){
		taskResults = pt;
	}
	
	/**
	* Get task list size
	*@return Integer
	*/
	public Integer getListSize (){
		return listSize;
	}
	
	/**
	* Read user permissions
	*@return void
	*/
	public void genPermissions () {
		userPermissions.setId(UserInfo.getUserId());
		userPermissions.setProject(teamId);
		userPermissions.setObjectType('Project');
		userPermissions.setPermissions();		
	}
	
	/**
	*@return UserPermissions
	*/
	public UserPermissions getUserPermissions () {
		//Refresh user permissions
		genPermissions();
		return userPermissions;
	}
	
	/**
	* Load all project task
	*@return void
	*/
	public void getAllProjectTasks() {
		tasks.clear(); 
		tasks = [Select p.Priority__c, 
	 					p.PercentCompleted__c, 
	 					p.Name, 
	 					p.Id,
	 					p.Status__c, 
	 					p.EndDate__c, 
	 					p.Duration__c, 
	 					p.Project__c,
	 					p.Milestone__c,
	 					p.Description__c, 
	 					(Select User__c, User__r.Name From ProjectsAssignees__r) 
	 					From ProjectTask__c  p where  p.Milestone__c = false and p.Project__c =: teamId 
	 					order by p.EndDate__c asc 
	 					limit 10];
	 					
		listSize = 0;
		getProjectTaskbuild();				
	} 
	
	/**
	* Load my project task
	*@return void
	*/
	public void getMyProjectTasks() {
		tasks.clear();
		Set<Id> assignedTasks = new Set<Id>();
		for(ProjectAssignee__c p: [SELECT Id,
										ProjectTask__c, Project__c 
								   FROM ProjectAssignee__c
								   Where ProjectTask__r.Milestone__c = false 
								   AND User__c =: UserInfo.getUserId() and  Project__c =: teamId
								   Order By ProjectTask__r.EndDate__c asc Limit 5]) {
								   	
			assignedTasks.add(p.ProjectTask__c);						   	
		}
		tasks = [Select p.Priority__c, 
	 					p.PercentCompleted__c, 
	 					p.Name, 
	 					p.Id,
	 					p.Status__c, 
	 					p.EndDate__c, 
	 					p.Duration__c, 
	 					p.Description__c, 
	 					(Select User__c, User__r.Name From ProjectsAssignees__r ) 
	 					From ProjectTask__c p 
	 					where  Id IN: assignedTasks 
	 					order by p.EndDate__c asc ];
		listSize = 0;
		getProjectTaskbuild();		
	} 
	
	/**
	* Build task list
	*@return void
	*/
	public void getProjectTaskbuild(){
		// Retrieve Users Image info
		Set<Id> users = new Set<Id>();		
	 	for( ProjectTask__c task : tasks) {
	 		if(task.ProjectsAssignees__r.size() > 0){
				users.add(task.ProjectsAssignees__r[0].User__c);
	 		}
	 	}
	 	
	 	Map<Id, User> userMap = new Map<Id,User>();
		for(User u: [SELECT Id, 
							Name 
							//(Select Name, Picture__c From People__r) 
							FROM User u 
							WHERE u.id IN: users]){
			userMap.put(u.Id, u);							
		}
			 	
	 	taskResults.clear();
	 	if(tasks.size() > 0){
		 	for( Integer i = 0; i < tasks.size() ; i++){
				
				ProjectTask miTasks = new ProjectTask();
				miTasks.setTaskName(tasks[i].Name);
				miTasks.setPriority(tasks[i].Priority__c);
				miTasks.setPercent(tasks[i].PercentCompleted__c);
				miTasks.setTaskId(tasks[i].Id);
				miTasks.setStatus(tasks[i].Status__c);
				
				if(tasks[i].ProjectsAssignees__r.size() > 0){
					miTasks.setUser(userMap.get(tasks[i].ProjectsAssignees__r[0].User__c));					
				}
				
				if(tasks[i].EndDate__c != null){
					miTasks.setEndDate(tasks[i].EndDate__c);
					miTasks.setIsToLate(tasks[i].EndDate__c);  
				}
				
				taskResults.add(miTasks);
		 	}
	 	} 
	 	listSize = taskResults.size();
	 	users.clear();
	 	userMap.clear();
	 }
	 
	 
	 /**
	 * Inner Class ProjectTask
	 */
	 public class ProjectTask {
		
        public String TaskId;
        public String Priority;
        public String TaskName;
        public Integer Percent;
        public String UserId;
		public String UserName;
		public String EndDate;
        public String Picture = 'nopicture';
        public String isToLate;
        public String status;
        
      	DateTime now = System.now();
	
      	/**
      	* Constructor
      	*/
      	public ProjectTask(){
      		
      	}
      	
      	/**
      	*@param User user
      	*@return void
      	*/
      	public void setUser(User user){
        	if(user != null){
       		    UserName = user.name;
	            UserId = user.Id;
	            /*
	            if(user.People__r.size() > 0 &&
	            	user.People__r[0].Picture__c != null &&
	            	user.People__r[0].Picture__c != ''){
	           		Picture = user.People__r[0].Picture__c;
	            } else {
	            	Picture = '';
	            }
	            */
        	}
        }
      	
      	/**
      	*@return String
      	*/
      	public String getPicture() {
      		return Picture;
        }
        
        /**
        *@return String task status
        */
        public String getStatus(){
        	return status;
        }
        
        /**
        *@param String task status
        *@retur void
        */
        public void setStatus(String s){
        	status = s;
        }
      	
      	/**
      	*@return String
      	*/
      	public String getEndDate() {
      		return EndDate;
        }
        
        /**
        *@param Datetime endD
        *@return void
        */
        public void setEndDate(Date endD){
        	Date miToday = Date.today();
			Date myEndDate = Date.newInstance(endD.year(), endD.month(),endD.day());
			Integer DayDiference = miToday.daysBetween(myEndDate); 		
			if(DayDiference < 2){	
        		if(DayDiference == 0 ){
        			EndDate = 'Today';
        		}else if(DayDiference == 1 ){
        			EndDate = 'Tomorrow';
        		}else {
        			EndDate = (DayDiference*-1) +' days late, due ' + endD.format();
        		}
        	}else {
        		EndDate =  'Due ' + endD.format();
        	}
        }
        
  		/**
  		*@return String
  		*/
  		public String getIsToLate() {
      		return isToLate;
        }
        
        /**
        *@param Datetime endD
        *@return void
        */
        public void setIsToLate(Date endD){
        	Date miToday = Date.today();
			Date myEndDate = Date.newInstance(endD.year(), endD.month(),endD.day());
			Integer DayDiference = miToday.daysBetween(myEndDate); 	
        	
        	if(DayDiference < 1){
        		isToLate = 'latter';	
        	}else {
            	isToLate = '';
            }
        }
        
        /**
        *@return String
        */
        public String getUserId() {
      		return UserId;
        }
        
    	/**
    	*@return String
    	*/
    	public String getUserName(){
       		return UserName;
        }
      	
      	/**
      	*@return String
      	*/
      	public String getTaskId(){
            return TaskId;
        }
        
        /**
        *@param String idTask
        *@return void
        */
        public void setTaskId(String idTask){
            TaskId = idTask;
        }
        
        /**
        *@return String
        */
        public String getPriority(){
            return Priority;
        }
        
        /**
        *@param String pr
        *@return void
        */
        public void setPriority(String pr){
            Priority = pr;
        }
        
        /**
        *@return Integer percent complete
        */
        public Integer getPercent(){
            return Percent;
        }
        
        /**
        *@param Double per
        *@return void
        */
        public void setPercent(Double per){
        	if(per == null){
        		Percent = 0;
        	}else {
        		Percent = per.intValue();
        	}
        }
        
      	/**
      	*@return String
      	*/
      	public String getTaskName(){
            return TaskName;
        }
        
        /**
        *@param String sName
        *@return void
        */
        public void setTaskName(String sName){
            TaskName = sName;
        }	       
	}	
}