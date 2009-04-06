/**
*@author Ignacio Toledo @ 30/03/2009
*/
public class ProjectSubscriptionController {
	
	public String idProject = System.currentPageReference().getParameters().get('id');
	public Integer subscriptionCount; 

	/**
	* Constructor
	*/
	public ProjectSubscriptionController () {
		constructMethods(); 
	}
	
	/**
	*@return Integer
	*/
	public Integer getSubscriptionCount () {
		return subscriptionCount;
	}
	
	public ProjectSubscription__c subscription = new ProjectSubscription__c();
	
	/**
	*@return ProjectSubscription__c
	*/
	public ProjectSubscription__c getSubscription () {
		return subscription;
	}
	
	/**
	*@param String
	*/
	public void setIdProject (String idProject) {
		this.idProject = idProject; 
	}
	
	/**
	*@return String
	*/
	public String getIdProject () {
		return idProject;
	}

	/**
	* Execute on Construct
	*/
	public void constructMethods () {
		if (idProject != null) {
			List<ProjectSubscription__c> teamSubList = new List<ProjectSubscription__c>();
			teamSubList = [select id,
							ProjectTaskAssignedToMe__c,
							ProjectTaskAssignToMeChanged__c,
							ProjectTaskChanged__c,
							ProjectTaskDeleted__c,
							Project__c,
							User__c
						from ProjectSubscription__c where User__c =:UserInfo.getUserId() and Project__c =: idProject limit 1];
			if (teamSubList.size() > 0 ) {
				subscription = teamSubList[0];
			}	
			subscriptionCount = teamSubList.size();
		}
	}
	
	/**
	* Save suscription
	*@return PageReference
	*/
	public PageReference saveSubscription () {
		if (subscriptionCount > 0) {
			update 	subscription;	
		}else {
			subscription.Project__c = idProject;
			subscription.User__c = UserInfo.getUserId();
			insert subscription;
			System.debug( '<><><>' + subscription.ProjectTaskAssignedToMe__c);
		}
		PageReference pageRef = Page.ProjectDetail;
		pageRef.getParameters().put('id', idProject);
		pageRef.setRedirect(true);
		return pageRef;
	}
	
	/**
	* Cancel suscription
	*@return PageReference
	*/
	public PageReference cancelSubscription () {
		PageReference pageRef = Page.ProjectDetail;
		pageRef.getParameters().put('id', idProject);
		pageRef.setRedirect(true);
		return pageRef;
	}
	
	/**
	* Delete subscription
	*@return PageReference
	*/
	public PageReference deleteSubscription () {
		if (subscription != null && subscriptionCount > 0 ) 
			delete subscription;
		
		PageReference pageRef = Page.ProjectDetail;
		pageRef.getParameters().put('id', idProject);
		pageRef.setRedirect(true);
		return pageRef;
	}
	
}