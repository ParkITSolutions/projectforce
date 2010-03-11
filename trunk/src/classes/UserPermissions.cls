/**
* @author Matias Menafra 
*/
public class UserPermissions {

	/* Vars */
	String id;
	String project;
	String objectType;
	String ownerId;
	
	User projectAdmin 					= null;
	List<ProjectMember__c> members 		= null;
	List<Project2__c> currentProject 	= null;
	ProjectProfile__c profile 			= null;
	
	/* Booleans */
	Boolean canCreate 	= false;
	Boolean canManage 	= false;
	Boolean canComment 	= false;
	Boolean canView 	= true;
	
	public static Boolean canManageStatic = false;

	/**
	* Constructor
	*/
	public UserPermissions(){
		
	}
	
	/**
	* @return String
	*/
	public String getId(){
		return id;
	}
	
	/**
	* @return String
	*/
	public String getProject(){
		return this.project;
	}
	
	/**
	* @return String
	*/
	public String getObjectType(){
		return this.objectType;
	}
	
	/**
	* @return Boolean
	*/
	public Boolean getCanCreate(){
		return this.canCreate;
	}
	
	/**
	* @return Boolean
	*/
	public Boolean getCanManage(){
		return this.canManage;
	}
	
	/**
	* @return Boolean
	*/
	public Boolean getCanComment(){
		return this.canComment;
	}
	
	/**
	* @return Boolean
	*/
	public Boolean getCanView(){
		return this.canView;
	}
	
	/**
	* @param String id
	*/
	public void setId( String id ){
		this.id = id;
	}
	
	/**
	* @param String ownerId
	*/ 	
 	public void setOwnerId( String ownerId ){
		this.ownerId = ownerId;
	}
	
	/**
	* @param String project
	*/	
	public void setProject( String project ){
		this.project = project;
	}
	
	/**
	* @param String objectType
	*/	
	public void setObjectType( String objectType ){
		this.objectType = objectType;
	}
	
	/**
	* Gets permissions for current user
	* @throws Exception
	*/
	public void setPermissions(){
		try{
			canManage = false;
			canCreate = false;
			canComment = false;
			canView = false;
			Boolean isAdmin = false;			
			
			if( projectAdmin == null || projectAdmin.Id != UserInfo.getUserId() )
				projectAdmin = [Select id, Profile.PermissionsModifyAllData, ProfileId, Name 
									From User 
									where id =: id 
									limit 1];
			
			if( projectAdmin.Profile.PermissionsModifyAllData ){
				canManage = true;
				canCreate = true;
				canView = true;
				canComment = true;
				isAdmin = true;
			}
			
			if( !isAdmin ){
					members = new List<ProjectMember__c>();
					
					members = [select
									Profile__r.ManageProjectTasks__c,
									Profile__r.CreateProjectTasks__c,
									Profile__r.Description__c,
									User__c
							  from ProjectMember__c 
							  where User__c =:id 
							  and Project__c=:Project 
							  limit 1];
				
				// If the user is a member of the project we should use the profile assigned to that user
				if ( members.size() > 0 ) {
					profile = members[0].Profile__r;
				
				// If the user is not a member of the project then we have to go to the public profile of the project
				// to figure out the permissions.
				}else{
					currentProject = new List<Project2__c>();
					
					List<Project2__c> currentProject = [SELECT PublicProfile__c, 
												 Id,
												 PublicProfile__r.ManageProjectTasks__c,
												 PublicProfile__r.CreateProjectTasks__c,
												 PublicProfile__r.Description__c
										  FROM Project2__c
										  WHERE Id =: Project];
					
					if( currentProject.size() > 0 ) 
						profile = currentProject[0].PublicProfile__r;
						
				}				
				if( profile != null ){
					/*		PROJECT		*/
					if( objectType == 'Project' ){
						
						if( profile.CreateProjectTasks__c )
							canCreate = true;	
						
						if( profile.ManageProjectTasks__c ){
							canManage = true; 
							canCreate = true;
						}
					
					}
				}
			}
			
			String canManageStr = (canManage) ? 'true' : 'false';
			
			if( ownerId == id ) 
				canManage = true;  // Shouldnt this be called user UserId?

			canManageStatic = canManage;
		}catch( Exception e ){
			throw e;
		}
	}
	
	/*
	* @return boolean
	*/
	public static Boolean getCanManageStatic(){
		return canManageStatic;
	}
	
	public boolean isUserSystemAdministrator( String userId ){
		return null;
	}
	
	public boolean isUserMemberOfProject( String userId, String projectId ){
		return DAOFactory.getInstance().isMemberOfProject( userId, projectId );
	}	
	/*
	*
	* @param taskList
	* @return resultTasks
	*/
	public List<Task> generateTaskPermissions( List<Task> taskList ){
	
		String userId 			= Userinfo.getUserId();
		List<Task> resultTasks 	= new List<Task>();
		
		if( taskList.size() > 0 ){
			Boolean isAdmin			= DAOFactory.getInstance().isAdministrator();
			Boolean isProjectMember	= DAOFactory.getInstance().isMemberOfProject( userId, taskList.get(0).project );
			
			
			for( Task task : taskList ){
				if( !isAdmin ){
					if( isProjectMember ){
						//ask if user is the owner of the task
						if( task.OwnerId != userId ){
							if( task.assignees.size() > 0){
								for( TaskAssignee assignee : task.assignees ){
									if( assignee.user == userId ){
										task.canDelete 				= false;
										task.canUpdate 				= true;
										task.canCreateAssignees 	= true;
										task.canCreateAttachments 	= true;
										task.canDeleteAssignees 	= true;
										task.canDeleteAttachments 	= true;
									}
								}
							}
						}
						else{
							task.canDelete 				= true;
							task.canUpdate 				= true;
							task.canCreateAssignees 	= true;
							task.canCreateAttachments 	= true;
							task.canDeleteAssignees 	= true;
							task.canDeleteAttachments 	= true;
						}
					}	
				}
				else{
					task.canDelete 				= true;
					task.canUpdate 				= true;
					task.canCreateAssignees 	= true;
					task.canCreateAttachments 	= true;
					task.canDeleteAssignees 	= true;
					task.canDeleteAttachments 	= true;
				}
				resultTasks.add( task );
			}
		}
		
		return resultTasks;
	}
	
}