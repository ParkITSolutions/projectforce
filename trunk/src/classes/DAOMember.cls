/**
* @author Andres Canavesi 
* @dateCreated 12/15/2009
*/
public class DAOMember {
	
	/**
	* Constructor
	*/
	public DAOMember(){
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
}