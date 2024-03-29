/**
*@author Miguel Soares @ 03/23/2009
*/
public with Sharing class ProjectDetailMilestoneController {
	
	public Boolean  isProduction 			{ set; get; }
	String teamId;
	public Boolean sidebar = false;
	//Size of List
	Integer listSize = 0;
	public UserPermissions userPermissions = ProjectDetailController.userPermission.clone();
	List<ProjectTasks> result = new List<ProjectTasks>();
	
	public ProjectDetailMilestoneController(){
		this.isProduction = ProjectUtil.isProduction;
	}
	
	/**
	*@param String id
	*@return void
	*/
	public void setTeamId(String id) {
		if (teamId == null || teamId != id) {
			teamId = id;
			genPermissions();
			genAllProjectTasks();	
		}	
	}
	
	/**
	*@return String 
	*/
	public String getTeamId(){
		return this.teamId;
	} 
		
	/**
	* Set Sidebar
	*@param Boolean
	*@return void
	*/ 
	public void setSidebar (Boolean b){
		this.sidebar = b;
	}
	
	/**
	* Get Sidebar
	*@return Boolean
	*/
	public Boolean getSidebar(){
		return this.sidebar;
	}	
		
	/**
	*@return Integer
	*/
	public Integer getListSize (){
		return this.listSize;
	}
	
	/**
	* For rerender use
	*@return void
	*/
	public void refresh(){}

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
	*@return List<ProjectTasks>
	*/
	public List<ProjectTasks> getAllProjectTasks() {
		return this.result;
	}
	
	/**
	* Read List of milestones
	*@return void
	*/
	public void genAllProjectTasks() {
		List<ProjectTask__c> milestones = new List<ProjectTask__c>();
		result = new List<ProjectTasks>();
		milestones = [Select 		
	 					p.Name,
	 					p.Priority__c, 
	 					p.Id, 
	 					p.StartDate__c,
	 					p.EndDate__c, 
	 					p.Duration__c, 
	 					p.Project__c,
	 					p.Milestone__c,
	 					p.PercentCompleted__c,
	 					p.Description__c , 
	 					(Select User__c, User__r.Name From ProjectsAssignees__r) 
	 					From ProjectTask__c  p 
	 					where  p.Milestone__c = true 
	 					and p.Project__c =: teamId  
	 					order by p.StartDate__c asc limit 10
	 					];
	 	listSize = milestones.size();  // think there is a better way todo this
	 	
	 	// Retrieve Users
		Set<Id> users = new Set<Id>();		
	 	for( ProjectTask__c milestone : milestones) {
	 		if(milestone.ProjectsAssignees__r.size() > 0){
				users.add(milestone.ProjectsAssignees__r[0].User__c);
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
	 	
		for( ProjectTask__c milestone : milestones) {
							
				ProjectTasks miMilestones = new ProjectTasks();
				miMilestones.setTaskName(milestone.Name);
				miMilestones.setTaskId(milestone.Id);
				miMilestones.setStartDate(milestone.StartDate__c);
				miMilestones.setPercentCompleted(milestone.PercentCompleted__c);
				if(milestone.ProjectsAssignees__r.size() > 0)
				{
					miMilestones.setUser(userMap.get(milestone.ProjectsAssignees__r[0].User__c));					
				}
				
				miMilestones.setPriority(milestone.Priority__c);
				
				result.add(miMilestones);
			
		 } 
		 
		 milestones.clear();
		 users.clear();
		 userMap.clear();
	 }
		
	/**
	* Load my project Milestones
	*@return void
	*/
	public void getMyProjectMilestones() {
		List<ProjectTask__c> milestones = new List<ProjectTask__c>();
		result = new List<ProjectTasks>();
		
		Set<Id> assignedTasks = new Set<Id>();
		for(ProjectAssignee__c p: [SELECT Id,
										ProjectTask__c, Project__c 
								   FROM ProjectAssignee__c
								   Where ProjectTask__r.Milestone__c = true 
								   AND User__c =: UserInfo.getUserId() and  Project__c =: teamId
								   Order By ProjectTask__r.StartDate__c asc Limit 5]) {
								   	
			assignedTasks.add(p.ProjectTask__c);						   	
		}
		milestones = [Select 		
	 					p.Name,
	 					p.Priority__c, 
	 					p.Id, 
	 					p.StartDate__c,
	 					p.EndDate__c, 
	 					p.Duration__c, 
	 					p.Project__c,
	 					p.Milestone__c,
	 					p.PercentCompleted__c,
	 					p.Description__c , 
	 					(Select User__c, User__r.Name From ProjectsAssignees__r) 
	 					From ProjectTask__c  p 
	 					where  p.Milestone__c = true 
	 					and p.Project__c =: teamId 
	 					and Id IN: assignedTasks 
	 					order by p.StartDate__c asc limit 10
	 					];
	 	listSize = milestones.size();  // think there is a better way todo this
	 	// Retrieve Users
		Set<Id> users = new Set<Id>();		
	 	for( ProjectTask__c milestone : milestones) {
	 		if(milestone.ProjectsAssignees__r.size() > 0){
				users.add(milestone.ProjectsAssignees__r[0].User__c);
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
	 	
		for( ProjectTask__c milestone : milestones){			
				ProjectTasks miMilestones = new ProjectTasks();
				miMilestones.setTaskName(milestone.Name);
				miMilestones.setTaskId(milestone.Id);
				miMilestones.setStartDate(milestone.StartDate__c);
				if(milestone.ProjectsAssignees__r.size() > 0)
				{
					miMilestones.setUser(userMap.get(milestone.ProjectsAssignees__r[0].User__c));					
				}
				miMilestones.setPriority(milestone.Priority__c);
				result.add(miMilestones);
		 } 
		 
		 milestones.clear();
		 users.clear();
		 userMap.clear();		
	} 	
	
	 /**
	 * Inner Class ProjectTasks
	 *@class
	 */
	 public class ProjectTasks {
		
        public String TaskId;
        public String TaskName;
        public String DaysCount;
        public String UserId;
		public String UserName;
		public String StartDate;
		public String EndDate;
		public String EndDateRight;
		public Integer DayPercent;
		public Integer DayPercentRight;
        public String Picture;
        public String Priority;
        public String isToLate;
        public Integer percentCompleted;
      	private DateTime now = System.now();
      	private Boolean late;
      	
		
      	/**
      	* Constructor
      	*/
      	public ProjectTasks(){	
      		this.late = false;	
      	}		
		
		/**
		*@return Integer
		*/
		public Integer getDayPercent() {
      		return this.DayPercent;
        }
        
        /**
        * For progress bar use (wide widget use)
        *@param Datetime end date
        *@param Double duration
        *@return void
        */
        public void setDayPercent(Date endD, Double dur){
			Date miToday = Date.today();
			Date endDate = Date.newInstance(endD.year(), endD.month(),endD.day());
			Integer DayDiference = miToday.daysBetween(endDate);
			if(dur > 0){
				DayDiference = DayDiference -  dur.intValue();
			}  
           	if(DayDiference < 0){
        		DayPercent = 0;	
        	}else {
        		 DayDiference = DayDiference * 4;
        		 if(DayDiference > 290){
        		 	DayPercent = 290;
        		 }else {
        		 	DayPercent = DayDiference;
        		 }
        	}
        }
        
        /**
        *@return Integer
        */
        public Integer getDayPercentRight() {
      		return DayPercentRight;
        }
        
        /**
        *@param Datetime end date (thin widget use)
        *@param Double duration
        *@return void
        */
        public void setDayPercentRight( Date endD, Double dur){
			Date miToday = Date.today();
			Date endDate = Date.newInstance(endD.year(), endD.month(),endD.day());
			Integer DayDiference = miToday.daysBetween(endDate);
			if(dur > 0){
				DayDiference = DayDiference -  dur.intValue();
			}  
           	if(DayDiference < 0){
        		DayPercentRight = 0;	
        	}else {
        		 DayDiference = DayDiference * 4;
        		 if(DayDiference > 131){
        		 	DayPercentRight = 132;
        		 }else {
        		 	DayPercentRight = DayDiference;
        		 }
        	}
        }
      	
      	/**
      	*@return String
      	*/
      	public String getPicture() {
      		return Picture;
        }
      	
      	/**
      	*@return String
      	*/
      	public String getEndDate() {
      		return EndDate;
        }
        
        /**
      	*@return String
      	*/
      	public String getStartDate() {
      		Datetime myDate = Datetime.valueOf(this.StartDate + ' 00:00:00');
      		return myDate.format('MM/dd/yyyy');
        }
        
      	public void setStartDate(Date value) {
      		StartDate = String.valueOf(value);
        }
        
        /**
        *@param Datetime end time
        *@param Double dif
        *@return void
        */
        public void setEndDate(Date endD, Double dif){			
			if(dif > 0){
				endD = endD.addDays(-dif.intValue());
			}  
           	EndDate =  endD.format();
        }
        
  		/**
  		*@return String
  		*/
  		public String getIsToLate() {
      		return isToLate;
        }
        
        /**
        *@param Datetime end date
        *@param Double dif
        *@return void
        */
        public void setEndDateRight(Date endD, Double dif){	
			if(dif > 0){
				endD = endD.addDays(-dif.intValue());
			}
           	EndDateRight =  endD.format();
        }
        
        /**
        *@Param Double PercentCompleted
        *@return void
        */
        public void setPercentCompleted(Double pCompleted)
        {
        	percentCompleted = pCompleted.intValue();
        }
        
        
        /**
  		*@return Integer
  		*/
  		public Integer getPercentCompleted() {
      		return percentCompleted;
        }
        
        
  		/**
  		*@return String
  		*/
  		public String getEndDateRight() {
      		return EndDateRight;
        }
        
        /**
        *@param Datetime end date
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
        public String getDaysCount() {
      		return DaysCount;
        }
       
        /**
        *@param Datetime end date
        *@param Double duration
        *@return void
        */
        public void setDaysCount(Date endD, Double dur){
        	Date miToday = Date.today();
			Date endDate = Date.newInstance(endD.year(), endD.month(),endD.day());
			Integer DayDiference = miToday.daysBetween(endDate);   
			if(dur > 0){
				DayDiference = DayDiference -  dur.intValue();
			}   	
        	if(DayDiference < 2){	
        		if(DayDiference == 1){
        			DaysCount = 'Tomorrow';
        		}else if(DayDiference == 0 ){
        			DaysCount = 'Today';
        		}else {
        			DaysCount =  (DayDiference*-1) +' days late';
        		}
        	}else {
        		 DaysCount = DayDiference +' days';
        	}
        }
        
        /**
        *@param User user
        *@return void
        */
        public void setUser(User user){
        	if(user != null){
	            UserName = user.name;
	            UserId = user.Id;
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
    	public String getUserName() {
       		return UserName;
        }
      	
      	/**
      	*@return String
      	*/
      	public String getTaskId() {
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
      	public String getPriority() {
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
        *@return String
        */
        public String getTaskName() {
            return TaskName;
        }
        
        /**
        *@param String sName
        *@return void
        */
        public void setTaskName(String sName){
            TaskName = sName;
        }
        
        public DateTime getNow(){
        	return this.now;
        }
        
        //this method works with milestones because they have not end date
        public Boolean getLate(){
        	
        	Date myToday = Date.today();
        	
        	Date taskEndDate =  Date.valueOf(this.StartDate);
        	
        	if(taskEndDate.daysBetween(myToday) > 0){
        		this.late = true;
        	}else{
        		this.late = false;
        	}
        	
        	return this.late;
        }
	 }
}