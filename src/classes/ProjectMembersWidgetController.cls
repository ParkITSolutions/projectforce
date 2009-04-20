/**
*@author Bruno Fagundez @ 6-9-2008
*/
public with sharing class ProjectMembersWidgetController {
	
	// Get Team Id Attribute
	String team;
	public Boolean isAdministrator;
	public Boolean emailNotifications = false;
	public Boolean isManager = false;
	
	/**
	* Constructor
	*/
	public ProjectMembersWidgetController(){
		genPermissions();
		isManager = userPermissions.getCanManage();
	}
	
		
	/**
	*@param b send email notifys
	*/
	public void setEmailNotifications(Boolean b)
	{
		emailNotifications = b;
	}
	
	public Boolean getIsManager(){
		return isManager;	
	}
	
	/**
	*@return send email notifys
	*/
	public Boolean getEmailNotifications(){
		return emailNotifications;
	}
	
			/**
	*@param Boolean admnistrator profile condition
	*/
	public void setIsAdministrator( Boolean op ){
		isAdministrator = op;
	}
	
	/**
	*@return bool is admin
	*/
	public Boolean getIsAdministrator(){
		return isAdministrator;
	}
		
	/**
	* Return the Namespace Prefix
	*@return String
	*/
	public String getNamespace () {
        return ProjectUtil.getNamespace();
    } 
	
	/**
	* Setter method for Team Id variable
	*@param String idTeam
	*/
	public void setTeam(String tID) {
		System.debug('assss' + tID + team);
		if (team == null || team != tID) {
			team = tID;
			genPermissions();
			Boolean canView = userPermissions.getCanView();
			if(!canView){
				throw new CustomException('Insufficient Privileges');
			} 
			assignNewMemberVarsNewProfile();
		}
	}
	
	/**
	*@return String idUser
	*/
	public String getCurrentUser () {
		return UserInfo.getUserId();	
	}
	
	/**
	*@return String idTeam
	*/
	public String getTeam(){
		return team;
	}

	String typeList;
	
	/**
	* Setter method for Team Id variable
	*@param String typeList
	*/
	public void setTypeList(String typeL) {
		typeList = typeL;		
	}
	
	
	public void getIsTeamAdmin(){}	
	
	/**
	*@return String typeList
	*/
	public String getTypeList(){
		return typeList;
	}
	
	/**
	* Return component title
	*@return String
	*/
	public String getComponentHeader () {
		if (typeList == 'adminList') {
			return 'Team Admins';	
		}else {
			return 'Team Members';	
		}
	}
	
	/**
	* Return conditional for LinkAction
	*@return Boolean
	*/
	public Boolean getRenderLinkAction () {
		return (typeList != 'adminList');
	}
	
	/**
	* Get Team Members
	*@return List<TeamMember>
	*/
	public List<TeamMember> getTeamspaceMembers() {
		List<ProjectMember__c> temp = new List<ProjectMember__c>();
      	
        if(typeList == 'adminList') {
        		temp = [select User__r.Id, User__r.Name from ProjectMember__c where Project__c =: team and User__r.IsActive != false and Profile__r.ManageProjectTasks__c = true order by createdDate desc limit 10];
        }else{
        		temp = [select User__r.Id, User__r.Name from ProjectMember__c where Project__c =: team and User__r.IsActive != false order by createdDate desc limit 10];
        }
        Set<Id> users = new Set<Id>();
        for(ProjectMember__c t: temp) {
        	users.add(t.User__c);
		}
		
		Map<Id, User> userMap = new Map<Id, User>();
       
        for(User u: [select Id, Name from User where Id in : users]) {
			userMap.put(u.Id, u);				          	
		}
                    	
        List<TeamMember> members = new List<TeamMember>();
		
		if(temp.size() > 0){ 
	        for(ProjectMember__c t: temp) {
	            TeamMember m = new TeamMember(t, userMap.get(t.User__c));
	            m.Id = t.User__r.Id;
	            String nameAux = t.User__r.Name;
	            if(nameAux.length() > 20)
	            	nameAux = nameAux.substring(0,20);
	            m.username = nameAux;
	            members.add(m);
	        }
		}
		
		temp = null; 
		return members;
    }
    
     /**
    * Returns a String with Ids of the team
    *@return String
    */
    public String getTeamspaceMembersIds(){
    	String ret = '';
    	List<TeamMember> l = getTeamspaceMembers();
    	for(Integer i = 0; i < l.size(); i++){
    		TeamMember tm = l.get(i);
    		if(i+1 == l.size()){//Last element
    			ret += tm.id;
    		}else{
    			ret += tm.id + '-';
    		}	
    	}
    	return ret;
    } 
    
    /**
    * Inner class for TeamMeber type
    *@class
    */
    public class TeamMember{
        
        ProjectMember__c member;
        User profile = new User();
        String username = null;
        String yahoo = '';
        String skype = '';
        String Id = '';
        String picture = '';
        Boolean isPrivate = false;
        
		/**
		* Costructor
		*@param ProjectMember__c
		*@param PeopleProfile__c
		*/
        public TeamMember(ProjectMember__c m, User u) {
            member = m; 
            profile = u;                     
        }       
        
        /**
        *@return String idTeamMember
        */
        public String getId(){
        	return Id;
        }
		
		/**
		*@return ProjectMember__c
		*/
        public ProjectMember__c getMember() {
            return member;
        }
        
        /**
        *@return String
        */
        public String getUsername() { 
       		return username; 
        }
        
        /**
        *@return Boolean
        */
        public Boolean getIsPrivate() { 
       		return isPrivate; 
        }
        
        /**
        *@return String
        */
        public String getYahoo(){
        	if(profile != null){
        		return yahoo;
        	}else {
        	 	return '';
        	}
        }
        
        /**
        *@return String
        */
        public String getSkype(){
        	if(profile != null){	
        		return skype;
        	} else {
        	 	return '';
        	}
        }
        
        /**
        *@return String
        */
        public String getStatus() {	
			return '';
        }
        
        /**
        *@return PeopleProfile__c
        */
        public User getProfile(){         
			return profile;
       	}
		
        /**
        *@return String
        */
        public String getImage() {
        	if(profile != null){
        		return picture;
        	} else {
         		return '';
         	}
        }
    }
	
	// Add new Member
	public String idTeam = System.currentPageReference().getParameters().get('id');
	
	/**
	*@param String ID
	*/
	public void setIdTeam(String s){
		idTeam = s;
	}
	
	public List<ProjectMember__c> membersToInsert = new List<ProjectMember__c>();
	public List<User> mailList = new List<User>();
	public Integer groupCount = 1;
	
	public String teamName = null;
	
	/**
	* Get Team Name
	*@return String team name
	*/
	public String getTeamName () {
		if(teamName == null)
			teamName = [select Name from Project2__c where id =: idTeam].Name;
		return teamName;	
	}
	
	/**
	*@return String
	*/
	public String getTeamId () { 
		return idTeam;	
	}
	
	/**
	*@return List<SelectOption>
	*/
	public List<SelectOption> getProfilesOptions () {
		List<SelectOption> options = new List<SelectOption>();
		for (ProjectProfile__c item: [select id, Name from ProjectProfile__c order by Name]) {
			options.add(new SelectOption(item.id,item.Name));
		}
		return options;
	}
	

	public Member newMemberVars = new Member();
	
	/**
	* Assign new Member vars to new Profile
	*@void
	*/
	public void assignNewMemberVarsNewProfile () {
		List<Project2__c> currentTeam = [select NewMemberProfile__c from Project2__c where id=:idTeam];
		if (currentTeam.size() > 0 && currentTeam[0].NewMemberProfile__c != null) {	
			newMemberVars.profileId = currentTeam[0].NewMemberProfile__c;
		}
	}
	
	/**
	*@return Member
	*/	
	public Member getNewMemberVars () {
		return newMemberVars;	
	}
	
	/**
	*@param Member vars
	*/
	public void setNewMemberVars (Member vars) {
		this.newMemberVars = vars;
	}
	
	/**
	*@class
	*/
	public class Member {
		String profileId;
		String message;
		String teamRole;
		String colleagueNames;
		
		/**
        *@return String
        */
		public String getColleagueNames () {
			return colleagueNames;
		}
		
		/**
        *@param String names
        */
		public void setColleagueNames (String names) {
			this.colleagueNames = names;
		}
		
		/**
        *@return String ID
        */
		public String getProfileId () {
			return profileId;
		}
		
		/**
        *@param String ID
        */
		public void setProfileId (String profile) {
			this.profileId = profile;
		}	
		
		/**
        *@return String Message
        */
		public String getMessage () {
			return message;
		}
		
		/**
        *@param String Message
        */
		public void setMessage (String msj) {
			this.message = msj;
		}
		
		/**
        *@return String Role
        */
		public String getTeamRole () {
			return teamRole;
		}
		
		/**
        *@param String Role
        */
		public void setTeamRole (String tRole) {
			this.teamRole = tRole;
		}	
		
	}
	
	public List<ProjectMember__c> memberListToolkit = new List<ProjectMember__c>();
	
	/**
	*@return List<ProjectMember__c>
	*/
	public List<ProjectMember__c> getMemberListToolkit () {
		return memberListToolkit;
	}
	
	public Integer memberListToolkitCount = 0;
	
	/**
	*@return Integer
	*/
	public Integer getMemberListToolkitCount () {
		return memberListToolkitCount;
	}
		
	Boolean already = false;
	
	/**
	*@return already exist
	*/
	public Boolean getAlready(){
		return already;
	}	
			
	/**
	* Save Member and New
	*@void
	*/
	/* ***
	public void saveMembersNew () {
		List<ProjectMember__c> newMemberList = new List<ProjectMember__c>();
		List<String> newMembers = newMemberVars.colleagueNames.split(',');
		List<User> userList = new List<User>();
		already = false;
		for(String item: newMembers) {
			List<User> userItem = new List<User>();
			String itemTrim = item.trim();
			userItem = [select id, Name, Email from User where IsActive != false and Name =:itemTrim limit 1];
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
				else
					already = true;
			}
		}
		
		for (User user : userList) {
			Integer isMember = [select count() from ProjectMember__c where Project__c =:idTeam and User__r.IsActive != false and user__c =: user.id];
			if (isMember == 0) {
				ProjectMember__c newMember = new ProjectMember__c();
				newMember.User__c = user.id;
				newMember.Name = user.Name;
				newMember.Project__c = idTeam;
				newMember.Profile__c = newMemberVars.profileId;
				newMemberList.add(newMember); 
				mailList.add(user);
				 
			}
		}
		
		userList.clear();
		
		memberListToolkit = newMemberList;
		memberListToolkitCount = newMemberList.size();
		
		membersToInsert = newMemberList;	
		
		newMemberVars.colleagueNames = '';
		newMemberVars.teamRole = '';
		newMemberVars.profileId = '';
		newMemberVars.message = '';
	} **** */

	/**
	* Save Members
	*@void
	*/
	public void saveMembers () {
		List<ProjectMember__c> newMemberList = new List<ProjectMember__c>();
		List<String> newMembers = newMemberVars.colleagueNames.split('[ ]*,[ ]*');
		List<User> userList = new List<User>();
		already = false;
		Map<String, User> usersMap = new Map<String, User>();
		for (User iterUser :[select id, Name, IsActive, Email from User where Name in:newMembers]) {
			usersMap.put(iterUser.Name, iterUser);
		}
		for(String item: newMembers) {
			if (usersMap.get(item) != null) {
				already = false;
				Integer listPos = 0;
				while (!already && listPos < userList.size()) {
					if(userList[listPos].Name == usersMap.get(item).Name) {
						already = true;
					}
					listPos++;
				}
				if (!already) {
					userList.add(usersMap.get(item));
				}else {
					already = true;
				}
			}
		}
		
		Map<Id, ProjectMember__c> teamMemberMap = new Map<Id, ProjectMember__c>();
		for (ProjectMember__c iterMember : [select id, User__c  from ProjectMember__c where Project__c =:idTeam]) {
			teamMemberMap.put(iterMember.User__c,iterMember);
		}

		for (User user : userList) {
			if (teamMemberMap.get(user.Id) == null && usersMap.get(user.Name).IsActive != false) {
				ProjectMember__c newMember = new ProjectMember__c();
				newMember.User__c = user.id;
				newMember.Name = user.Name;
				newMember.Project__c = idTeam;
				
				Id idProfile = null;
				if( isAdministrator )
					idProfile = [SELECT Id FROM ProjectProfile__c WHERE Name = 'Project Administrator' limit 1].id;
				else{
					List<ProjectProfile__c> profileIdList = new List<ProjectProfile__c>();
					profileIdList = [ SELECT id FROM ProjectProfile__c WHERE Name =: 'Member Profile' ]; 
					if (profileIdList != null) { 
						idProfile =  profileIdList[0].id;
					}
				}
								
				newMember.Profile__c = idProfile; 
				newMemberList.add(newMember);

				if(emailNotifications)
					mailList.add(user);
				
			}
		}
		
		userList.clear();
		teamMemberMap.clear();
		usersMap.clear();
		
		memberListToolkit = newMemberList;
		memberListToolkitCount = newMemberList.size();
		    
		//Insert newMemberList;
		membersToInsert = newMemberList;
		newMemberVars.colleagueNames = '';
		newMemberVars.teamRole = '';
		newMemberVars.profileId = '';
		newMemberVars.message = '';
	}
	
	//New save
	public Integer countSaved = 0;
	public Boolean reset = false;
	
	/**
	* Sync Save Members
	*@return PageReference
	*/
	public PageReference syncSaveMembers(){
		Integer endIt =  countSaved + 2;
		for(Integer it = countSaved; it <= endIt; it++){
			if(it < membersToInsert.size()){
				ProjectMember__c tm = membersToInsert[it];
				for(User user: mailList){
					if(tm.User__c == user.id){
						SendMail(user,newMemberVars.message);
					}
				}
				insert tm;
				memberListToolkitCount--;
			}else{
				membersToInsert.clear();
				mailList.clear();
				groupCount = 0;
				reset = true;
			}
		}
		if(reset){
			countSaved = 0;
			reset = false;
		}else{
			countSaved += 3;
		}
		return null;
	}
	
	/**
	* Init save members
	*@return Boolean
	*/
	public Boolean getInitAddMembers (){
		return membersToInsert.size() > 0;
	} 
	
	/**
	* Send mail to new mambers
	*@void
	*/
	public void SendMail(User user, String message) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
       
        String[] toAddresses = new String[] {user.Email};
 		// Assign the addresses for the To and CC lists to the mail object.
		mail.setToAddresses(toAddresses);
		// Specify the address used when the recipients reply to the email.
		mail.setReplyTo('forwardtosfdc@gmail.com');
		// Specify the name used as the display name.
		mail.setSenderDisplayName(user.Name);
		// Specify the subject line for your email address.
		mail.setSubject('You Have Been Added to ' + this.getTeamName());
		// Set to True if you want to BCC yourself on the email.
		mail.setBccSender(false);
		// Optionally append the salesforce.com email signature to the email.
		// The email address of the user executing the Apex Code will be used.
		mail.setUseSignature(true);
		// Specify the html version of the content as well.
		message = (message == null) ? '' : message;
		mail.setHtmlBody(message);
		// Send the email you have created.
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }	
    
    // Sharing rules
	public UserPermissions userPermissions = ProjectDetailController.userPermission.clone();
	
	/**
	* Generate user permissions
	*/
	public void genPermissions() {
		userPermissions.setId(UserInfo.getUserId());
		userPermissions.setProject(team);
		userPermissions.setObjectType('Project');
		userPermissions.setPermissions();		
	}
	
	/**
	* Return user permissions
	*@return UserPermissions
	*/
	public UserPermissions getUserPermissions () {
		return userPermissions;
	}	
	
	/**
	* Rerender use only
	*/
	public void refreshMethod(){
		
	}

}