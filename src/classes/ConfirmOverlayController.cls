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
				
				String projectId = DAOFactory.getInstance().getTask(this.actionIds).Project__c;
				
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
			if ( this.actionName == 'DeleteProjectAttachment'){
				DAOFactory.getInstance().deleteAttachments(this.actionIds);
				this.postAction = 'DeleteAttachmentSuccess';
			}
		}catch( CustomException e ){
			Apexpages.addMessages( e );
			this.exceptionMessage = e.getMessage();
		}
		
		return pageRef;
	}
	

}