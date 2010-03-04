/**
* @author Andres Canavesi 
* @dateCreated 12/15/2009
*/
public class DAOMember {
	
	private DAOAssignee DAOAssignee;
	private DAOTask DAOTask;
	
	/**
	* Constructor
	*/
	public DAOMember(){
		this.DAOAssignee 	= new DAOAssignee();
		this.DAOTask 		= new DAOTask();
	}
	
	/**
	* Deletes members belonging to a project.
	* One member can be deleted if:
    * 	-Is not the last project administrator.
	* @param members members ids string separated by ":"
	* @param projectId
	* @throws CustomException It can not delete all project administrators
	*/
	public void deleteMembers( String members, String projectId ){
		
		List<String> membersIds = new List<String>();
        membersIds = members.split(':'); 
        List<ProjectMember__c> membersAdmin = [select Id 
            							       from ProjectMember__c 
            							       where id not in: membersIds
            							       and Project__c =: projectId
            							       and Profile__r.Name = 'Project Administrator'];
		if(membersAdmin.size()==0){
			throw new CustomException('It can not delete all project administrators.');
		}            			
        
        List<ProjectMember__c> membersToDelete = [ select Id from ProjectMember__c where id in: membersIds ];
            
		delete membersToDelete;
	}
	
	/**
	* @return permissionsModifyAllData
	*/
	public Boolean isCRMAdministrator(){
		
		User user = [select Profile.PermissionsModifyAllData
					 from User 
					 where id =: Userinfo.getUserId()
					 limit 1];
							 
		return user.Profile.PermissionsModifyAllData;
	}

	/**
	* retrives a member by User id
	* @param userId
	* @return member
	*/
	public ProjectMember__c getMemberByUserId(String userId){

		ProjectMember__c member = [select Id, Name, CreatedDate, CreatedById, Profile__c, Project__c, User__c 
		                           from ProjectMember__c
                                   where User__c=:userId 
                                   limit 1];
		return member;
	}
	
	/**
	* @return a list of members candidates to be assigned
	*/
	public List<ProjectMember__c> getCandidatesToAssign(String taskId){
		
		List<TaskAssignee> assignees 	= DAOAssignee.getAssignees(taskId);
		List<Id> assigned 			= new List<Id>();
		
		for(TaskAssignee assignee: assignees)
		{
			assigned.add(assignee.user);
		} 
		
		ProjectTask__c task = DAOTask.get(taskId);
		
		return [select Id, Name, User__c
		        from ProjectMember__c 
			    where Project__c =: task.Project__c
			    and User__r.IsActive != false 
				and User__c not in: assigned ];
	}

	/**
	*@return List<ProjectMember__c>
	*/
	public List<ProjectMember__c> getProjetsInfoByMember( Id us ){
		
		List<ProjectMember__c> memList = new List<ProjectMember__c>();
		try{
			memList = [ SELECT Project__c, Project__r.Picture__c, Project__r.name, Project__r.Description__c, Project__r.Priority__c, Project__r.DisplayDuration__c, Project__r.DaysInWorkWeek__c FROM ProjectMember__c WHERE User__c =:  us ];
		}catch (Exception e){
			memList = null;
		}
		
		return memList;
	}
	
	/**
	* Insert a list of new members in a project
	*@param List<ProjectMember__c> newMemberList
	*/
	public void newMemberList(List<ProjectMember__c> newMemberList){
		insert newMemberList;
	}
	
	/**
	* gets all members of a given project
	* @param projectId
	* @param filter a filter criteria
	* @param orderBy column name
	* @param orderAsc true if order way must be ascending or descendant
	* @letter letter to filter
	* @return members a list of members
	*/
	public ApexPages.StandardSetController getByProject( String projectId, String filter, String orderBy, Boolean orderAsc, String letter ){
		
		if(letter=='All'){
			letter='';
		}
		String orderWay = 'DESC';
		if( orderAsc ){
			orderWay = 'ASC';
		}
		String condition = '';
		if( filter == '1' ){ //all
			condition = '';
		}
		if( filter == '2' ){ //all members
			condition = 'and Profile__r.Name = \'Member Profile\' ' ;
		}
		if( filter == '3' ){ //all administrators
			condition = 'and Profile__r.Name = \'Project Administrator\' ';
		}
		if(orderBy == 'name'){
			orderBy = 'Name';
		}
		if(orderBy == 'company'){
			orderBy = 'User__r.CompanyName';
		}
		if(orderBy == 'title'){
			orderBy = 'User__r.Title';
		}
		if(orderBy == 'projectProfile'){
			orderBy = 'Profile__r.Name';
		}
		
		String query = 'select id, ' + 
							'Name, ' +
							'User__r.Title, ' +
							'User__r.CompanyName, ' +
							'Profile__r.Name ' +
						'from ProjectMember__c  ' + 
						'where Project__c = \''+projectId+'\' ' +  
						'and Name like \''+letter+'%\' ' +  
						''+condition +' ' + 
						'order by '+orderBy+' '+orderWay; 
		
		ApexPages.StandardSetController members = new ApexPages.StandardSetController( Database.getQueryLocator( query ) );
		if(members.getResultSize() == 0 ){
			return new ApexPages.StandardSetController( new List<ProjectMember__c>() );
		}
		
		return members;
	}
}