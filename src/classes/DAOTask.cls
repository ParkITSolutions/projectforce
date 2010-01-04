public class DAOTask {
	
	public DAOTask(){}
	
	public void add(String name, String startDate, String dueDate, String duration, String assignTo, String projectId){
		
		ProjectTask__c task = new ProjectTask__c();
		
		task.Name = name;
		task.StartDate__c = Date.parse(startDate);
		task.EndDate__c = Date.parse(dueDate);
		task.Duration__c = Double.valueOf(duration);
		task.Project__c = projectId;
   		task.Milestone__c = false;
		task.PercentCompleted__c = ProjectUtil.getDefaultTaskPercentCompleted();
		task.Priority__c = ProjectUtil.getDefaultTaskPriority();
			
		insert task; 

		DAOFactory.getInstance().addAssignee(task.Id, assignTo, projectId);
			
	}
	
	public void actualize(ProjectTask__c task){
		update task;
	}
	
	public void remove(String tasks){
		
		List<String> tasksIds = new List<String>();
        
        tasksIds = tasks.split(':'); 
        
        List<ProjectTask__c> tasksToDelete = [select Id 
            								  from ProjectTask__c 
            								  where id in: tasksIds];
            
		delete tasksToDelete;
	}
	
	//TODO return corresponding fields in the query
	public ProjectTask__c get(Id id){
		
		ProjectTask__c task = new ProjectTask__c();
		
		task = [select Id, Name
		        from ProjectTask__c 
		        where Id =:task.Id 
		        limit 1];
		
		return task;
	}
	
	//TODO return corresponding fields in the query
	public List<ProjectTask__c> listByProject(String projectId ){
		
	    List<ProjectTask__c> tasks = new List<ProjectTask__c>();
	    
	    tasks = [select Id, Name
		         from ProjectTask__c 
		         where Project__c =: projectId ];
	    
		return tasks;
	}
	
	/**
	* Preconditions: 
	* One task can be completed if:
    *            -User has permissions (is admin,  is owner,  is assigned).
    *            -Is not a parent task (has no decendent tasks).
    *            -Has not its percentage 100%
    *@param tasks
    *@return 
	*/
	/*public void markComplete(String tasks){
		
		
		if(tasks != null && tasks !=''){
			
			List<String> tasksIds = new List<String>();
			
			tasksIds = tasks.split(':');
			
			List<ProjectTask__c> tasks = [select (Select User__c 
			                                      from ProjectsAssignees__r ), id 
										  from ProjectTask__c where id in: tasksIds];  
		}
		
		
		
	
		
		List<String> idsUpdate = new List<String>();
       	setIdTaskToMarkComplete(getIdTaskToComplete());
        idTaskToMarkComplete = '';
        if (idTaskToComplete != '' && idTaskToComplete != null) {
            idsUpdate = getIdTaskToComplete().split(':');
        }
                   
        if(idsUpdate.size()>0){
            List<ProjectTask__c> tasksUpdate = [select (Select User__c from ProjectsAssignees__r ), id from ProjectTask__c where id in: idsUpdate];
            
            if (tasksUpdate.size() > 0) {
                Boolean markingParent = false;
                Integer indexTask = 0;
	            ParentTask parent = new ParentTask();
	            BigListOfTasks bigListOfTasks = new BigListOfTasks(PROJECTID);
                for (ProjectTask__c iterTask : tasksUpdate) {
                    Boolean cantEditAndDelete = false;
                    Integer countAssignee = 0;
                    Boolean hasChild = parent.taskHasChildren(iterTask); 
                    if (hasChild){
                    	markingParent = true;
                    	idTaskToMarkComplete = idTaskToMarkComplete + tasksUpdate[indexTask] + ':';
                    }else{
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
                    indexTask++;                      
                }
                if(!markingParent){
                	ProjectUtil.setTaskDependenciesFlag(false);
                	update tasksUpdate;
                	ProjectUtil.setTaskDependenciesFlag(true);
                }

            }else{
                throw new CustomException('Insufficient Privileges');
            }
        }
        idTaskToComplete = '';
        
	}
	
	*/
	
	public List<ProjectTask__c> getTasks(String tasksIds){
		
		List<String> tasksIdsList = new List<String>();
        
        tasksIdsList = tasksIds.split(':'); 
        
        List<ProjectTask__c> tasks = [select Id 
            						  from ProjectTask__c 
            						  where id in: tasksIdsList];
		
		return tasks;
	}
	
}