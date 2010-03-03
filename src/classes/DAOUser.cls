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
	
	/**
	* 
	* 
	* 
	*/
	public Boolean isProjectMember( String projectId ){
		
		ProjectMember__c prjMember = [ Select Id, Name, CreatedDate, Profile__c, Project__c, User__c From ProjectMember__c p Where Project__c =:projectId AND User__c =: Userinfo.getUserId() limit 1];
		
		if( prjMember == null ){
			return false;
		}
		else{
			return true;
		}
	}
	
	/**
	* Return true if the usr usrid is a member of project (projectid)
	* @param String usrId
	* @param String projectId
	* @return Boolean
	*/
	public Boolean isMemberOfProject( String usriId, String projectId ){
		try{
			ProjectMember__c prjMember = [ 	Select Project__c, Id 
											From ProjectMember__c  
											Where Project__c =:projectId AND User__c =: usriId 
											limit 1];
			
			if( prjMember == null ){
				return false;
			}
			else{
				return true;
			}
		}
		catch(Exception e){
			return false;
		}
	}
	/**
	* Find users from a list(where the user is not a member)
	* @param List<String> newMembers
	* @param String idProject
	* @return result
	*/
	public List<User> findUserNotMember(List<String> newMembers, String idProject){
	
		List<User> result = [select Name, Id, Email from User where IsActive != false and Name in : newMembers 
										and Id not in (select User__c  from ProjectMember__c 
										where Project__c =: idProject and Name in : newMembers) order by Name];
		return result;
	}
}