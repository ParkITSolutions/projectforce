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
	* Method for retrieving a member by User id
	* @param String userId
	* @return ProjectMember__c
	*/
	public ProjectMember__c getMemberByUserId(String userId){

		ProjectMember__c member = [Select Id, Name, CreatedDate, CreatedById, Profile__c, Project__c, User__c from ProjectMember__c where User__c=:userId limit 1];
		return member;
	}
}