/**
*@author Juan Bessonart @ 07/22/2008
*/
public class UserPermissions {

	/* Vars */
	String id;
	String project;
	String objectType;
	String ownerId;
	
	User projectAdmin = null;
	List<ProjectMember__c> members = null;
	List<Project2__c> currentProject = null;
	ProjectProfile__c profile = null;
	
	/* Booleans */
	Boolean canCreate = false;
	Boolean canManage = false;
	Boolean canComment = false;
	Boolean canView = true;
	
	/**
	* Costructor
	*/
	public UserPermissions (){
		
	}
	
	/**
	*@return String
	*/
	public String getId () {
		return id;
	}

	
	/**
	*@return String
	*/
	public String getProject () {
		return project;
	}
	
	/**
	*@return String
	*/
	public String getObjectType () {
		return objectType;
	}
	
	/**
	*@return Boolean
	*/
	public Boolean getCanCreate () {
		return canCreate;
	}
	
	
	/**
	*@return Boolean
	*/
	public Boolean getCanManage () {
		return canManage;
	}
	
	/**
	*@return Boolean
	*/
	public Boolean getCanComment () {
		return canComment;
	}
	
	/**
	*@return Boolean
	*/
	public Boolean getCanView () {
		return canView;
	}
	
	/**
	*@param String
	*/
	public void setId (String id) {
		this.id = id;
	}
	
	/**
	*@param String
	*/ 	
 	public void setOwnerId (String ownerId) {
		this.ownerId = ownerId;
	}
	
	/**
	*@param String
	*/	
	public void setProject (String project) {
		this.project = project;
	}
	
	/**
	*@param String
	*/	
	public void setObjectType (String objectType) {
		this.objectType = objectType;
	}
	
	/**
	* Get permissions for current user
	*@throws Exception
	*/
	public void setPermissions () {
		try{
			canManage = false;
			canCreate = false;
			canComment = false;
			Boolean isAdmin = false;			
			
			if(projectAdmin == null || projectAdmin.Id != UserInfo.getUserId())
				projectAdmin = [Select id, Profile.PermissionsModifyAllData, ProfileId, Name From User where id =: id limit 1];
			System.debug('permisos' + projectAdmin.Profile.PermissionsModifyAllData);
			if(projectAdmin.Profile.PermissionsModifyAllData){
				canManage = true;
				canCreate = true;
				canView = true;
				canComment = true;
				isAdmin = true;
			}
			if(!isAdmin){
				if(members == null){
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
					
				}
				// If the user is a member of the project we should use the profile assigned to that user
				if (members.size() > 0) {
					
					profile = members[0].Profile__r;
					
				// If the user is not a member of the project then we have to go to the public profile of the project
				// to figure out the permissions.
				}else{
					if(currentProject == null){
						currentProject = new List<Project2__c>();
						
						List<Project2__c> currentProject = [SELECT PublicProfile__c, 
													 Id,
													 PublicProfile__r.ManageProjectTasks__c,
													 PublicProfile__r.CreateProjectTasks__c,
													 PublicProfile__r.Description__c
											  FROM Project2__c
											  WHERE Id =: Project];
										
						if(currentProject.size() > 0) 
						
							profile = currentProject[0].PublicProfile__r;
						
					}
				}				
				if (profile != null) {
					/*		PROJECT		*/
					if (objectType == 'Project') {
						if(profile.CreateProjectTasks__c)
							canCreate = true;	
						if (profile.ManageProjectTasks__c){
							canManage = true; 
							canCreate = true;
						}
					}
					/*     ATTACHMENT   */
					/*
					if(objectType == 'Attachment') {
						if(profile.ManageAttachments__c)
							canManage = true;
					}
					*/
				}
			}
			
			String canManageStr = (canManage) ? 'true' : 'false';
			System.debug('\n\n User Permissions Results: \n\tObject: ' + objectType + '\n\tCan Manage: ' + canManage + '\n\tCan Create: ' + canCreate+ '\n\tCan Comment: ' + canComment + '\n\tCan View: ' + canView + '\n\n');
			
			if(ownerId == id) 
				canManage = true;  // Shouldnt this be called user UserId?
			
		}catch(Exception e){
			throw e;
		}
	}
}