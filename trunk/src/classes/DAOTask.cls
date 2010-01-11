public class DAOTask {
	
	private DAOAssignee DAOAssignee;
	
	public DAOTask(){
		this.DAOAssignee = new DAOAssignee();
	}
	
	public void insertTask(String name, String startDate, String dueDate, String duration, String assignTo, String projectId, Boolean isMilestone){
		
		ProjectTask__c task = new ProjectTask__c();
		
		task.Name = name;
		task.StartDate__c = Date.parse(startDate);
		task.EndDate__c = Date.parse(dueDate);
		task.Duration__c = Double.valueOf(duration);
		task.Project__c = projectId;
   		task.Milestone__c = false;
		task.PercentCompleted__c = ProjectUtil.getDefaultTaskPercentCompleted();
		task.Priority__c = ProjectUtil.getDefaultTaskPriority();
		task.Milestone__c = isMilestone;
			
		insert task; 

		DAOAssignee.insertAssignee(task.Id, assignTo, projectId);
			
	}
	
	public void updateTask(ProjectTask__c task){
		update task;
	}
	
	public void deleteTasks(String tasks){
		
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
		
		task = [select Id, Name, Milestone__c
		        from ProjectTask__c 
		        where Id =:task.Id 
		        limit 1];
		
		return task;
	}
	
	public List<Task> getByProject(String projectId, String filter, String orderBy, Boolean orderAsc, Integer listIndex, Integer quantity){
		
		String orderWay = 'DESC';
		
		if(orderAsc){
			
			orderWay = 'ASC';
		}
		
	    List<ProjectTask__c> tasksQuery = new List<ProjectTask__c>();
	    
	    String query = 'select id, ' + 
							'Id__c, ' +
							'Name, ' +
							'Milestone__c, ' +
							'Priority__c, ' +
							'PercentCompleted__c, ' +
							'Duration__c, ' +
							'EndDate__c ' + 
						'from ProjectTask__c  ' + 
						'where Project__c = \''+projectId+'\' ' + 
						'order by '+orderBy+' '+orderWay; 
						
		tasksQuery = Database.query(query);
		
		List<ProjectTask__c> tasksAux = new List<ProjectTask__c>();
		
		Integer i=0;
		
		while(i<tasksQuery.size() && i<quantity){
		
			tasksAux.add(tasksQuery.get(listIndex));
			
			listIndex++;
			
			i++;
		}
		         
		List<Task> tasksList = new List<Task>();
		
		for(ProjectTask__c task : tasksAux){
			
			Task taskAux = new Task();
			
			taskAux.id = task.id;
			taskAux.idDisplay = task.Id__c;
			taskAux.name = task.Name;
			taskAux.isMilestone = task.Milestone__c;
			taskAux.priority = task.Priority__c;
			taskAux.percentCompleted = task.PercentCompleted__c;
			taskAux.durationDisplay = String.valueOf(task.Duration__c);
			taskAux.endDateDisplay = String.valueOf(task.EndDate__c);
			
			//TODO change ProjectMember to TaskAssignee
			List<ProjectMember> assignees = DAOAssignee.getAssignees(taskAux.id);
			
			taskAux.assignees = assignees;
			
			tasksList.add(taskAux);
		}
	    
		return tasksList;
	}
	
	public List<ProjectTask__c> getTasks(String tasksIds){
		
		List<String> tasksIdsList = new List<String>();
        
        tasksIdsList = tasksIds.split(':'); 
        
        List<ProjectTask__c> tasks = [select Id, Name, Milestone__c
            						  from ProjectTask__c 
            						  where id in: tasksIdsList];
		
		return tasks;
	}
	
	
	
}