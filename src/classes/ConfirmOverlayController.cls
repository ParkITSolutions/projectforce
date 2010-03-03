/**
* @author Andres Canavesi
* @dateCreated 12/01/2009
*/
public class ConfirmOverlayController {
	
	public String 	title 	        	{ set; get; }
	public String 	messageToUser 		{ set; get; }
	public String 	actionIds 	    	{ set; get; }
	public String 	actionName 	    	{ set; get; }
	public String 	postAction 	    	{ set; get; }
	public String 	exceptionMessage	{ set; get; }
	
	/**
	* Constructor
	*/
	public ConfirmOverlayController(){
		
	}
	
	/**
	* Action for accept button
	*/
	public PageReference action(){
		
		this.postAction = '';
		PageReference pageRef = null;
		
		try{
			if( this.actionName == 'DeleteTasks' ){
				
				DAOFactory.getInstance().deleteTasks( this.actionIds );
				this.postAction = 'DeleteTasksSuccess';
			}
			if( this.actionName == 'DeleteDetailTask' ){
				
				String projectId = DAOFactory.getInstance().getTask( this.actionIds ).Project__c;
				
				DAOFactory.getInstance().deleteTasks( this.actionIds );
				this.postAction = 'DeleteTasksSuccess';
				
				pageRef = new PageReference( '/apex/tasklist' );
				pageRef.getParameters().put('id', projectId);
				
			}
			if( this.actionName == 'MarkCompleteTasks' ){
				
				String projectId 	= System.currentPageReference().getParameters().get( 'id' );
				Project project 	= new Project( projectId );
				
				project.setTasks( this.actionIds );
				project.markCompleteTasks();
				
				this.postAction = 'TasksMarkCompleteSuccess';
			}
			if( this.actionName == 'deleteAttachments' ){
				
				DAOFactory.getInstance().deleteAttachments( this.actionIds );
				this.postAction = 'DeleteAttachmentsSuccess';
			}
			if( this.actionName == 'DeleteMembers' ){
				DAOFactory.getInstance().deleteMembers( this.actionIds, System.currentPageReference().getParameters().get( 'id' ) );
				this.postAction = 'DeleteMembersSuccess';
			}
			if( this.actionName == 'DeleteProject' ){
				//From ProjectDetail.page
				DAOFactory.getInstance().deleteProject( this.actionIds );
				this.postAction = 'DeleteProjectsSuccess';
				
				pageRef = new PageReference( '/apex/projectOverview' );
			}
			if ( this.actionName == 'ProjectDetailDeleteAttachments' ){
				//From ProjectDetail.page
				DAOFactory.getInstance().deleteAttachments( this.actionIds );
				this.postAction = 'ProjectDetailDeleteAttachmentsSuccess';
			}
			if ( this.actionName == 'TaskDetailDeleteAttachmentOverlay' ){
				//From ProjectTaskDetail.page
				DAOFactory.getInstance().deleteAttachments( this.actionIds );
				this.postAction = 'TaskDetailDeleteAttachmentOverlaySuccess';
			}
			if ( this.actionName == 'TaskDetailDeleteAssigneeOverlay' ){
				//From ProjectTaskDetail.page
				DAOFactory.getInstance().deleteTaskAssignee( this.actionIds );
				this.postAction = 'TaskDetailDeleteAssigneeOverlaySuccess';
			}
			if ( this.actionName == 'TaskDetailDeleteCommentOverlay' ){
				//From ProjectTaskDetail.page
				DAOFactory.getInstance().deleteTaskComment( this.actionIds );
				this.postAction = 'TaskDetailDeleteCommentOverlaySuccess';
			}
			
		}catch( CustomException e ){
			Apexpages.addMessages( e );
			this.exceptionMessage = e.getMessage();
		}
		
		return pageRef;
	}
	
	/**
    * Test Confirme overlay component
    */
    public static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
		
		Test.setCurrentPageReference( new PageReference( 'Page.ProjectDetail' ) );
		System.currentPageReference().getParameters().put( 'id', GenerateEnvironmentTest.project.id );
		
		ConfirmOverlayController confirm = new ConfirmOverlayController();
		confirm.title 				= 'test';
		confirm.messageToUser 		= 'test message';
		confirm.actionIds 			= '';
		confirm.exceptionMessage 	= '';
		confirm.postAction 			= '';
		
		confirm.actionName 	= 'DeleteTasks';
		confirm.actionIds 	= '';
		confirm.action();
		System.assertEquals( 'DeleteTasksSuccess', confirm.postAction );
		
		confirm.actionName 	= 'DeleteDetailTask';
		confirm.actionIds 	= '';
		confirm.action();
		System.assertEquals( 'DeleteTasksSuccess', confirm.postAction );
		
		confirm.actionName 	= 'MarkCompleteTasks';
		confirm.actionIds 	= '';
		confirm.action();
		System.assertEquals( 'TasksMarkCompleteSuccess', confirm.postAction );
		
		confirm.actionName 	= 'deleteAttachments';
		confirm.actionIds 	= '';
		confirm.action();
		System.assertEquals( 'DeleteAttachmentsSuccess', confirm.postAction );
		
		confirm.actionName 	= 'DeleteMembers';
		confirm.actionIds 	= '';
		confirm.action();
		System.assertEquals( 'DeleteMembersSuccess', confirm.postAction );
		
		confirm.actionName 	= 'DeleteProject';
		confirm.actionIds 	= '';
		confirm.action();
		System.assertEquals( 'DeleteProjectsSuccess', confirm.postAction );
		
		confirm.actionName 	= 'ProjectDetailDeleteAttachments';
		confirm.actionIds 	= '';
		confirm.action();
		System.assertEquals( 'ProjectDetailDeleteAttachmentsSuccess', confirm.postAction );
		
		confirm.actionName 	= 'TaskDetailDeleteAttachmentOverlay';
		confirm.actionIds 	= '';
		confirm.action();
		System.assertEquals( 'TaskDetailDeleteAttachmentOverlaySuccess', confirm.postAction );
		
		confirm.actionName 	= 'TaskDetailDeleteAssigneeOverlay';
		confirm.actionIds 	= '';
		confirm.action();
		System.assertEquals( 'TaskDetailDeleteAssigneeOverlaySuccess', confirm.postAction );
		
		confirm.actionName 	= 'TaskDetailDeleteCommentOverlay';
		confirm.actionIds 	= '';
		confirm.action();
		System.assertEquals( 'TaskDetailDeleteCommentOverlaySuccess', confirm.postAction );
		
    	Test.stopTest();
		ProjectUtil.setIsTest( false );    	
    }
}