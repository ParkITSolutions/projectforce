/**
* @author Matias Menafra
* @createdDate 01/06/2010
*/
public class DAOActivity {
	 
	/**
	* Constructor
	*/
	public DAOActivity(){
	
	}
	
	/**
	* @param projectId
	* @param timeStamp
	* @param modifiedBy
	* @param action
	* @param changeType
	* @param name
	* @param access
	*/
	public void logProjectActivity( String projectId, DateTime timeStamp, String modifiedBy, String action, String changeType, String name, String access ){
		
		ProjectActivity__c prjActivity = new ProjectActivity__c(); 
		Activity__c activity = new Activity__c();
		
		activity.ProjectId__c 	= projectId;
		activity.TimeStamp__c 	= timeStamp;
		activity.ModifiedBy__c 	= modifiedBy;
		activity.Action__c 		= action;
		
		prjActivity.ChangeType__c 	= changeType; 
		prjActivity.Access__c 		= access;
		prjActivity.name__c 		= name;
		
		Database.SaveResult saveResult = Database.Insert( activity, false );
		
		prjActivity.ActivityId__c = saveResult.getId();
		insert prjActivity;
	}
	
	/**
	* @param projectId
	* @param timeStamp
	* @param modifiedBy
	* @param action
	* @param changeType
	* @param memberName
	*/
	public void logMemberActivity( String projectId, DateTime timeStamp, String modifiedBy, String action, String changeType, String memberName ){
		
		MemberActivity__c memActivity = new MemberActivity__c(); 
		Activity__c activity = new Activity__c();
		
		activity.ProjectId__c 	= projectId;
		activity.TimeStamp__c 	= timeStamp;
		activity.ModifiedBy__c 	= modifiedBy;
		activity.Action__c 		= action;
		
		memActivity.ChangeType__c 	= changeType;
		memActivity.MemberName__c	= memberName;
		
		Database.SaveResult saveResult = Database.Insert( activity, false );
		
		memActivity.ActivityId__c = saveResult.getId();
		insert memActivity;
		
	}
	
	/**
	* @param projectId
	* @param timeStamp
	* @param modifiedBy
	* @param action
	* @param changeType
	* @param taskName
	*/
	public void logTaskCommentActivity( String projectId, DateTime timeStamp, String modifiedBy, String action, String changeType, String taskName ){
		
		TaskCommentActivity__c taskCommentActivity = new TaskCommentActivity__c(); 
		Activity__c activity = new Activity__c();
		
		activity.ProjectId__c 	= projectId;
		activity.TimeStamp__c 	= timeStamp;
		activity.ModifiedBy__c 	= modifiedBy;
		activity.Action__c 		= action;
		
		taskCommentActivity.ChangeType__c 	= changeType;
		taskCommentActivity.TaskName__c		= taskName;
		
		Database.SaveResult saveResult = Database.Insert( activity, false );
		
		taskCommentActivity.ActivityId__c = saveResult.getId();
		insert taskCommentActivity;
		
	}
	
	/**
	* @param projectId
	* @param timeStamp
	* @param modifiedBy
	* @param action
	* @param changeType
	* @param assigneeName
	* @param taskName
	*/
	public void logTaskAssigneeActivity( String projectId, DateTime timeStamp, String modifiedBy, String action, String changeType, String assigneeName, String taskName ){
		
		TaskAssigneeActivity__c taskAssigneeActivity = new TaskAssigneeActivity__c(); 
		Activity__c activity = new Activity__c();
		
		activity.ProjectId__c 		= projectId;
		activity.TimeStamp__c 		= timeStamp;
		activity.ModifiedBy__c 		= modifiedBy;
		activity.Action__c 			= action;
		
		taskAssigneeActivity.ChangeType__c 		= changeType;
		taskAssigneeActivity.AssigneeName__c	= assigneeName;
		taskAssigneeActivity.TaskName__c		= taskName;
		
		Database.SaveResult saveResult = Database.Insert( activity, false );
		
		taskAssigneeActivity.ActivityId__c = saveResult.getId();
		insert taskAssigneeActivity;
		
	}
	
	/**
	* @param projectId
	* @param timeStamp
	* @param modifiedBy
	* @param action
	* @param changeType
	* @param name
	* @param newName
	* @param duration
	* @param status
	* @param complete
	*/
	public void logTaskActivity( String projectId, DateTime timeStamp, String modifiedBy, String action, String changeType, String name, String newName, String duration, String status, Boolean complete ){
		
		TaskActivity__c taskActivity = new TaskActivity__c(); 
		Activity__c activity = new Activity__c();
		
		activity.ProjectId__c 	= projectId;
		activity.TimeStamp__c 	= timeStamp;
		activity.ModifiedBy__c 	= modifiedBy;
		activity.Action__c 		= action;
		
		taskActivity.ChangeType__c 	= changeType;
		taskActivity.Name 			= name;
		taskActivity.NewName__c		= newName;
		taskActivity.Duration__c	= duration;
		taskActivity.Status__c		= status;
		taskActivity.Complete__c	= complete;
		
		Database.SaveResult saveResult = Database.Insert( activity, false );
		
		taskActivity.ActivityId__c = saveResult.getId();
		insert taskActivity;
		
	}
	
	/**
	* @param projectId
	* @param timeStamp
	* @param modifiedBy
	* @param action
	* @param changeType
	* @beta still not implemented
	*/
	public void logAttachmentActivity( String projectId, DateTime timeStamp, String modifiedBy, String action, String changeType ){
		/*
		AttachmentActivity__c attachmentActivity = new AttachmentActivity__c(); 
		Activity__c activity = new Activity__c();
		
		activity.ProjectId__c 	= projectId;
		activity.TimeStamp__c 	= timeStamp;
		activity.ModifiedBy__c 	= modifiedBy;
		activity.Action__c 		= action;
		
		prjActivity.ChangeType__c 	= changeType;
		
		Database.SaveResult saveResult = Database.Insert( activity, false );
		
		attachmentActivity.ActivityId__c = saveResult.getId();
		insert prjActivity;*/
		
	}

	/** 
	* @param projectId
	* @return prjActivity
	*/
	public List<Activity__c> getActivityForProjectWidget( String projectId ){
		
		List<Activity__c> prjActivity = [select a.Id, a.TimeStamp__c, a.ProjectId__c, a.ModifiedBy__c, a.Action__c, 
											(select Id, ChangeType__c, TaskName__c, ActivityId__c from TaskCommentActivites__r), 
											(select Id, ChangeType__c, AssigneeName__c, TaskName__c, ActivityId__c from TaskAssigneeActivites__r), 
											(select Id, Name, ChangeType__c, NewName__c, Duration__c, Status__c, Complete__c, ActivityId__c from TaskActivites__r), 
											(select Id, name__c, Access__c, ChangeType__c, ActivityId__c from ProjectActivities__r), 
											(select Id, MemberName__c, ChangeType__c, ActivityId__c from MemberActivities__r) 
										 from Activity__c a 
										 where a.ProjectId__c =:projectId 
										 order by a.TimeStamp__c desc 
										 limit 7];
											
		return prjActivity;
	}
	
	/** 
	* @param projectId
	* @return prjActivity
	*/
	public ApexPages.StandardSetController getActivityForProject( String projectId ){
		
		ApexPages.StandardSetController prjActivity = new ApexPages.StandardSetController( Database.getQueryLocator([select a.Id, a.TimeStamp__c, a.ProjectId__c, a.ModifiedBy__c, a.Action__c, 
																(select ChangeType__c, TaskName__c, ActivityId__c from TaskCommentActivites__r), 
																(select ChangeType__c, AssigneeName__c, TaskName__c, ActivityId__c from TaskAssigneeActivites__r), 
																(select Name, ChangeType__c, NewName__c, Duration__c, Status__c, Complete__c, ActivityId__c from TaskActivites__r), 
																(select name__c, Access__c, ChangeType__c, ActivityId__c from ProjectActivities__r), 
																(select MemberName__c, ChangeType__c, ActivityId__c from MemberActivities__r) 
																	 from Activity__c a 
																	 where a.ProjectId__c =:projectId 
																	 order by a.TimeStamp__c desc 
																	 limit 1000]) );
		
		if( prjActivity.getResultSize() == 0 ){
		
			return new ApexPages.StandardSetController( new List<ProjectTask__c>() );
		}
		
		return prjActivity;	
	}
}