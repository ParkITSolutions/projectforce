/**
* @author Andres Canavesi
*/
public class DAOSubscription {
	
	/**
	* Constructor
	*/
	public DAOSubscription(){}
	
	
	/** Return list of project subscriptions
	*@param String idProject
	*@return List<ProjectSubscription__c>
	*/
	public List<ProjectSubscription__c> subscriptionProjectList(String idProject){
		
		return [select id,
					ProjectTaskAssignedToMe__c,
					ProjectTaskAssignToMeChanged__c,
					ProjectTaskChanged__c,
					ProjectTaskDeleted__c,
					Project__c,
					User__c
				from ProjectSubscription__c 
				where User__c =:UserInfo.getUserId() and Project__c =: idProject 
				limit 1];
		
	}
	
	/** Insert project subscription
	*@param ProjectSubscription__c subs
	*@return void
	*/
	public void insertProjectsubscription(ProjectSubscription__c subs){
		insert subs;
	}
	
	/** Updtate project subscription
	*@param ProjectSubscription__c subs
	*@return void
	*/
	public void updateProjectsubscription(ProjectSubscription__c subs){
		update subs;
	}
	
	/** Delete project subscription
	*@param ProjectSubscription__c subs
	*@return void
	*/
	public void deleteProjectsubscription(ProjectSubscription__c subs){
		delete subs;
	}
	
}