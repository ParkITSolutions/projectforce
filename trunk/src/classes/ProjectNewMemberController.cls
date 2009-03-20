/**
*@author Ignacio Toledo 3/19/2009
*/
public with sharing class ProjectNewMemberController {

	/**
	*@constructor
	*/
	public ProjectNewMemberController (){
		if(idProject != null)
			projectName = [select Name from Project2__c where id=: idProject].Name;	
	}
	
		/**
	* Return the Namespace Prefix
	*@return String
	*/
	public String getNamespace () {
        return ProjectUtil.getNamespace();
    } 
	
	public String idProject = System.currentPageReference().getParameters().get('id');
	
	public String projectName = null;
	
	
	/**
	*@return String
	*/
	public String getProjectName () {
		return projectName;	
	}
	
	/**
	*@param String
	*/
	public void setProjectId(String s){
		idProject = s;
	}
	
	/**
	*@return String
	*/
	public String getProjectId() { 
		return idProject;	
	}

	/**
	* Load Select Menu
	*@return List<SelectOption>
	*/
	public List<SelectOption> getProfilesOptions () {
		List<SelectOption> options = new List<SelectOption>();
		for (ProjectProfile__c item: [select id, Name from ProjectProfile__c order by Name]) 
			options.add(new SelectOption(item.id,item.Name));

		return options;
	}
	
	public Member newMemberVars = new Member();
	
	/**
	*@return Member
	*/
	public Member getNewMemberVars () {
		return newMemberVars;	
	}
	
	/**
	*@param Member
	*/
	public void setNewMemberVars (Member vars) {
		this.newMemberVars = vars;
	}
	
		/**
	* Inner class for Member type
	*@class
	*/
	public class Member {
		String profileId;
		String message;
		String colleagueNames;
		
		/**
		*@return String
		*/
		public String getColleagueNames () {
			return colleagueNames;
		}
		
		/**
		*@param String
		*/
		public void setColleagueNames (String names) {
			this.colleagueNames = names;
		}
		
		/**
		*@return String
		*/
		public String getProfileId () {
			return profileId;
		}
		
		/**
		*@param String
		*/
		public void setProfileId (String profile) {
			this.profileId = profile;
		}	
		
		/**
		*@return String
		*/
		public String getMessage () {
			return message;
		}
		
		/**
		*@param String
		*/
		public void setMessage (String msj) {
			this.message = msj;
		}
		
		
	}//End class Member
	
	public void saveMembersNew () {
		List<ProjectMember__c> newMemberList = new List<ProjectMember__c>();
		List<String> newMembers = newMemberVars.colleagueNames.split(',');
		List<User> userList = new List<User>();
		Boolean already = false;
		
		for(String item: newMembers) {
			List<User> userItem = new List<User>();
			String itemTrim = item.trim();
			userItem = [select id, Name, Email from User where Name =:itemTrim limit 1];
			if (userItem.size() > 0) {
				already = false;
				Integer listPos = 0;
				while (!already && listPos < userList.size()) {
					if(userList[listPos].Name == userItem[0].Name) {
						already = true;
					}
					listPos++;
				}
				if (!already) {
					userList.add(userItem[0]);	
				}
			}
		}
		for (User user : userList) {
			Integer isMember = [select count() from ProjectMember__c where project__c =:idProject and user__c =: user.id];
			if (isMember == 0) {
				ProjectMember__c newMember = new ProjectMember__c();
				newMember.User__c = user.id;
				newMember.Name = user.Name;
				newMember.project__c = idProject;
				newMember.Profile__c = newMemberVars.profileId;
				newMemberList.add(newMember); 
				//SendMail(user,newMemberVars.message); 
			}
		}
		insert newMemberList;
		
		newMemberVars.colleagueNames = '';
		newMemberVars.profileId = '';
		newMemberVars.message = '';
	}
	
	
	public PageReference saveMembers () {
		List<ProjectMember__c> newMemberList = new List<ProjectMember__c>();
		List<String> newMembers = newMemberVars.colleagueNames.split(',');
		List<User> userList = new List<User>();
		Boolean already = false;
		
		for(String item: newMembers) {
			List<User> userItem = new List<User>();
			String itemTrim = item.trim();
			userItem = [select id, Name, Email from User where Name =:itemTrim limit 1];
			if (userItem.size() > 0) {
				already = false;
				Integer listPos = 0;
				while (!already && listPos < userList.size()) {
					if(userList[listPos].Name == userItem[0].Name) {
						already = true;
					}
					listPos++;
				}
				if (!already) {
					userList.add(userItem[0]);	
				}
			}
		}
		
		for (User user : userList) {
			Integer isMember = [select count() from ProjectMember__c where project__c =:idProject and user__c =: user.id];
			if (isMember == 0) {
				ProjectMember__c newMember = new ProjectMember__c();
				newMember.User__c = user.id;
				newMember.Name = user.Name;
				newMember.Project__c = idProject;
				newMember.Profile__c = newMemberVars.profileId;
				newMemberList.add(newMember); 
				//SendMail(user,newMemberVars.message); 
			}
		}
		insert newMemberList;
		
		newMemberVars.colleagueNames = '';
		newMemberVars.profileId = '';
		newMemberVars.message = '';
		
		PageReference pageRef = Page.ProjectMembersList;
		pageRef.getParameters().put('id', idProject);
		pageRef.setRedirect(true);
		return pageRef;	
	}
	
		
}