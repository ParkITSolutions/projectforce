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
	
}