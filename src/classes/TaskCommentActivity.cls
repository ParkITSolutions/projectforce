/**
* @author Matias Menafra 1/7/2010
*/
public class TaskCommentActivity extends ActivityLog{

	private String taskName;
	private TaskComment__c comment = null;
		
	/**
	* Constructor
	* @param String projectId
	* @param DateTime timeStamp
	* @param String modifiedBy
	* @param String action
	* @param String commentId
	* @param String taskId
	*/
	public TaskCommentActivity( String projectId, DateTime timeStamp, String modifiedBy, String action, TaskComment__c comment ){
		
		super( projectId, timeStamp, action );
		this.comment 	= comment;
		this.memberId 	= modifiedBy;
	}
	
	/**
	* Method which will take care of logging individual changes to TaskComment Object
	* @return void
	*/
	public override void log(){
		
		ProjectMember__c member = DAOFactory.getInstance().getMemberByUserId( this.memberId ) ;
		this.modifiedBy = member.Name;
		
		ProjectTask__c task = DAOFactory.getInstance().getTask( this.comment.Task__c );

		//Comment Added to a Task
		if( this.action == 'insert' ){
			this.changeType = 'TaskComment_Insert';
			this.taskName 	= task.Name;
			this.projectId 	= task.Project__c;
			DAOFactory.getInstance().logTaskCommentActivity( this.projectId, this.timeStamp, this.modifiedBy, this.action, this.changeType, this.taskName );
		}
		
		//Comment removed from a Task
		if( this.action == 'delete' ){
			this.changeType = 'TaskComment_Delete';
			this.taskName 	= task.Name;
			this.projectId 	= task.Project__c;
			DAOFactory.getInstance().logTaskCommentActivity( this.projectId, this.timeStamp, this.modifiedBy, this.action, this.changeType, this.taskName );
		}
	}
	
	/**
	* Test
	*/
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
    	
    	TaskComment__c c = new TaskComment__c(); 
    	TaskCommentActivity tC = new TaskCommentActivity( GenerateEnvironmentTest.project.id, Datetime.now(), Userinfo.getUserId(), 'insert', c );
    	tC = new TaskCommentActivity( GenerateEnvironmentTest.project.id, Datetime.now(), Userinfo.getUserId(), 'delete', c );
    	
    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    }		
	
}