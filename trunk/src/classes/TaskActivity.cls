/**
* @author Matias Menafra 
* @createdDate 1/7/2010
*/
public class TaskActivity extends ActivityLog{

	private String name 		= '';
	private String newName		= '';
	private String duration		= '';
	private String status		= '';
	private Boolean complete	= false;
	private ProjectTask__c oldTask = null;
	private ProjectTask__c newTask = null;
	
	/**
	* Constructor that can handle two tasks, for comparing (update)
	* @param projectId
	* @param timeStamp
	* @param modifiedBy	
	* @param action
	* @param oldTask
	* @param newTask
	*/
	public TaskActivity( String projectId, DateTime timeStamp, String modifiedBy, String action, ProjectTask__c oldTask, ProjectTask__c newTask ){
		
		super( projectId, timeStamp, action );
		this.oldTask 	= oldTask;
		this.newTask 	= newTask;
		this.memberId 	= modifiedBy;
	}
	
	/**
	* Constructor for only one task (insert,  delete)
	* @param projectId
	* @param timeStamp
	* @param modifiedBy	
	* @param action
	* @param newTask
	*/
	public TaskActivity( String projectId, DateTime timeStamp, String modifiedBy, String action, ProjectTask__c newTask ){
		
		super( projectId, timeStamp, action );
		this.newTask = newTask;
		this.memberId 	= modifiedBy;
	}
	
	/**
	* Method which will take care of logging individual changes to ProjectTask Object
	*/
	public override void log(){
		
		ProjectMember__c member = DAOFactory.getInstance().getMemberByUserId( this.memberId );
		this.modifiedBy = member.Name;
		
		this.newName = this.newTask.Name;
		
		//New task is created
		if( this.action == 'insert' ){
			this.changeType = 'Task_Insert';
			DAOFactory.getInstance().logTaskActivity( this.projectId, this.timeStamp, this.modifiedBy, this.action, this.changeType, this.name, this.newName, this.duration, this.status, this.complete );
		}
		
		//Task is Removed from a project
		if( this.action == 'delete' ){
			this.changeType = 'Task_Delete';
			DAOFactory.getInstance().logTaskActivity( this.projectId, this.timeStamp, this.modifiedBy, this.action, this.changeType, this.name, this.newName, this.duration, this.status, this.complete );
		}		
		
		//Task is Updated
		if( this.action == 'update' ){
			//Task Name is changed
			if( this.oldTask.Name != this.newTask.Name ){
				this.changeType = 'Task_Name';
				this.name 		= this.oldTask.Name;
				this.newName 	= this.newTask.Name;
				DAOFactory.getInstance().logTaskActivity( this.projectId, this.timeStamp, this.modifiedBy, this.action, this.changeType, this.name, this.newName, this.duration, this.status, this.complete );
			}

			//Tasks Duration is changed
			if( this.oldTask.DurationUI__c != this.newTask.DurationUI__c ){
				this.changeType = 'Task_Duration';
				this.duration 	= this.newTask.DurationUI__c;
				DAOFactory.getInstance().logTaskActivity( this.projectId, this.timeStamp, this.modifiedBy, this.action, this.changeType, this.name, this.newName, this.duration, this.status, this.complete );
			}
			
			//Tasks is completed
			if( (this.oldTask.PercentCompleted__c != this.newTask.PercentCompleted__c) && this.newTask.PercentCompleted__c == 100.0 ){
				this.changeType = 'Task_Complete';
				this.complete 	= true;
				DAOFactory.getInstance().logTaskActivity( this.projectId, this.timeStamp, this.modifiedBy, this.action, this.changeType, this.name, this.newName, this.duration, this.status, this.complete );
			}
			
			//Tasks status is changed
			if( this.oldTask.Status__c != this.newTask.Status__c ){
				this.changeType = 'Task_Status';
				this.status 	= this.newTask.Status__c; 
				DAOFactory.getInstance().logTaskActivity( this.projectId, this.timeStamp, this.modifiedBy, this.action, this.changeType, this.name, this.newName, this.duration, this.status, this.complete );
			}
		}
	}
	
	/**
	* Test Task activity
	*/
    public static testMethod void myUnitTest(){
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
		
		ProjectTask__c task = GenerateEnvironmentTest.task;
		ProjectTask__c task2 = task.clone();
		task2.name 					= 'newtaskname';
		task2.DurationUI__c 		= '22';
		task2.PercentCompleted__c 	= 100.0;
		task2.Status__c 			= 'Closed';
		
		TaskActivity tA = new TaskActivity( GenerateEnvironmentTest.project.id, Datetime.now(), UserInfo.getUserId(), 'update', task2, task );	
		
    	tA = new TaskActivity( GenerateEnvironmentTest.project.id, Datetime.now(), UserInfo.getUserId(), 'insert', task );
    	ta.log();
    	
    	tA = new TaskActivity( GenerateEnvironmentTest.project.id, Datetime.now(), UserInfo.getUserId(), 'delete', task2 ); 
    	tA.log();
    	
    	tA = new TaskActivity( GenerateEnvironmentTest.project.id, Datetime.now(), UserInfo.getUserId(), 'update', task, task2 ); 
    	tA.log();
    	
    	tA = new TaskActivity( GenerateEnvironmentTest.project.id, Datetime.now(), UserInfo.getUserId(), 'update', task, task2 ); 
    	tA.log();
    	
    	tA = new TaskActivity( GenerateEnvironmentTest.project.id, Datetime.now(), UserInfo.getUserId(), 'update', task, task2 ); 
    	tA.log();
    	
    	tA = new TaskActivity( GenerateEnvironmentTest.project.id, Datetime.now(), UserInfo.getUserId(), 'update', task, task2 ); 
    	tA.log();
    	
    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    }
}