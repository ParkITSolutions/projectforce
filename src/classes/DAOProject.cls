/**
* @author Andres Canavesi
* @dataCreated 12/15/2009
*/
public class DAOProject {
	
	/**
	* Constructor
	*/
	public DAOProject(){}
	
	/**
	* @param projectId
	* @return members
	*/
	public List<ProjectMember__c> getMembers( String projectId ){
		
		List<ProjectMember__c> members = new List<ProjectMember__c>();
		
		members = [select t.Project__c, t.User__r.Name, t.User__r.IsActive, t.Name, t.User__c, t.Id 
	  	 		   from ProjectMember__c t 
	  	 		   where t.Project__c =: projectId 
	  	 		   and t.User__r.IsActive != false];
	  	 		   
	    return members;
		
	}
	
	/** Return project members, order by CreateDate
	* @param projectId
	* @return members
	*/
	public List<ProjectMember__c> getMembersToWidget (String idProject){
		List<ProjectMember__c> members = new List<ProjectMember__c>();
		members = [Select Id, OwnerId,  Name, CreatedDate, Profile__c, Project__c, User__c,  Profile__r.Name 
					from ProjectMember__c where Project__c =: idProject and User__r.IsActive != false
					Order By CreatedDate desc limit 10];
		return members;
	}
	
	/**
	* @param projectId
	* @param project
	*/
	public Project getInfo( String projectId ){
		
		Project2__c project2 = new Project2__c();
		Project project = new Project();
		
		project2 = [select id, name, description__c, priority__c, displayDuration__c, DaysInWorkWeek__c, WorkingHours__c 
		            from Project2__c 
		            where id =: projectId 
		            limit 1 ];
		
		//TODO migrate to ObjectFormatter
		project.id 					= project2.id;
		project.name 				= project2.name;
		project.description 		= project2.description__c;
		project.priority 			= project2.priority__c;
		project.displayDuration 	= project2.displayDuration__c;
		project.daysWorkWeek 		= project2.DaysInWorkWeek__c;
		project.setWorkingHours( project2.WorkingHours__c );
		
		return project;
	}
	
	/**
	* Return true if user is administrator or if is owner of the project
	* @param projectId
	* @return isProjectAdministrator
	*/
	public Boolean isProjectAdministrator( String projectId ){
		
		//If is owner of the project...
		List<Project2__c> prjOwner = [Select OwnerId, Id From Project2__c where Id =: projectId AND OwnerId =: Userinfo.getUserId() ];
		if( prjOwner != null ){
			return true;
		}
		
		//If is member admin of the project...
		ProjectMember__c prjMember = [ Select p.User__c, p.Project__c, p.Profile__r.Name, p.Profile__c, p.Name, p.Id From ProjectMember__c p Where Project__c =:projectId AND User__c =: Userinfo.getUserId() ];
		
		if( prjMember != null ){
			if( prjMember.Profile__r.Name == 'ProjectAdministrator' ){
				return true;
			}
			else{
				return false;
			}	
		}
		else{
			return false;
		}
	}
	
	/**
	* 
	* @param taskId
	* @return task
	*/
	public ApexPages.StandardSetController searchForProjects( String searchTerm, String namespace ){
		
		String searchQ = '%'+ searchTerm +'%';
		
		ApexPages.StandardSetController searchResults = new ApexPages.StandardSetController( Database.getQueryLocator( [Select Id, Name, Description__c From Project2__c Where Name LIKE :searchQ OR Description__c LIKE :searchQ ] ) );
		
		if( searchResults.getResultSize() == 0 ){
			return new ApexPages.StandardSetController( new List<Project2__c>() );
		}
		
		return searchResults;	
	}
	
	
	/**
	* @param void
	* @return Map<String,Id>
	*/
	public Map<String,Id> idProjectProfile(){
		Map<String,Id> projectProfile= new Map<String,Id>();
		for (ProjectProfile__c projectMember : [SELECT Name,Id FROM ProjectProfile__c 
								WHERE Name = 'Project Administrator' or Name = 'Member Profile']) {
			projectProfile.put(projectMember.Name,projectMember.Id);
		}
		return projectProfile;
	}
	
	/**
	* Delete a Project
	* @param Project2__c projectToDelete
	*/
	public void deleteProject(String projectId){
		List<Project2__c> projectToDelete = new List<Project2__c>();		
		projectToDelete = [select Id from Project2__c where Id =: projectId limit 1];
		if ( projectToDelete.size() > 0 ){
			delete projectToDelete[0];
		}
	}

	/**
	* Delete a Project
	* @param pid projec id
	* @return avatarId return the avatar id of the project	
	*/
	public String projectAvatarId( Id pId ){
		String avatarId = '';
		try{
			avatarId = [ SELECT id, picture__c FROM Project2__c WHERE id =: pId LIMIT 1 ].picture__c;
		}catch (Exception e){}
		
		return avatarId;
	}	
}