public class TaskQuickAccessController {

	public String taskId = '';
	public Boolean error = false;
	
	/**
	* sets task auto ID
	*@param String s
	*@return void
	*/
	public void setTaskId(String s){
		taskId = '';
		if(!s.startsWith('#')){
			taskId = '#';
		}
		taskId += s;
	}
	
	/**
	* gets task auto id
	*@return String
	*/
	public String getTaskId(){
		return taskId;
	}
	
	/**
	*@return boolean error
	*/
	public Boolean getError(){
		return error;
	}
	
	/**
	*@param bolean b 
	*@return void
	*/
	public void setError(Boolean b){
		error = b;
	}
	
	/**
	* returns page Reference to task detail
	*@return PageReference 
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