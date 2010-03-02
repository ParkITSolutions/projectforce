/**
* @author Nicolas Dominguez
*/
public class ProjectSubscriptionController {
	
	public String projectId							{ set; get; } 
	public Integer subscriptionCount				{ set; get; } 
	public ProjectSubscription__c subscription		{ set; get; }
	public String ProjectName						{ set; get; }
	public String postAction 	    				{ set; get; }
	public String Message							{ set; get; }
	
	
	/**
	* Constructor
	*/
	public ProjectSubscriptionController(){
		this.projectId = System.currentPageReference().getParameters().get('id');
		this.subscription = new ProjectSubscription__c();
		this.ProjectName=ProjectUtil.chopWords( ProjectUtil.chopPhrase( DAOFactory.getInstance().getProjectInfo(this.projectId).name , 20 ) );
		
		loadProjectSubscription();
	}
	
	/**
	* Execute on Construct
	*/
	public void loadProjectSubscription(){
		if( this.projectId != null ) {
			List<ProjectSubscription__c> subProjList = new List<ProjectSubscription__c>();

			subProjList = DAOFactory.getInstance().subscriptionProjectList(this.projectId);		
			if( subProjList.size() > 0 ){
				this.subscription = subProjList[0];
			}	
			
			this.subscriptionCount = subProjList.size();
		}
	}
	
	/**
	* Save suscription
	*/
	public void saveSubscription(){
		
		if( subscriptionCount > 0 ){
			//Update the subscription;
			DAOFactory.getInstance().updateProjectsubscription( this.subscription );
		}
		else{
			this.subscription.Project__c 	= this.projectId;
			this.subscription.User__c 		= UserInfo.getUserId();
			
			//Insert the subscription;
			DAOFactory.getInstance().insertProjectsubscription( this.subscription );
		}
		
		this.Message = 'Project Subscriptions updated Successfully';
	}
	
	/**
	* Cancel suscription
	* @return pageRef
	*/
	public PageReference cancelSubscription(){
		PageReference pageRef = Page.ProjectDetail;
		pageRef.getParameters().put( 'id', this.projectId );
		pageRef.setRedirect( true );
		return pageRef;
	}
	
	/**
	* Delete subscription
	*/
	public void deleteSubscription(){
		if ( this.subscription != null && this.subscriptionCount > 0 ){ 
			this.subscription.ProjectTaskAssignedToMe__c 		= false;
			this.subscription.ProjectTaskAssignToMeChanged__c 	= false;
			this.subscription.ProjectTaskChanged__c 			= false;
			this.subscription.ProjectTaskDeleted__c 			= false;
			 
			DAOFactory.getInstance().updateProjectsubscription( this.subscription );
			this.Message = 'All  email notifications have been disabled';
		}
	}
}