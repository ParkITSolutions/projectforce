/**
* @author Matias Menafra
* @dateCreated 01/22/2010
*/
public class ObjectFormatter{

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
			/*
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
			*/
		}
		return projectActivities;
	}
	
	/**
	*	
	*
	*/
	public static List<Task> formatTasks( List<ProjectTask__c> taskList ){
		
		List<Task> tasks = new List<Task>();
		
		List<String> taskIds = new List<String>();
		for( ProjectTask__c cTaskIds : taskList ){ taskIds.add(cTaskIds.Id); }
		
		List<TaskAssignee> assigneeList = DAOFactory.getInstance().getAssignees( taskIds );
		
		for(ProjectTask__c task : taskList){
    		
    		List<TaskAssignee> auxListIds = new List<TaskAssignee>();
    		Task taskAux = new Task();
    		
    		taskAux.id 					= task.id;
			taskAux.idDisplay 			= task.Id__c;
			taskAux.project				= task.Project__c;
			taskAux.name 				= task.Name; 
			taskAux.status 				= task.Status__c;
			taskAux.ownerId 			= task.OwnerId;
			taskAux.CreatedById			= task.CreatedById;
			taskAux.isMilestone 		= task.Milestone__c;
			taskAux.priority 			= task.Priority__c; 
			taskAux.setPercentCompleted( task.PercentCompleted__c );
			taskAux.durationDisplay 	= String.valueOf( task.Duration__c );
			taskAux.Description = task.Description__c;
			
			if( task.Milestone__c ){
				taskAux.endDateDisplay 	= String.valueOf( task.StartDate__c.format() );
				taskAux.endDate 		= task.StartDate__c;
			}else{
				taskAux.endDateDisplay 	= String.valueOf( task.EndDate__c.format() );
				taskAux.endDate 		= task.EndDate__c;
			}
			
			for(TaskAssignee cAssignee : assigneeList)
			{
				if(cAssignee.projectTask == task.id)
				{
					auxListIds.add(cAssignee);
				}
			}
			
			taskAux.assignees = auxListIds;
    		tasks.add( taskAux );
    	}
    	
    	UserPermissions permissions = new UserPermissions();
    	tasks = permissions.generateTaskPermissions( tasks );
    	
    	return tasks;
	}
	
	/**
	* 
	* @param assignees
	* @return resultAssignees
	*/
	public static List<TaskAssignee> formatTaskAssignees( List<ProjectAssignee__c> assignees ){
		
		List<TaskAssignee> resultAssignees = new List<TaskAssignee>();
		
		for( ProjectAssignee__c row : assignees ){
			
			TaskAssignee assignee = new TaskAssignee();
			assignee.id				= row.Id;
			assignee.name	 		= row.User__r.Name;
			assignee.project 		= row.Project__c;
			assignee.user 			= row.User__c;
			assignee.projectTask 	= row.ProjectTask__c;
			
			resultAssignees.add( assignee );
		}		
		
		return resultAssignees;
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
				currentResult.url			= 'ProjectDetail?id=' + iter.Id;
				
				results.add( currentResult );
			}
		}
		
		if( objectType == 'projectTask' ){
			
			resultsTasks = (List<ProjectTask__c>) resultList;
			
			for( ProjectTask__c iter: resultsTasks ){
				SearchResults currentResult = new SearchResults();
				
				currentResult.setName( iter.Name, searchTerm );
				currentResult.realName 		= ProjectUtil.chopPhraseTo30Chs( iter.Name , 30 );
				currentResult.iD 			= iter.Id;
				currentResult.resultType 	= 'Project';
				currentResult.setMatches( iter.Description__c, searchTerm );
				currentResult.url			= 'ProjectTaskDetail?id=' + iter.Id;
				
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
			att.weight 			= ((iter.BodyLength / 1024) > 0) ? String.valueOf( iter.BodyLength / 1024 ) + ' Kb' : String.valueOf(iter.BodyLength) + ' b';
			att.createdBy 		= iter.CreatedBy.Name;
			att.createdDate 	= iter.CreatedDate;
			att.ContentType		= iter.ContentType;
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
            tempTask.startDate 			= row.ProjectTask__r.startDate__c == null ? null : row.ProjectTask__r.startDate__c; 
            tempTask.startDateDisplay 	= row.ProjectTask__r.startDate__c == null ? null : row.ProjectTask__r.startDate__c.format();
            tempTask.endDate 			= row.ProjectTask__r.endDate__c == null ? null : row.ProjectTask__r.startDate__c;
            tempTask.endDateDisplay 	= row.ProjectTask__r.endDate__c == null ? null : row.ProjectTask__r.endDate__c.format();
            tempTask.status 			= row.ProjectTask__r.status__c;
            tempTask.priority 			= row.ProjectTask__r.priority__c;
            tempTask.isMilestone 		= row.ProjectTask__r.milestone__c;
            tempTask.setPercentCompleted( row.ProjectTask__r.percentCompleted__c );
            tempTask.duration 			= Double.valueOf( row.ProjectTask__r.durationUI__c ); 
            
            tasks.add( tempTask ); 
        }
 	
		return tasks;
	}
	
	/**
    * Test Object Formatter
    */
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
		
		ObjectFormatter format = new ObjectFormatter();
		
		List<Activity__c> activityList 	= new List<Activity__c>();
		ObjectFormatter.formatProjectActivities( activityList );
		
		List<ProjectTask__c> taskList1 = new List<ProjectTask__c>();
		taskList1.add( GenerateEnvironmentTest.task );
		taskList1.add( GenerateEnvironmentTest.task2 );
		taskList1.add( GenerateEnvironmentTest.mile );
		ObjectFormatter.formatTasks( taskList1 );
		
		List<ProjectAssignee__c> listOfAssignees = new List<ProjectAssignee__c>();
		//listOfAssignees.add( GenerateEnvironmentTest.assi );
		//listOfAssignees.add( GenerateEnvironmentTest.assi2 );
		ObjectFormatter.formatAssigneeTask( listOfAssignees );
		
		List<ProjectTask__c> resultList = new List<ProjectTask__c>();
		resultList.add( GenerateEnvironmentTest.task );
		resultList.add( GenerateEnvironmentTest.task2 );
		resultList.add( GenerateEnvironmentTest.mile );
		ObjectFormatter.formatSearchResults( GenerateEnvironmentTest.task.Name, resultList, 'projectTask' );
		
		List<Project2__c> resultList2 = new List<Project2__c>();
		resultList2.add( GenerateEnvironmentTest.project );
		resultList2.add( GenerateEnvironmentTest.project2 );
		resultList2.add( GenerateEnvironmentTest.project3 );
		ObjectFormatter.formatSearchResults( GenerateEnvironmentTest.project2.Name, resultList2, 'project' );
		
		List<Attachment> attachments = new List<Attachment>();
		Attachment uploadFile 	= new Attachment( Name = 'Name1', Body = Blob.valueOf(' fdsfdsf dsa fds fsd fsd fsd fsdf sd'), ContentType = 'plain/text' );
		Attachment uploadFile2 	= new Attachment( Name = 'Name2', Body = Blob.valueOf(' fdsfdsfsdfdsf dsfsdf sdafds fads'), ContentType = 'plain/text' );
		uploadFile.ParentId 	= GenerateEnvironmentTest.task.Id;
		uploadFile2.ParentId 	= GenerateEnvironmentTest.task.Id;
		attachments.add( uploadFile );
		attachments.add( uploadFile2 );
		insert attachments;
		
		//ObjectFormatter.formatAttachments( attachments );
		
		List<ProjectAssignee__c> assignees = new List<ProjectAssignee__c>();
		assignees.add( GenerateEnvironmentTest.assi );
		assignees.add( GenerateEnvironmentTest.assi2 );
		ObjectFormatter.formatTaskAssignees( assignees );
		
    	Test.stopTest();
		ProjectUtil.setIsTest( false );    	
    }
}