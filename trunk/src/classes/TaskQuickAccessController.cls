/**
* @author Matias Menafra 
*/
public class TaskQuickAccessController {

	public String taskCustomId;
	public Boolean error { set; get; }
	
	/**
	* Constructor
	*/
	public TaskQuickAccessController(){
		
		this.error = false;
	}
	
	/**
	* setter for Task id 
	* @param value
	*/
	public void setTaskCustomId( String value ){
		
		this.taskCustomId = '';
		if( !value.startsWith( '#' ) ){
			this.taskCustomId = '#';
		}
		this.taskCustomId += value;
	}
	
	/**
	* getter for Task  Id
	* @return taskId
	*/
	public String getTaskCustomId(){
		return this.taskCustomId;
	}
	
	/**
	* returns page Reference to task detail
	* @return taskDetail 
	*/
	public PageReference goToTaskDetail(){
		
		Project prj = new Project();
		
		ProjectTask__c task = prj.getTaskByCustomId( this.taskCustomId );
		
		if( task != null ){
			
			PageReference taskDetail = new PageReference( '/apex/ProjectTaskDetail?id=' + task.Id );
			return taskDetail;
			
		}else{
			this.error = true;
		}
		
		return null;
	}
}