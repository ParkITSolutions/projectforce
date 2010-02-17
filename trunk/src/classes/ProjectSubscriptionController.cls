/**
*@author Ignacio Toledo @ 30/03/2009
*/
public class ProjectSubscriptionController {
	
	public String idProject							{ set; get; } 
	public Integer subscriptionCount				{ set; get; } 
	public ProjectSubscription__c subscription		{ set; get; }
	public String ProjectName						{ set; get; }
	public String postAction 	    				{ set; get; }
	
	
	/**
	* Constructor
	*/
	public ProjectSubscriptionController () {
		this.idProject = System.currentPageReference().getParameters().get('id');
		this.subscription = new ProjectSubscription__c();
		this.ProjectName=ProjectUtil.chopWords( ProjectUtil.chopPhrase( DAOFactory.getInstance().getProjectInfo(this.idProject).name , 20 ) );
		
		loadProjectSubscription();
	}
	
	/**
	* Execute on Construct
	*@return void
	*/
	public void loadProjectSubscription () {
		if (this.idProject != null) {
			List<ProjectSubscription__c> subProjList = new List<ProjectSubscription__c>();

			subProjList = DAOFactory.getInstance().subscriptionProjectList(this.idProject);		
			if (subProjList.size() > 0 ) {
				this.subscription = subProjList[0];
			}	
			this.subscriptionCount = subProjList.size();
		}
	}
	
	/**
	* Save suscription
	*@return Void 
	*/
	//public PageReference saveSubscription () {
	public void saveSubscription () {
		
		if (subscriptionCount > 0) {
			//Update the subscription;
			DAOFactory.getInstance().updateProjectsubscription(subscription);
		}else {
			this.subscription.Project__c = this.idProject;
			this.subscription.User__c = UserInfo.getUserId();
			//Insert the subscription;
			DAOFactory.getInstance().insertProjectsubscription(this.subscription);
		}
		loadProjectSubscription();
	}
	
	/**
	* Cancel suscription
	*@return PageReference
	*/
	public PageReference cancelSubscription () {
		PageReference pageRef = Page.ProjectDetail;
		pageRef.getParameters().put('id', this.idProject);
		pageRef.setRedirect(true);
		return pageRef;
	}
	
	/**
	* Delete subscription
	*@return Void
	*/
	
	//public PageReference deleteSubscription () {
	public void deleteSubscription () {
		if (this.subscription != null && this.subscriptionCount > 0 ){ 
			//delete the subscription;
			DAOFactory.getInstance().deleteProjectsubscription(subscription);
			
			loadProjectSubscription();
		}
	}
}