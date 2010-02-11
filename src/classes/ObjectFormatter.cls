/**
* @author Matias Menafra
* @dataCreated 01/22/2010
*/
public class ObjectFormatter {

	/**
	* Constructor
	*/
	public ObjectFormatter(){
	
	}
	
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
	
	/**
	*
	* @param resultList
	* @param objectType
	* @return resultList
	*/
	public static List<SearchResults> formatSearchResults( String searchTerm, List<Sobject> resultList, String objectType ){
		
		List<SearchResults> results 		= new List<SearchResults>();	
		List<Project2__c> resultsProjects 	= new List<Project2__c>();
		List<ProjectTask__c> resultsTasks 	= new List<ProjectTask__c>();
		
		if( objectType == 'project' ){
			
			resultsProjects = (List<Project2__c>) resultList;
			
			for( Project2__c iter: resultsProjects ){
				SearchResults currentResult = new SearchResults();
				
				currentResult.setName( iter.Name, searchTerm );
				currentResult.realName 		= iter.Name ;
				currentResult.iD 			= iter.Id;
				currentResult.resultType 	= 'Project';
				currentResult.setMatches( iter.Description__c, searchTerm );
				
				results.add( currentResult );
			}
		}
		
		if( objectType == 'projectTask' ){
			
			resultsTasks = (List<ProjectTask__c>) resultList;
			
			for( ProjectTask__c iter: resultsTasks ){
				SearchResults currentResult = new SearchResults();
				
				currentResult.setName( iter.Name, searchTerm );
				currentResult.realName 		= iter.Name ;
				currentResult.iD 			= iter.Id;
				currentResult.resultType 	= 'Project';
				currentResult.setMatches( iter.Description__c, searchTerm );
				
				results.add( currentResult );
			}
		}
		
		return results;
	}
	
	/**
	* 
	*
	*/
	public static List<AttachmentObj> formatAttachments( List<Attachment> attachments ){
		
		List<AttachmentObj> formattedAttachments = new List<AttachmentObj>();
		
		for( Attachment iter: attachments ){
			AttachmentObj att = new AttachmentObj();
			
			att.realId			= iter.Id;
			att.name 			= iter.Name;
			att.weight 			= String.valueOf( iter.BodyLength / 1024 ) + ' Kb';
			att.createdBy 		= iter.CreatedBy.Name;
			att.createdDate 	= iter.CreatedDate;
			
			formattedAttachments.add( att );
		}
		
		return formattedAttachments;
	} 
	
	/**
	* 
	*
	*/
	public static List<Task> formatAssigneeTask( List<ProjectAssignee__c> listOfAssignees ){
	
        Task tempTask;
        List<Task> tasks = new List<Task>(); 
        
        for( ProjectAssignee__c row : listOfAssignees ){ 
            
            tempTask = new Task();
            
            tempTask.project 			= row.project__c;
            tempTask.projectName 		= projectUtil.chopWord( row.project__r.name );
            tempTask.id 				= row.ProjectTask__c;
            tempTask.setName( ProjectUtil.chopWord( row.ProjectTask__r.name ));
            tempTask.startDate 			= row.ProjectTask__r.startDate__c; 
            tempTask.startDateDisplay 	= row.ProjectTask__r.startDate__c == null ? null : row.ProjectTask__r.startDate__c.format();
            tempTask.endDate 			= row.ProjectTask__r.endDate__c;
            tempTask.endDateDisplay 	= row.ProjectTask__r.endDate__c == null ? null : row.ProjectTask__r.endDate__c.format();
            tempTask.status 			= row.ProjectTask__r.status__c;
            tempTask.priority 			= row.ProjectTask__r.priority__c;
            tempTask.isMilestone 		= row.ProjectTask__r.milestone__c;
            tempTask.setPercentCompleted( row.ProjectTask__r.percentCompleted__c );
            tempTask.duration 			= Double.valueOf(row.ProjectTask__r.durationUI__c); 
            
            tasks.add( tempTask ); 
        }
 	
		return tasks;
	}
}