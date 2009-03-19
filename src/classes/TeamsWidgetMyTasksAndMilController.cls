public class TeamsWidgetMyTasksAndMilController {
	
	public String currentDate = '';
	public Integer overdueAlreadyShow = 0;
	public Integer countTask = 0;
	public Integer countMilestones = 0;
    public Integer tasksListSize{ get; set; }
    public Integer milestonesListSize{ get; set; }
	public List<ProjectTasks> tasksList =new List<ProjectTasks>();
	public List<ProjectTasks> milestonesList =new List<ProjectTasks>();
	public Boolean displayTitle = false;	
	
    /**
    * Constructor
    */
    public TeamsWidgetMyTasksAndMilController(){
        loadAllProjectTasksAndMilestones();
    }
    
   	public List<ProjectTasks> getTasksList(){
   		return tasksList;
   	}
   	public List<ProjectTasks> getMilestonesList(){
   		return milestonesList;
   	}
    
   
    public Integer getOverdueAlreadyShow(){
    	return overdueAlreadyShow;
    }
 
	
    
  
    public void loadAllProjectTasksAndMilestones(){
	    //All Project task
	    List<ProjectTask__c> allProjectsTasks = new List<ProjectTask__c>();
	    //5 Project assign to Me
	    List<ProjectTask__c> myProjectsTasks = new List<ProjectTask__c>();
	    	    
	    //Populate allProjects  
	    
	    allProjectsTasks = [Select  p.Id, 
	                        (Select User__c From ProjectsAssignees__r) 
	                        From ProjectTask__c  p];
	                    
	    // Set id of Project assign to me
	    Set<Id> projToMe = new Set<Id>();
	    
	    for( ProjectTask__c p : allProjectsTasks) {
	        if(p.ProjectsAssignees__r.size() > 0){
	        	for(Integer i=0; i<p.ProjectsAssignees__r.size(); i++){
	        		if(p.ProjectsAssignees__r[i].User__c == Userinfo.getUserId()){
	        			projToMe.add(p.Id);
	        		}
			   	}
	        }
	    }
		
	    //Populate myProjectsTasks
	    myProjectsTasks = [ Select 
	     				p.Priority__c, 
	     				p.Name, 
	     				p.Milestone__c, 
	     				p.Id, p.EndDate__c,
	     				p.PercentCompleted__c, 
	     				p.Duration__c
	     				From ProjectTask__c  p where p.Id in : projToMe and  p.EndDate__c != null  order by p.EndDate__c asc ];
  	    
        for( ProjectTask__c pro : myProjectsTasks) {
            if(pro.PercentCompleted__c < 100 || pro.PercentCompleted__c == null){
                	ProjectTasks myTask = new ProjectTasks();
                   	if(pro.EndDate__c < Date.today()){
	                	myTask.overDue = true;	                
	                	overdueAlreadyShow = overdueAlreadyShow + 1;	                	
	                } else {
	                	myTask.overDue = false;
	                }
	               	if(currentDate != String.valueOf(pro.EndDate__c )){
                		if(myTask.overDue){
	                		if(overdueAlreadyShow > 1){              		
	                			myTask.displayTitle = false;
	                		} else {
	                			myTask.displayTitle = true;
	                		}
                		}else {
                			myTask.displayTitle = true;
                		}
                	}else {
                		myTask.displayTitle = false;
                	}
	                myTask.TaskName = pro.Name;
	                myTask.TaskId = pro.Id;
					myTask.setDaysCount(pro.EndDate__c, pro.Duration__c);
					
	                if(pro.Priority__c == '' || pro.Priority__c == null){
	                	myTask.Priority = 'Normal';
	                }else {
	                	myTask.Priority = pro.Priority__c;
	                }
	                myTask.setEndDate(pro.EndDate__c);            
	                myTask.setIsToLate(pro.EndDate__c);  
	                myTask.isMilestone  = pro.Milestone__c;	
	                if ((countTask+countMilestones) < myProjectsTasks.size() ){
	               		if (!myTask.isMilestone){
	            			if(countTask < 5){
	            				tasksList.add(myTask);
	            				countTask ++;
	            			}	
	            		}else{
	            			if(countTask < 5){
	            				milestonesList.add(myTask);
	            				countMilestones++;
	            			}
	            		}
	               	}
	            	currentDate = pro.EndDate__c.format();
            }
  	 	} 
			tasksListSize = tasksList.size();
			milestonesListSize = milestonesList.size();
	       
  }
    
    /**
    * Class ProjectTasks
    */
    public class ProjectTasks {

        public String DaysCount;
        public String UserId;
        public String UserName;
        public String EndDate;
        public String EndDateRight;
        public String isToLate;
        
        DateTime now = System.now();
        
        //current task id
        public String TaskId{ get; set; }
        
        //task priority
        public String Priority{ get; set; }

        /**
        * Returns task name
        *@return String
        */
        public String TaskName{ 
        	get; 
        	set{
        		if(value.length() > 22){
        			TaskName = value.substring(0,20) + '...';
        		}else {
        			TaskName = value;
        		}
        	} 
        }
        
		//is milestone bool
		public Boolean isMilestone{ 
			get; set; 
		}
		
		//current task date class
		public String taskDateClass{ 
			get; set; 
		}
		
		//overdue bool
		public Boolean overDue{ 
			get; set; 
		}
		
		//show title bool
		public Boolean displayTitle{ 
			get; set; 
		}

        /**
        *@return String
        */
        public String getEndDate() {
            return EndDate;
        }
        
        /**
        *@param Datetime end time
        */
        public void setEndDate(Date endD){
        	EndDate =  endD.format();
        }
        
        /**
        *@return String
        */
        public String getIsToLate() {
            return isToLate;
        }
                
        /**
        *@param Datetime end time
        */
        public void setIsToLate(Date endD){  
        	Date miToday = Date.today();
            Integer DayDiference = miToday.daysBetween(endD);  
            
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
        */
        public void setDaysCount(Date endD, Double dur){
            Date miToday = Date.today();
            Date endDate = Date.newInstance(endD.year(), endD.month(),endD.day());
            Integer DayDiference = miToday.daysBetween(endDate);   
               
            if(DayDiference < 2){   
                if(DayDiference == 1 ){
                    DaysCount = 'Due Tomorrow';
                }else if(DayDiference == 0 ){
                    DaysCount = 'Due Today';
                }else{
                    DaysCount =  (DayDiference*-1) +' days late,';
                }
            }else {
                 DaysCount = 'Due in ' + DayDiference +' days';
            }
        }
     }
}