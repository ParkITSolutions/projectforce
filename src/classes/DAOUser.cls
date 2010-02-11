/**
* @author Andres Canavesi
*/
public class DAOUser {
	
	/**
	* Constructor
	*/	
	public DAOUser(){}
	
	/**
	* 
	*
	*
	*/
	public Boolean isAdministrator(){
		
		User user = [select Profile.PermissionsModifyAllData
					 from User 
					 where id =: Userinfo.getUserId()
					 limit 1];
							 
		return user.Profile.PermissionsModifyAllData;
	}
	
	
	/**Find users from a list(where the user is not a member)
	*@param List<String> newMembers
	*@param String idProject
	*@return List<User>
	*/
	public List<User> findUserNotMember(List<String> newMembers, String idProject){
	
		List<User> result = [select Name, Id, Email from User where IsActive != false and Name in : newMembers 
										and Id not in (select User__c  from ProjectMember__c 
										where Project__c =: idProject and Name in : newMembers) order by Name];
		return result;
	}
}