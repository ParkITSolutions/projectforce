/**
* @author Andres Canavesi
*/
public class DAOTaskComment {
	
	/**
	* Constructor
	*/
	public DAOTaskComment(){
	
	}
	
	/**
	* Delete a comment from a task
	* @param String taskCommentId
	*/
	public void deleteTaskComment(String taskCommentId){
		List<TaskComment__c> comments = new List<TaskComment__c>();
		comments = [select Id from TaskComment__c where Id =: taskCommentId];
		if(comments.size() > 0)
			delete comments;
	}
}