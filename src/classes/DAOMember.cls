/**
* @author Andres Canavesi 
* @dateCreated 12/15/2009
*/
public class DAOMember {
	
	private DAOAssignee DAOAssignee;
	
	/**
	* Constructor
	*/
	public DAOMember(){
		this.DAOAssignee = new DAOAssignee();
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
		List<ProjectMember> assignees = DAOAssignee.getAssignees(taskId);
		List<String> assigned = new List<String>();
		for(ProjectMember assignee: assignees){
			assigned.add(assignee.id);
		}
		ProjectTask__c task = DAOFactory.getInstance().getTask(taskId);
		
		return [select Id, Name, User__c
		        from ProjectMember__c 
			    where Project__c =: task.Project__c
			    and User__r.IsActive != false 
				and User__c not in: assigned ];
		
	}
	
}