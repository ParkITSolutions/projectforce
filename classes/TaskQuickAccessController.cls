public class TaskQuickAccessController {

	public String taskId = '';
	public Boolean error = false;
	
	/**
	*@param s task auto id
	*/
	public void setTaskId(String s){
		taskId = '';
		if(!s.startsWith('#')){
			taskId = '#';
		}
		taskId += s;
	}
	
	/**
	*@return task auto id 
	*/
	public String getTaskId(){
		return taskId;
	}
	
	/**
	*@return error
	*/
	public Boolean getError(){
		return error;
	}
	
	/**
	*@param b error
	*/
	public void setError(Boolean b){
		error = b;
	}
	
	/**
	*@return page reference to task detail
	*/
	public PageReference go(){
		List<ProjectTask__c> tasks = new List<ProjectTask__c>();
		tasks = [select Id from ProjectTask__c where Id__c =: taskId];
		
		if(tasks.size() > 0){
			PageReference forward = new PageReference('/apex/ProjectTaskDetail?id=' + tasks[0].Id);
			forward.setRedirect(true);
			return forward;
		}else{
			error = true;
		}
		return null;
	}

}