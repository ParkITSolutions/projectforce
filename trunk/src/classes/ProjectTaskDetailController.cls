/**
*@author Nicolas Gunther @ 03/30/2009
*/
public class ProjectTaskDetailController {
	
	private String USERID = UserInfo.getUserId(); 
	private Boolean editDeletePer = false;
	private String projectId = '';
	private Boolean canComment;
	public TaskDetails taskDetail = null;
	public TaskComment__c comment = new TaskComment__c(); 
	public boolean detailsOk;
	public String param = ''; 
	public UserPermissions userPermissions = new UserPermissions();
	public String taskId;
	public void dummyRefresh () {}
	
	public String taskNameShort { set; get; }
	public String projectNameShort { set; get; }
    
	
	/**
	* Constructor
	*/
	public ProjectTaskDetailController(ApexPages.StandardController ctrl){
		param = System.currentPageReference().getParameters().get('id'); 
		getTask(param);
		genPermissions();
		editDeletePer = userPermissions.getCanManage();		
		canComment = userPermissions.getCanComment();
		taskId = System.currentPageReference().getParameters().get('id');
		List<ProjectTask__c> task = new List<ProjectTask__c>();
		task = [select project__c from ProjectTask__c where Id =:taskId];
		
		projectId = task[0].project__c;

	}
	
	/**
	* Do refresh
	*@return void
	*/	
	public void doRefresh (){
		this.getTask(param);
		System.debug('##### doRefresh');
	}
	
	/**
	* Generate permissions for an especific user
	*@return void
	*/
	public void genPermissions() {
		userPermissions.setId(UserInfo.getUserId());
		userPermissions.setObjectType('Project');
		userPermissions.setPermissions();		
	}
	
	/**
	* Return the user's permissions
	*@return UserPermissions
	*/
	public UserPermissions getUserPermissions () {
		return userPermissions;
	}
	
	/**
	*@return task comment
	*/
	public TaskComment__c getComment(){
		return comment;
	}
	
	/**
	* sets task comment
	*@param TaskComment__c c
	*@return void
	*/
	public void setComment (TaskComment__c c){
		comment = c;
	}
	
	
	/**
	* Set the value of task id
	*@param String s
	*@return void
	*/
	public void setTaskId(String s) {
		param = s;
	}
	
	/**
	* Get task id
	*@retun id
	*/
	public String getParam(){
		return param;
	}
	
	/**
	*@return list of task comments
	*/
	public List<TaskComment__c> getTaskComments(){
		List<TaskComment__c> taskComments = new List<TaskComment__c>(); 
		taskComments = [select Id, Body__c, createdDate, createdBy.Name 
							from TaskComment__c 
							where Task__c =: param 
							order by createdDate DESC];
		return taskComments;	
	}
	
	/**
	* Save Task Comment
	*@return void
	*/
	public void saveComment(){
		comment.Task__c = taskDetail.Id;
		insert comment;
		comment = new TaskComment__c();
	}
	
	/*
	* Delete Task Comment
	*@return void
	*/
	public void deleteComment(){
		String idComment = ApexPages.currentPage().getParameters().get('idComment');
		List<TaskComment__c> comments = new List<TaskComment__c>();
		comments = [select Id from TaskComment__c where Id =: idComment];
		if(comments.size() > 0)
			delete comments; 
	}	
	
	/**
	* Method which checks if Task is a parent Task
	*@return boolean
	*/
	public Boolean getIsTaskParent(){
		try{
			ParentTask parent = new ParentTask(); 
			
			ProjectTask__c myTask = [Select PercentCompleted__c, Project__c, Id 
										From ProjectTask__c 
										where Id =: param];
										
			BigListOfTasks bigListOfTasks = new BigListOfTasks(myTask.Project__c);	
			return parent.taskHasChildren(myTask);
			
		}catch(Exception e){
			throw e;
		}
	}
	
	/**
	* Update the task's percent to 100
	*@return void
	*/
	public void markComplete(){
		try{
			ParentTask parent = new ParentTask(); 
			
			ProjectTask__c myTask = [Select PercentCompleted__c, Project__c, Id 
										From ProjectTask__c 
										where Id =: param];
										
			myTask.PercentCompleted__c = 100;
			update myTask;
		}catch(Exception e){
			throw e;
		}
	}
	
	/**
	* Get Project Task  
	*@param String param
	*@return void
	*/
	public void getTask (String param){
		if((param != null) && (param != '')){
			detailsOk = true;
			ProjectTask__c TD = [Select p.Id,p.Project__c,p.Project__r.Name,p.StartDate__c,
									p.Priority__c,p.PercentCompleted__c, p.Name, p.Milestone__c,
									p.LastModifiedById,p.LastModifiedBy.Name,p.LastModifiedDate,
									p.EndDate__c, p.Duration__c, p.Description__c,p.ParentTask__c,
									p.ParentTask__r.Name,p.ParentTask__r.Id,p.CreatedById, 
									p.CreatedBy.Name,p.CreatedDate,	
									(Select Id, Name, ContentType, BodyLength From Attachments), 
									(Select Id, User__c, User__r.Name, User__r.Id,PercentDedicated__c From ProjectsAssignees__r order by User__r.Name) 
									From ProjectTask__c p 
									where p.Id =: param ];
			
			if(TD != null ){
				taskDetail = new TaskDetails();
				taskDetail.id = TD.Id;
				taskDetail.IsTaskOwner = false;
				
				if(((TD.ProjectsAssignees__r).size() != 0) && (TD.ProjectsAssignees__r != null)){
					taskDetail.HasAsignee = true;
					taskDetail.CantAssignees=(TD.ProjectsAssignees__r).size();
					List<ProjectAssignee> assignees = new List<ProjectAssignee>();
					
					for (ProjectAssignee__c item: TD.ProjectsAssignees__r) {
						ProjectAssignee assignUser = new ProjectAssignee();
						assignUser.setId(item.User__r.id);
						assignUser.setAssigneeId(item.id);						
						assignUser.setName(item.User__r.Name);
						if (item.PercentDedicated__c == null) {
							assignUser.setPercent(0);
						}else {
							assignUser.setPercent(item.PercentDedicated__c.intValue());	
						}
						assignees.add(assignUser);
						if(item.User__c == UserInfo.getUserId()) 
							taskDetail.assignToMe = true;	
					}
					taskDetail.Asignee = assignees;
					if(UserInfo.getUserId() == TD.CreatedById){
						taskDetail.IsTaskOwner = true;	
					}
				} else {
					taskDetail.HasAsignee = false;
					taskDetail.IsTaskOwner = false;
					taskDetail.CantAssignees=0;
				}
				taskDetail.Name = TD.Name;
				this.taskNameShort = ProjectUtil.chopWords( ProjectUtil.chopPhrase( taskDetail.Name , 20 ));
				
				userPermissions.setProject(TD.Project__c);
				taskDetail.ProjectId = TD.Project__c;
				taskDetail.ProjectName = TD.Project__r.Name;
				this.projectNameShort = ProjectUtil.chopWords( ProjectUtil.chopPhrase( taskDetail.ProjectName , 20 ));
				taskDetail.Priority = TD.Priority__c;
				taskDetail.StartDate = TD.StartDate__c.format();
				
				if(TD.EndDate__c != null){
					taskDetail.DueDate = TD.EndDate__c.format();
				}else {
					taskDetail.DueDate = '';
				}
				
				taskDetail.Estimate = (TD.Duration__c).intValue();
				taskDetail.Description = TD.Description__c;
				taskDetail.Milestone = TD.Milestone__c;
				
				// Parent Task Data
				if(TD.ParentTask__c != null){
					taskDetail.ParentTaskName = TD.ParentTask__r.Name;
					taskDetail.ParentTaskId = TD.ParentTask__r.Id;
				}
				
				// Last Modified data
				taskDetail.LastModifiedById = TD.LastModifiedById;
				taskDetail.LastModifiedByName = TD.LastModifiedBy.Name;
				taskDetail.LastModifiedDate = ((TD.LastModifiedDate).format('MM/dd/yyyy hh:mm aaa'));
				
				// Created By Data
				taskDetail.CreatedById = TD.CreatedById;
				taskDetail.CreatedByName = TD.CreatedBy.Name;
				taskDetail.CreatedDate = ((TD.CreatedDate).format('MM/dd/yyyy hh:mm aaa')); 
				
				// Percent Completed
				if(TD.PercentCompleted__c != null){
					taskDetail.PercentCompleted = ((TD.PercentCompleted__c).intValue());
				} else {
					taskDetail.PercentCompleted = 0;
				}
				
				//List of files attached
				if((TD.Attachments.size() != 0) || (TD.Attachments == null)){				
					taskDetail.ShowAttachs = true;
					
					List<AttachmentInfo> infos = new List<AttachmentInfo>();

					for (Attachment item: TD.Attachments){	
			            AttachmentInfo info = new AttachmentInfo();
			            info.setId(item.Id);
			            info.setName(item.Name);
			            String ContentType = item.ContentType;
			            String image = '';
			            if (ContentType == null || ContentType == '') {
			            	// I do it for the extension
			            	Integer extPos = item.Name.lastIndexOf('.') + 1;
			            	String extension = item.Name.substring(extPos);	
			           		Map<String, String> typesExt = new Map<String, String>{'rar' => 'rar.gif', 'xls' => 'xls.gif', 'ppt' => 'ppt.gif', 'avi' => 'video.gif', 'mpeg' => 'video.gif', 'flv' => 'video.gif','mpg' => 'video.gif', 'mp3' => 'audio.gif' , 'wav' => 'audio.gif'};	
			           		if(typesExt.containsKey(extension)) {
			           			image = typesExt.get(extension);
			           		}else {
			           			image = 'generic.gif';
			           		}
			            }else {
			           		// I do it for the mime type
			           		Map<String, String> typesMime = new Map<String, String>{'image/jpeg' => 'images.gif', 'image/png' => 'images.gif', 'image/gif' => 'images.gif', 'image/bmp' => 'images.gif', 'application/pdf' => 'pdf.gif', 'text/plain' => 'txt.gif','application/msword' => 'doc.gif', 'application/x-zip-compressed' => 'zip.gif'};	
			           		if(typesMime.containsKey(ContentType)) {
			           			image = typesMime.get(ContentType);
			           		}else {
			           			image = 'generic.gif';
			           		}
			            }
			            info.setAttachImage(image);
			            infos.add(info);
			        }
					taskDetail.Files = infos;				
				} else {
					taskDetail.ShowAttachs = false;
				}
			} 
		} else {
			detailsOk = false;		
		}	
	}
	
	//returns false if the project is closed and the user is not a member
	public boolean getAllowComments(){
		
		List<Project2__c> project = new List<Project2__c>();		
		project = [select Id, Access__c from Project2__c where Id =:projectId];
		
		if(project.size() > 0){
			if(project[0].Access__c.equals('Closed')){
			
				List<ProjectMember__c> userMember = new List<ProjectMember__c>();
				userMember = [select id 
							from ProjectMember__c 
							where project__c =:projectId and User__c =:UserInfo.getUserId() 
							limit 1];

				if (userMember.size() == 0) {
					return false;
				}
				
			}
		}
		
		return true;
	}
	
	/**
	* Inner class for Proyect Assignee
	*@class
	*/
	public class ProjectAssignee {
		String id;
		String AssigneeId;
		String name;
		Integer percent;	
		
		/**
		*@return String
		*/
		public String getId () {
        	return id;
        }
        
        /**
        *@param String AssigneeId
        *@return void
        */
        public void setAssigneeId (String AssigneeId) {
        	this.AssigneeId = AssigneeId;
        }
		/**
		*@return String
		*/
		public String getAssigneeId () {
        	return AssigneeId;
        }
        
        /**
        *@param String id
        *@return void
        */
        public void setId (String id) {
        	this.id = id;
        }        
        /**
		*@return String
		*/
        public String getName() {
        	return name;
        }
		
		/**
        *@param String name
        *@return void
        */
        public void setName(String name) {
       		this.name = name;
        } 
        
        /**
		*@return Integer
		*/
        public Integer getPercent() {
        	return percent;
        }
        
        /**
		*@param Integer percent
		*@return void
		*/
        public void setPercent (Integer percent) {
        	this.percent = percent;
        }
	}
	
	/**
	* Inner class for Attachment Info
	*@class
	*/
	public class AttachmentInfo {
        
        String name;
        String attachImage;
		String id;
        
        /**
		*@return String
		*/
        public String getId () {
        	return id;
        }
        
        /**
        *@param String id
        *@return void
        */
        public void setId (String id) {
        	this.id = id;
        }
        
        /**
		*@return String
		*/
        public String getName() {
        	return name;
        }
		
        /**
        *@param String name
        *@return void
        */
        public void setName(String name) {
        	this.name = name;
        }  
        
        /**
		*@return String
		*/
        public String getAttachImage() {
        	return attachImage;
        }

        /**
        *@param String attachImage
        *@return void
        */
        public void setAttachImage (String attachImage) {
        	this.attachImage = attachImage;
        }          
                                        
	}
	
	
	/**
	*@return boolean
	*/
	public boolean getDetailsOk(){
		return detailsOk;
	}
	
	/**
	*@return TaskDetails
	*/
	public TaskDetails getTask(){
		return taskDetail;
	}
	
	
	/**
	* Delete Attachment
	*@return void
	*/
	public void deleteAttach (){
		String attachId = System.currentPageReference().getParameters().get('idAttach');
		if(attachId != null && attachId != ''){
			Attachment attach = [select Id from Attachment where Id =: attachId];
			delete attach;
		}		
	}
	
	/**
	* Gets Max Assignees
	*@return void
	*/
	public boolean getMaxAssignees(){
				List <ProjectMember__c> AuxList = new List<ProjectMember__c>();
				AuxList = [ select Id 
								from ProjectMember__c 
								where Project__c =: taskDetail.ProjectId  and User__r.IsActive != false];
				System.debug(':::>' + AuxList.size() + ' > ' + taskDetail.CantAssignees); 
				if (taskDetail.CantAssignees==AuxList.size()){
					return true;
				}else return false;
				
			
	}
	
	
	
	/**
	* Inner class for Task Details
	*@class
	*/
	public class TaskDetails {
			
			/**
			* Task Id
			*/
			public String id { 
				get; set; 
			}		   	
		   	
		   	/**
		   	* Task Asignees 
		   	*/
			public List<ProjectAssignee> Asignee { 
				get; set; 
			}
			
			/**
			* Has Asignee
			*/
			public boolean HasAsignee { 
				get; set; 
			}
			/**
			* Cant Asignee
			*/			
			public integer CantAssignees{
				 get; set; 	
			}

			/**
			* Current Viewer is the task owner
			*/
			public boolean IsTaskOwner { 
				get; set; 
			}	
			
			/**
			* Current user has assigned the task
			*/
			public boolean assignToMe {
				get; set;
			}			
			
			/**
			* Task Name
			*/
			public String Name { 
				get; set; 
			}
		    			
			/**
			* Project Name
			*/
			public String ProjectName { 
				get; set; 
			}
			
			/**
			* Project ID
			*/
			public String ProjectId { 
				get; set; 
			}
		   				
			/**
			* Project Priority
			*/
			public String Priority { 
				get; set; 
			}
						
			/**
			* Task Start Date
			*/
			public String StartDate { 
				get; set; 
			}
						
			/**
			* Due Date
			*/
			public String DueDate { 
				get; set; 
			}	
						
			/**
			* Estimated Time
			*/
			public Integer Estimate { 
				get; set; 
			}
						
			/**
			* Description
			*/
			public String Description { 
				get; set; 
			}	
			
			/**
			* Parent Name
			*/
			public String ParentTaskName { 
				get; set; 
			}
						
			/**
			* Parent ID
			*/
			public String ParentTaskId { 
				get; set; 
			}

			/**
			* Last Modified By Id
			*/
			public String LastModifiedById { 
				get; set;
			}
			
			/**
			* Last Modified By Name
			*/
			public String LastModifiedByName { 
				get; set; 
			}
			
			/**
			* Last Modified Date
			*/
			public String LastModifiedDate {
				get; set; 
			}
			
			/**
			* Created By ID
			*/
			public String CreatedById { 
				get; set; 
			}
			
			/**
			* Created By Name
			*/
			public String CreatedByName { 
				get; set; 
			}
			
			/**
			* Created Date
			*/
			public String CreatedDate { 
				get; set; 
			}
			
			/**
			* Created Milestone
			*/
			public Boolean Milestone { 
				get; set; 
			}			
			
			/**
			* Percent Completed
			*/
			public Integer PercentCompleted { 
				get; set; 
			}
			
			/**
			* Show Attachs List?
			*/
			public boolean ShowAttachs { 
				get; set; 
			}
			
			/**
			* Attachment List
			*/
			public List<AttachmentInfo> Files { 
				get; set; 
			}	
	}
}