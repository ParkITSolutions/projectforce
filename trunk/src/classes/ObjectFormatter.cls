/**
* @author Matias Menafra
* @dataCreated 01/22/2010
*/
public class ObjectFormatter {

	/**
	* Constructor
	*/
	//public ObjectFormatter(){
	
	//}
	
	/**
	* 
	*
	*/
	public static List<Activity> formatProjectActivities( List<Activity__c> activityList ){
		
		MessageLog messageObj = new MessageLog();
		List<Activity> projectActivities = new List<Activity>();
		
		for( Activity__c row : activityList ){
			
			Activity auxActivity = new Activity();
			
			auxActivity.modifiedBy 	= row.ModifiedBy__c;
			auxActivity.action 		= row.Action__c;
			auxActivity.timestamp	= row.TimeStamp__c;
			
			if (row.ProjectActivities__r.size() != 0 ){
				auxActivity.changeType 	= row.ProjectActivities__r[0].ChangeType__c;
				auxActivity.message 	= messageObj.getMessage( row.ProjectActivities__r[0] );
			}
			
			if( row.MemberActivities__r.size() != 0 ){
				auxActivity.changeType 	= row.MemberActivities__r[0].ChangeType__c;
				auxActivity.message 	= messageObj.getMessage( row.MemberActivities__r[0] );
			}
			
			if( row.TaskActivites__r.size() != 0 ){
				auxActivity.changeType 	= row.TaskActivites__r[0].ChangeType__c;
				auxActivity.message 	= messageObj.getMessage( row.TaskActivites__r[0] );
			}
			
			if( row.TaskAssigneeActivites__r.size() != 0 ){
				auxActivity.changeType 	= row.TaskAssigneeActivites__r[0].ChangeType__c;
				auxActivity.message 	= messageObj.getMessage( row.TaskAssigneeActivites__r[0] );
			}
			
			if(row.TaskCommentActivites__r.size() != 0 ){
				auxActivity.changeType 	= row.TaskCommentActivites__r[0].ChangeType__c;
				auxActivity.message 	= messageObj.getMessage( row.TaskCommentActivites__r[0] );
			}
			
			auxActivity.setImagePath();
			auxActivity.setHeader();
			
			projectActivities.add( auxActivity );
		}
		return projectActivities;
	}
	
	/**
	*
	*
	*/
	public static List<Task> formatTasks( List<ProjectTask__c> taskList ){
		
		List<Task> tasks = new List<Task>();
	
		for(ProjectTask__c task : taskList){
    		
    		Task taskAux = new Task();
    		
    		taskAux.id = task.id;
			taskAux.idDisplay = task.Id__c;
			taskAux.name = task.Name; 
			taskAux.isMilestone = task.Milestone__c;
			taskAux.priority = task.Priority__c; 
			taskAux.setPercentCompleted( task.PercentCompleted__c );
			taskAux.durationDisplay = String.valueOf(task.Duration__c);
			
			if( task.Milestone__c ){
				taskAux.endDateDisplay = String.valueOf(task.StartDate__c.format());
				taskAux.endDate = task.StartDate__c;
			}else{
				taskAux.endDateDisplay = String.valueOf(task.EndDate__c.format());
				taskAux.endDate = task.EndDate__c;
			}
			
			/*
    		* @todo Change ProjectMember to TaskAssignee.
    		*/
			List<ProjectMember> assignees = DAOFactory.getInstance().getAssignees(taskAux.id);
			
			taskAux.assignees = assignees;
    		
    		tasks.add(taskAux);
    		
    	}
    	
    	return tasks;
	}
}