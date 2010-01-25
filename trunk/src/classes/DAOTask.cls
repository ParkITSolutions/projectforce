/**
* @author Andres Canavesi
*/
public class DAOTask {
	
	private DAOAssignee DAOAssignee;
	
	/**
	* Constructor
	*/
	public DAOTask(){
		this.DAOAssignee = new DAOAssignee();
	}
	
	/**
	* Inserts a task
	* @param name
	* @param startDate
	* @param dueDate
	* @param duration
	* @param assignToId
	* @param projectId
	* @param isMilestone
	*/
	public void insertTask(String name, String startDate, String dueDate, String duration, String assignToId, String projectId, Boolean isMilestone){
		
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

		DAOAssignee.insertAssignee(task.Id, assignToId, projectId);
			
	}
	
	/**
	* Updates a tasks 
	* @param taskId
	* @param name
	* @param startDate
	* @param dueDate
	* @param duration
	* @param assignToId
	* @param projectId
	* @param isMilestone
	* @beta still not implemented
	*/
	public void updateTask(String taskId, String name, String startDate, String dueDate, String duration, String assignTo, String projectId, Boolean isMilestone){
		
		//TODO build a ProjectTask__c object and set its attributes
		
		//update task;
	}
	
	/**
	* deletes a task
	* @param tasks tasks ids string separated by ":"
	*/
	public void deleteTasks(String tasks){
		
		List<String> tasksIds = new List<String>();
        
        tasksIds = tasks.split(':'); 
        
        List<ProjectTask__c> tasksToDelete = [select Id 
            								  from ProjectTask__c 
            								  where id in: tasksIds];
            
		delete tasksToDelete;
	}
	
	/**
	* gets a task by its id
	* @param id
	* @return task a ProjectTask__c
	*/
	public ProjectTask__c get(String taskId){
		
		ProjectTask__c task = new ProjectTask__c();
		
		task = [select Id, Name, Milestone__c, Project__c
		        from ProjectTask__c 
		        where Id =:taskId
		        limit 1];
		
		return task;
	}
	
	/**
	* gets all tasks of a given project
	* @param projectId
	* @param filter a filter criteria
	* @param orderBy column name
	* @param orderAsc true if order way must be ascending or descendant
	* @return tasks a list of tasks
	*/
	public ApexPages.StandardSetController getByProject(String projectId, String filter, String orderBy, Boolean orderAsc){
		
		String orderWay = 'DESC';
		
		if(orderAsc){
			
			orderWay = 'ASC';
		}
		
		String condition = '';
		
		if(filter == '1'){ //all
			
			condition = '';
		}
		
		if(filter == '2'){ //all tasks
			
			condition = 'and Milestone__c = false';
		}
		
		if(filter == '3'){ //all milestones
			
			condition = 'and Milestone__c = true';
		}
		
		if(filter == '4'){ //my tasks and milestones (assigned to me)
			
			condition = 'and id in (select ProjectTask__c from ProjectAssignee__c where User__c = \''+Userinfo.getUserId()+'\')'; 

		}
		
		if(filter == '5'){ //completed tasks
			
			condition = 'and Milestone__c = false '+
						'and PercentCompleted__c = 100 ';
		}
		
		if(filter == '6'){ //overdue tasks
			
			condition = 'and Milestone__c = false '+
						'and PercentCompleted__c < 100 '+
						'and EndDate__c < '+String.valueOf(System.today())+' ';
		}
		
		if(filter == '7'){ //overdue milestones
			
			condition = 'and Milestone__c = true '+
						'and PercentCompleted__c < 100 '+
						'and StartDate__c < '+String.valueOf(System.today())+' ';
		}
		
		String query = 'select id, ' + 
							'Id__c, ' +
							'Name, ' +
							'Milestone__c, ' +
							'Priority__c, ' +
							'PercentCompleted__c, ' +  
							'Duration__c, ' +
							'StartDate__c, ' + 
							'EndDate__c ' +
						'from ProjectTask__c  ' + 
						'where Project__c = \''+projectId+'\' ' +  
						''+condition +' ' + 
						'order by '+orderBy+' '+orderWay; 
		
		ApexPages.StandardSetController tasks = new ApexPages.StandardSetController(Database.getQueryLocator(query));
		
		if(tasks.getResultSize()==0){
		
			return new ApexPages.StandardSetController(new List<ProjectTask__c>());
		}
		
		return tasks;
	}
	
	/**
	* @param tasksIds ids separated by ":"
	* @return tasks a tasks list
	*/
	public List<ProjectTask__c> getTasks(String tasksIds){
		
		List<String> tasksIdsList = new List<String>();
        
        tasksIdsList = tasksIds.split(':'); 
        
        List<ProjectTask__c> tasks = [select Id, Name, Milestone__c
            						  from ProjectTask__c 
            						  where id in: tasksIdsList];
		
		return tasks;
	}
	
	/**
	* @param taskId
	* @return task
	*/
	public List<ProjectTask__c> getInfoTaskById( Id taskId ){
		return [
			Select p.Id,p.Project__c,p.Project__r.Name, p.Name, p.notes__c, p.CreatedById,
			(Select Id, User__c, User__r.Name, User__r.Id,PercentDedicated__c From ProjectsAssignees__r order by User__r.Name)
			From ProjectTask__c p 
			where p.Id =: taskId limit 1
			];
	}
	
}