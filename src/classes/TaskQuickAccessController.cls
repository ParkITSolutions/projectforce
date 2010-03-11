/**
* @author Matias Menafra 
* @createdDate 01/22/2010
*/
public class TaskQuickAccessController {
	
	public String 	taskCustomId;
	public Boolean  isProduction 	{ set; get; }
	public Boolean 	error 			{ set; get; }
	public String 	trace 			{ set; get; }
	
	/**
	* Constructor
	*/
	public TaskQuickAccessController(){
		
		this.isProduction 	= ProjectUtil.isProduction;
		this.error 			= false;
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
	public PageReference goToTaskDetail()
	{
		Project prj = new Project();
		ProjectTask__c task = prj.getTaskByCustomId( this.taskCustomId );
		
		if( task != null ){
			this.error = false;
			PageReference taskDetail = new PageReference( '/apex/ProjectTaskDetail?id=' + task.Id );
			taskDetail.setRedirect( true );
			return taskDetail;
		}
		else{
			this.error = true;
			this.trace = this.taskCustomId;
			return null;
		}
	}
	
	/**
	* Test Task Quick Access component
	*/
	public static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
		
		TaskQuickAccessController taq = new TaskQuickAccessController();
		
		taq.setTaskCustomId( '#' + GenerateEnvironmentTest.task.id );
		//taq.setTaskCustomId( '#' + String.valueOf( GenerateEnvironmentTest.task.Id__c ) );
		taq.getTaskCustomId();
		taq.goToTaskDetail();

		taq.setTaskCustomId( '#f43' );
		taq.goToTaskDetail();
    	Test.stopTest();
    	
		ProjectUtil.setIsTest( false );
    }    	
}