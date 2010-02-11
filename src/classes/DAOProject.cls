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
		
		project.id = project2.id;
		project.name = project2.name;
		project.description = project2.description__c;
		project.priority = project2.priority__c;
		project.displayDuration = project2.displayDuration__c;
		project.daysWorkWeek = project2.DaysInWorkWeek__c;
		project.setWorkingHours( project2.WorkingHours__c );
		
		return project;
	}
	
	/**
	* @param projectId
	* @return isProjectAdministrator
	*/
	public Boolean isProjectAdministrator( String projectId ){
		
		List<Project2__c> project = [select Id
					       			 from Project2__c
					                 where OwnerId =: Userinfo.getUserId() 
					                 and id =:projectId
					       			 limit 1];
							 
		if(project.size() > 0){
			return true;
		}
		
		return false;
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
	
}