/**
* @author Matias Menafra 1/6/2010
*/
public class DAOActivity {
	
	/**
	* Constructor
	*/
	public DAOActivity(){
	
	}
	
	/**
	*  
	* @param String projectId
	* @param DateTime timeStamp
	* @param String modifiedBy
	* @param String action
	* @param Integer changeType
	* @param String name
	* @param String access
	*/
	public void logProjectActivity(String projectId, DateTime timeStamp, String modifiedBy, String action, String changeType, String name, String access){
		/*
		ProjectActivity__c prjActivity = new ProjectActivity__c(); 
		prjActivity.ProjectId__c 	= projectId;
		prjActivity.TimeStamp__c 	= timeStamp;
		prjActivity.ModifiedBy__c 	= modifiedBy;
		prjActivity.Action__c 		= action;
		prjActivity.ChangeType__c 	= changeType;
		prjActivity.Access__c 		= access;
		prjActivity.name__c 		= name;
		
		insert prjActivity;*/
	}
	
	/**
	* 
	* @param String projectId
	* @param DateTime timeStamp
	* @param String modifiedBy
	* @param String action
	* @param Integer changeType
	* @param String memberName
	* @return void
	*/
	public void logMemberActivity(String projectId, DateTime timeStamp, String modifiedBy, String action, String changeType, String memberName){
		/*
		MemberActivity__c memActivity = new MemberActivity__c(); 
		memActivity.ProjectId__c 	= projectId;
		memActivity.TimeStamp__c 	= timeStamp;
		memActivity.ModifiedBy__c 	= modifiedBy;
		memActivity.Action__c 		= action;
		memActivity.ChangeType__c 	= changeType;
		memActivity.MemberName__c	= memberName;
		
		insert memActivity;*/
		
	}
	
	/**
	* 
	* @param String projectId
	* @param DateTime timeStamp
	* @param String modifiedBy
	* @param String action
	* @param Integer changeType
	* @param String taskName
	* @return void
	*/
	public void logTaskCommentActivity(String projectId, DateTime timeStamp, String modifiedBy, String action, String changeType, String taskName){
		
		/*TaskCommentActivity__c taskCommentActivity = new TaskCommentActivity__c(); 
		taskCommentActivity.ProjectId__c 	= projectId;
		taskCommentActivity.TimeStamp__c 	= timeStamp;
		taskCommentActivity.ModifiedBy__c 	= modifiedBy;
		taskCommentActivity.Action__c 		= action;
		taskCommentActivity.ChangeType__c 	= changeType;
		taskCommentActivity.TaskName__c		= taskName;
		
		insert taskCommentActivity;*/
		
	}
	
	/**
	* 
	* @param String projectId
	* @param DateTime timeStamp
	* @param String modifiedBy
	* @param String action
	* @param Integer changeType
	* @param String assigneeName
	* @param String taskName
	* @return void
	*/
	public void logTaskAssigneeActivity(String projectId, DateTime timeStamp, String modifiedBy, String action, String changeType, String assigneeName, String taskName){
		
		/*TaskAssigneeActivity__c taskAssigneeActivity = new TaskAssigneeActivity__c(); 
		taskAssigneeActivity.ProjectId__c 		= projectId;
		taskAssigneeActivity.TimeStamp__c 		= timeStamp;
		taskAssigneeActivity.ModifiedBy__c 		= modifiedBy;
		taskAssigneeActivity.Action__c 			= action;
		taskAssigneeActivity.ChangeType__c 		= changeType;
		taskAssigneeActivity.AssigneeName__c	= assigneeName;
		taskAssigneeActivity.TaskName__c		= taskName;
		
		insert taskAssigneeActivity;*/
		
	}
	
	/**
	* 
	* @param String projectId
	* @param DateTime timeStamp
	* @param String modifiedBy
	* @param String action
	* @param Integer changeType
	* @param String name
	* @param String newName
	* @param String duration
	* @param String status
	* @param Boolean complete
	* @return void
	*/
	public void logTaskActivity(String projectId, DateTime timeStamp, String modifiedBy, String action, String changeType, String name, String newName, String duration, String status, Boolean complete){
		
		/*TaskActivity__c taskActivity = new TaskActivity__c(); 
		taskActivity.ProjectId__c 	= projectId;
		taskActivity.TimeStamp__c 	= timeStamp;
		taskActivity.ModifiedBy__c 	= modifiedBy;
		taskActivity.Action__c 		= action;
		taskActivity.ChangeType__c 	= changeType;
		taskActivity.Name 			= name;
		taskActivity.NewName__c		= newName;
		taskActivity.Duration__c	= duration;
		taskActivity.Status__c		= status;
		taskActivity.Complete__c	= complete;
		
		insert taskActivity;*/
		
	}
	
	/**
	* 
	* @param String projectId
	* @param DateTime timeStamp
	* @param String modifiedBy
	* @param String action
	* @param Integer changeType
	* @return void
	*/
	public void logAttachmentActivity(String projectId, DateTime timeStamp, String modifiedBy, String action, String changeType){
		/*
		AttachmentActivity__c attachmentActivity = new AttachmentActivity__c(); 
		prjActivity.ProjectId__c 	= projectId;
		prjActivity.TimeStamp__c 	= timeStamp;
		prjActivity.ModifiedBy__c 	= modifiedBy;
		prjActivity.Action__c 		= action;
		prjActivity.ChangeType__c 	= changeType;
		
		insert prjActivity;
		*/
	}

	/**
	* @param 
	* @return Project2__c
	*/
	public List<Project2__c> getActivityForProject( String projectId ){
		List<Project2__c> prjActivity = [Select  p.Id, 
						(Select Id, OwnerId, Name, Action__c, ChangeType__c, ModifiedBy__c, ProjectId__c, TimeStamp__c, TaskName__c From TaskCommentActivites__r), 
						(Select Id, OwnerId, Name, Action__c, ChangeType__c, ModifiedBy__c, TimeStamp__c, ProjectId__c, AssigneeName__c, TaskName__c From TaskAssigneeActivites__r), 
						(Select Id, OwnerId, Name, Action__c, ChangeType__c, ModifiedBy__c, ProjectId__c, TimeStamp__c, NewName__c, Duration__c, Status__c, Complete__c From TaskActivites__r), 
						(Select Id, OwnerId, Name, ProjectId__c, ModifiedBy__c, TimeStamp__c, Action__c, name__c, Access__c, ChangeType__c From ProjectActivities__r), 
						(Select Id, OwnerId, Name, MemberName__c, Action__c, ChangeType__c, ModifiedBy__c, TimeStamp__c, ProjectId__c From MemberActivities__r) 
						From Project2__c p where p.id=:projectId ];
		
		return prjActivity;						
	}
}