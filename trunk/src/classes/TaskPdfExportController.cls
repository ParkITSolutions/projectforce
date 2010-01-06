/*
* @author Matias Menafra - 12/10/2009
*/
public class TaskPdfExportController {

	private String USERID = UserInfo.getUserId(); 
	public TaskDetails taskDetail = null;
	public UserPermissions userPermissions = new UserPermissions();
	public String taskId;
    
	/**
	* Constructor
	*/
	public TaskPdfExportController(){
		
		taskId = System.currentPageReference().getParameters().get('id');
		getTask(this.taskId);
		genPermissions();

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
	* Set the value of task id
	*@param String id
	*@return void
	*/
	public void setTaskId(String id) {
		
		this.taskId = id;
	}
	
	/**
	*@return list of task comments
	*/
	public List<TaskComment__c> getTaskComments(){
		
		List<TaskComment__c> taskComments = new List<TaskComment__c>(); 
		taskComments = [select Id, Body__c, createdDate, createdBy.Name 
							from TaskComment__c 
							where Task__c =: this.taskId 
							order by createdDate DESC];
		return taskComments;	
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
										where Id =: this.taskId];
										
			BigListOfTasks bigListOfTasks = new BigListOfTasks(myTask.Project__c);	
			return parent.taskHasChildren(myTask);
			
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
		
			ProjectTask__c TD = [Select p.Id,p.Project__c,p.Project__r.Name,p.StartDate__c,
									p.Priority__c,p.PercentCompleted__c, p.Name, p.Milestone__c,
									p.LastModifiedById,p.LastModifiedBy.Name,p.LastModifiedDate,
									p.EndDate__c, p.Duration__c, p.Description__c,p.ParentTask__c,
									p.ParentTask__r.Name,p.ParentTask__r.Id,p.CreatedById, 
									p.CreatedBy.Name,p.CreatedDate,	p.Status__c,
									(Select Id, Name, ContentType, BodyLength From Attachments), 
									(Select Id, User__c, User__r.Name, User__r.Id,PercentDedicated__c From ProjectsAssignees__r order by User__r.Name) 
									From ProjectTask__c p 
									where p.Id =: param ];
			
			if(TD != null ){
				taskDetail = new TaskDetails();
				taskDetail.id = TD.Id;
				taskDetail.status = TD.status__c;
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
				userPermissions.setProject(TD.Project__c);
				taskDetail.ProjectId = TD.Project__c;
				taskDetail.ProjectName = TD.Project__r.Name;
				taskDetail.Priority = TD.Priority__c;
				taskDetail.StartDate = TD.StartDate__c.format();
				
				if(TD.EndDate__c != null){
					taskDetail.DueDate = TD.EndDate__c.format();
				}else {
					taskDetail.DueDate = '';
				}
				
				taskDetail.Estimate = TD.Duration__c;
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
	*@return TaskDetails
	*/
	public TaskDetails getTask(){
		
		return taskDetail;
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
			* Task status
			*/
			public String status { 
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
			public Double Estimate { 
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