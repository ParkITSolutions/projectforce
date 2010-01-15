public class DAOMember {
	
	public DAOMember(){}
	
	public Boolean isCRMAdministrator(){
		
		User user = [select Profile.PermissionsModifyAllData
					 from User 
					 where id =: Userinfo.getUserId()
					 limit 1];
							 
		return user.Profile.PermissionsModifyAllData;
	}

	/**
	* Method for retrieving a member by Id
	* @param String memberId
	* @return ProjectMember__c
	*/
	public ProjectMember__c getMemberById(String memberId){

		ProjectMember__c member = [Select Id, Name, CreatedDate, CreatedById, Profile__c, Project__c, User__c from ProjectMember__c where User__c=:memberId limit 1];
		return member;
	}
}