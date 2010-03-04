/**
* @author Matias Menafra 
* @createdDate 1/7/2010
*/
public class TaskAssigneeActivity extends ActivityLog{

	private String assigneeName 		= '';
	private String taskName 			= '';
	private ProjectAssignee__c assignee = null; 
		
	/**
	* Constructor
	* @param projectId
	* @param timeStamp
	* @param modifiedBy
	* @param action
	* @param assigneeId
	* @param taskId
	*/
	public TaskAssigneeActivity( String projectId, DateTime timeStamp, String modifiedBy, String action, ProjectAssignee__c assignee ){
		
		super( projectId, timeStamp, action );
		this.assignee = assignee;
		this.memberId = modifiedBy;
	}
	
	/**
	* Method which will take care of logging individual changes to TaskAssignee Object
	*/
	public override void log(){
		
		ProjectMember__c member = DAOFactory.getInstance().getMemberByUserId( this.memberId ) ;
		this.modifiedBy = member.Name;
		
		ProjectMember__c newAssignee = DAOFactory.getInstance().getMemberByUserId( assignee.User__c );
		ProjectTask__c task = DAOFactory.getInstance().getTask( assignee.ProjectTask__c );
			
		//Assignee added to a Task
		if( this.action == 'insert' ){
			this.changeType 	= 'TaskAssignee_Insert';
			this.assigneeName 	= newAssignee.Name;
			this.taskName 		= task.Name;
			DAOFactory.getInstance().logTaskAssigneeActivity( this.projectId, this.timeStamp, this.modifiedBy, this.action, this.changeType, this.assigneeName, this.taskName );
		}
			
		//Assignee removed from a Task
		if( this.action == 'delete' ){
			this.changeType 	= 'TaskAssignee_Delete';
			this.assigneeName 	= newAssignee.Name;
			this.taskName 		= task.Name;
			DAOFactory.getInstance().logTaskAssigneeActivity( this.projectId, this.timeStamp, this.modifiedBy, this.action, this.changeType, this.assigneeName, this.taskName );
		}
	}
	
	/**
	* Test task assignee activity
	*/
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
    	
    	ProjectAssignee__c assignee = GenerateEnvironmentTest.assi.clone();    	
    	TaskAssigneeActivity tA;
    	
    	tA = new TaskAssigneeActivity( GenerateEnvironmentTest.project.id, Datetime.now(), UserInfo.getUserId(), 'insert', assignee );
    	tA.log();
    	
    	tA = new TaskAssigneeActivity( GenerateEnvironmentTest.project.id, Datetime.now(), UserInfo.getUserId(), 'delete', assignee );
    	tA.log();
    	
    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    }	
}