/**
*@author Ignacio Toledo
*@date 3/17/2008
*/

public without sharing class ProjectMembersListController {
	
	// Attributes \\
	
	public String idProject = System.currentPageReference().getParameters().get('id');
	public String removeMemberId = System.currentPageReference().getParameters().get('delId');
	public String delName;
	public String letter = System.currentPageReference().getParameters().get('ltr');
	public Boolean sortByDesc = false;
	public String sortBy = 'User__r.Name';
	
	// Set of Integers to control pagination
   	public Integer numberOfItemsToShow = 10;
   	public Integer cntPagination;
   	public Integer currentPagination = 1;
   	public Integer firstRow = 0;
   	public Integer totalItemsNumber= 0;
   	
   	// Set of Booleans to show or not prev / next links
   	public boolean prevPageLinkShow = false;
   	public boolean prevPageShow  = false;
   	public boolean nextPageLinkShow  = false;
   	public boolean nextPageShow  = false;
   	
   	public List<String> lettersList = new List<String>{'A','B','C','D','E','F','G','H','I','J',
   		'K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'};
   		
   	public List<Member> members = new List<Member>();
   	
   	public UserPermissions userPermissions = new UserPermissions();
   	
   	// Edit Members
	public String editMemberId = System.currentPageReference().getParameters().get('editId');
	public ProjectMember__c editMember;
	public String imgEditMember = '';
	public Boolean isLastAdmin = false;
	
	public String editMemberProfile;
	
	/**
	* Constructor
	*/
	public ProjectMembersListController () {
		genPermissions();
		genMembers();
	}
	
	/**
	* Return list of members
	*@return List<Member>
	*/
	public List<Member> getMembers () {
		return members;
	}	
	
	/**
	*@return Boolean
	*/
	public Boolean getSortByDesc () {
		return !sortByDesc;
	}
	
	/**
	*@return String
	*/
	public String getSortBy () {
		String sbCol = '';
		if (sortBy == null || sortBy == 'User__r.Name') 
			sbCol = 'name';	
		if (sortBy == 'User__r.CompanyName') 
			sbCol = 'company';	
		if (sortBy == 'User__r.Title') 
			sbCol = 'title';	
		if (sortBy == 'Profile__r.Name') 
			sbCol = 'profile';	
		return sbCol;
	}
	
	/**
	*@param s sort by field
	*/
	public void setSortBy (String s){
		sortBy = s;	
	}
	
	
	/**
	* Refresh member list
	*@void
	*/
	public void refresh() {
		genMembers();
	}
	
	/**
	* Generate user permissions
	*@void
	*/
	public void genPermissions() {
		userPermissions.setId(UserInfo.getUserId());
		userPermissions.setProject(idProject);
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
	*@return String Name
	*/	
	public String getProjectName () {
		Project2__c currentProject = [select Name from Project2__c where id=: idProject];
		return currentProject.Name;	 
	}
	
	/**
	*@return String ID
	*/	
	public String getProjectId () {
		return idProject;	
	}
	
	/**
	* Return number of admin(s) in the Project
	*@return Integer
	*/	
	public Integer getAdminCount () {
		Integer countAdmin = [select count() 
							  from ProjectMember__c 
							  where project__c = :idProject
							  	and Profile__r.ManageProjectTasks__c = true];
		return countAdmin;	
	}
	
	/**
	* Return user id from Project Member
	*@return String ID
	*/	
	public String getUserMemberId () {
		List<ProjectMember__c> userMember = new List<ProjectMember__c>();
		userMember = [select id 
					  from ProjectMember__c 
					  where project__c =:idProject 
					  	and User__c =:UserInfo.getUserId() limit 1];
		String userMemberId = '';
		if (userMember.size() > 0) {
			userMemberId = userMember[0].Id;	
		}
		return userMemberId;
	}
	
	/**
	* Return if show the Remove Message
	*@return Boolean
	*/	
	public Boolean getRemoveMessage () {
		String removeParam = System.currentPageReference().getParameters().get('remMsg');
		return (removeParam == 'true');
	}
	
	/**
	* Asign the Name of the user to remove
	*@void
	*/
	public void assignRemoveId () {
		if (System.currentPageReference().getParameters().get('delId') != null) {
			removeMemberId = System.currentPageReference().getParameters().get('delId');	
		}
		
		System.debug('REMOVE ID ->  ' + [select User__r.Name 
				   from ProjectMember__c 
				   where User__c =: removeMemberId 
				       and project__c =: idProject].User__r.Name);
				       
		delName = [select User__r.Name 
				   from ProjectMember__c 
				   where User__c =: removeMemberId 
				       and project__c =: idProject].User__r.Name;
	}
	
	/**
	* Return the Name of the user to remove
	*@return String
	*/
	public String getDelName () {
		return delName;
	}
	
	/**
	* Redirect after remove a member
	*@return PageReference
	*/
	public PageReference removeMember () {
		if (removeMemberId != UserInfo.getUserId()) {
			ProjectMember__c delMember = [select User__r.Name 
									   	  from ProjectMember__c 
										  where User__c =: removeMemberId 
										  	and project__c =: idProject];
			delete delMember;
		}
		PageReference pageRef = Page.ProjectMembersList;
		pageRef.getParameters().put('remMsg', 'true');
		pageRef.getParameters().put('id', idProject);
		pageRef.setRedirect(true);
		return pageRef;	
	}
	
	/**
	* Return if the user to delete is the last admin
	*@return Boolean
	*/
	public Boolean getIsLastAdmin () {
		return isLastAdmin;	
	}
	
	/**
	* Sets the id of the member to edit
	*@param s member id
	*/
	public void setEditMemberId (String s){
		editMemberId = s;	
	}
	
	/**
	* Stuff before edit
	*@void
	*/
	public void assignEditId () {
		if (System.currentPageReference().getParameters().get('editId') != null) {
			editMemberId = 	System.currentPageReference().getParameters().get('editId');
		}
		editMember = [select id, User__r.name, Profile__c, User__r.companyName, User__r.Title  
					  from ProjectMember__c 
					  where User__c =: editMemberId and project__c =: idProject];
		
		/*
		PeopleProfile__c img = [SELECT Picture__c from PeopleProfile__c WHERE User__c =: editMemberId LIMIT 1];
		if (img == null) {
			imgEditMember = '';
		}else {
			imgEditMember = img.Picture__c;
		}
		*/
		
		Integer countAdmin = [select count() 
							  from ProjectMember__c 
							  where project__c = :idProject];
							  
		Boolean isAdmin = [select Profile__r.ManageProjectTasks__c 
						   from ProjectMember__c 
						   where Project__c =:idProject
						       and User__c=:editMemberId].Profile__r.ManageProjectTasks__c;
		
		isLastAdmin = (editMemberId == UserInfo.getUserId()) && isAdmin;
		
		//editMemberRole = editmember.TeamRole__c;
		editMemberProfile = editMember.Profile__c;
	}
	
	/**
	* Return idProfile from edit member
	*@return String
	*/
	public String getEditMemberProfile () {
		return editMemberProfile;
	}
	
	/**
	* Set idProfile to edit member
	*@param String
	*/
	public void setEditMemberProfile (String profile) {
		this.editMemberProfile = profile;
	}
	
	/**
	*@return ProjectMember__c
	*/
	public ProjectMember__c getEditMember () {
		return editMember;
	}
	
	/**
	* Redirect after edit a member
	*@return PageReference
	*/
	public PageReference editMemberAction () {	
		editMember.Profile__c = editMemberProfile;
		update editMember;
		PageReference pageRef = Page.ProjectMembersList;
		pageRef.getParameters().put('id', idProject);
		pageRef.setRedirect(true);
		return pageRef;
	}
	
	/**
	*@return profiles select option list
	*/
	public List<SelectOption> getProfilesOptions () {
		List<SelectOption> options = new List<SelectOption>();
		for (ProjectProfile__c item: [select id, Name from ProjectProfile__c order by Name]) {
			options.add(new SelectOption(item.id,item.Name));
		}
		return options;
	}
	
	/**
	*@return profile list option filter
	*/
	public List<SelectOption> getProfilesOptionsFilter () {
		List<SelectOption> options = new List<SelectOption>();
		for (ProjectProfile__c item: [select id, Name from ProjectProfile__c where ManageProjectTasks__c = true order by Name]) {
			options.add(new SelectOption(item.id,item.Name));
		}
		return options;
	}
	
	/**
	* Return all Profiles
	*@return List<ProjectProfile__c>
	*/
	public List<ProjectProfile__c> getProjectEditProfiles () {
		return [select Name, id from ProjectProfile__c order by Name];
	}

	
	/**
	* Set letter value
	*@param String
	*/
	public void setLetter(String s){
		letter = s;	
	}
	
	/**
	* Search members
	*@void
	*/
	public void genMembers() {
		List<Member> membersList = new List<Member>();
		
		sortByDesc = false;
		sortBy = 'User__r.Name';
		
		if(System.currentPageReference().getParameters().get('ltr') != null)
			letter = System.currentPageReference().getParameters().get('ltr');
				
		if (letter == null || letter == '' || letter == 'ALL') {
			for (ProjectMember__c item: 
				[select id, Name, Profile__r.Name, Profile__r.ManageProjectTasks__c, 
					Profile__r.Description__c, User__r.Name, User__r.Title, User__r.Id, User__r.CompanyName 
				 from ProjectMember__c 
				 where project__c =:idProject and User__r.IsActive != false 
				 order by User__r.Name]) {
				 	
				Member memberItem = new Member();
				memberItem.setName(item.User__r.Name);
				memberItem.setProfile(item.Profile__r.Name);
				memberItem.setTitle(item.User__r.Title);
				memberItem.setUserId(item.User__r.Id);
				memberItem.setProjectMemberId(item.id);
				memberItem.setMemberImg(item.User__r.Id);
				memberItem.setAdmin(item.Profile__r.ManageProjectTasks__c);
				memberItem.setCompany(item.User__r.CompanyName);
				membersList.add(memberItem);
			}
		}else {
			for (ProjectMember__c item: 
				[select id, Name, Profile__r.Name, Profile__r.ManageProjectTasks__c, 
				Profile__r.Description__c, User__r.Name, User__r.Title, User__r.Id, User__r.CompanyName 
				from ProjectMember__c 
				where User__r.Name like :('%' + letter + '%') and User__r.IsActive != false 
					and project__c =:idProject
				order by User__r.Name]) {
					
				Member memberItem = new Member();
				memberItem.setName(item.User__r.Name);
				memberItem.setProfile(item.Profile__r.Name);
				memberItem.setTitle(item.User__r.Title);
				memberItem.setUserId(item.User__r.Id);
				memberItem.setProjectMemberId(item.id);	
				memberItem.setMemberImg(item.User__r.Id);
				memberItem.setAdmin(item.Profile__r.ManageProjectTasks__c);
				memberItem.setCompany(item.User__r.CompanyName);
				membersList.add(memberItem);
			}
		}	
		totalItemsNumber = membersList.size();
		if (totalItemsNumber == 0 ) {
			cntPagination = 0;	
			firstRow = 0;
			currentPagination = 1;
		}else {
			firstRow = 0;
			currentPagination = 1;
			genCntPagination();	
		}
		members = membersList;
		
	}
	
	
	/**
	* Inner class for Member class
	*@class
	*/
	public class Member {
		String memberImg;
		String company;
		String title;
		String profile;
		String role;
		String name;
		String userId;
		String projectMemberId;
		Boolean admin;
		String yahoo;
		String skype;
		
		/**
		*@return String
		*/
		public String getYahoo () {
			return yahoo;
		}
		
		/**
		*@return String
		*/
		public String getSkype () {
			return skype;	
		}
		
		/**
		*@return String ID
		*/
		public String getUserId (){
			return userId;
		}
		
		/**
		*@return String ID
		*/
		public String getProjectMemberId (){
			return projectMemberId;
		}
		
		/**
		*@param String ID
		*/
		public void setProjectMemberId (String projectMemberId){
			this.projectMemberId = projectMemberId;
		}
		
		/**
		*@return String
		*/
		public String getName () {
			return name;
		}
		
		/**
		*@return String
		*/
		public String getMemberImg () {
			return memberImg;
		}
		
		/**
		*@return String
		*/
		public String getCompany () {
			return company;
		}
		
		/**
		*@return String
		*/
		public String getTitle () {
			return title;
		}
		
		/**
		*@return String
		*/
		public String getProfile () {
			return profile;
		}
		
		/**
		*@return String
		*/
		public String getRole () {
			return role;
		}
		
		/**
		*@param String ID
		*/
		public void setUserId (String userId) {
			this.userId = userId;
		}
		
		/**
		*@param String company
		*/
		public void setCompany (String company) {
			this.company = company;
		}
		
		/**
		*@param String name
		*/
		public void setName (String name) {
			this.name = name;
		}
		
		/**
		*@param String idMember
		*/
		public void setMemberImg (String memberId) {
			/*
			List<ProjectProfile__c> imgs = new List<ProjectProfile__c>();
			try {
				imgs = [SELECT Id, YahooIM__c, Skype__c, Picture__c from ProjectProfile__c WHERE User__c =: memberId LIMIT 1];
			} catch(Exception e){
				throw e;
			}
			ProjectProfile__c img = new ProjectProfile__c();
			if(imgs.size() > 0){
				img = imgs[0];
			} 
			
			if (img == null) {
				this.memberImg = '';
				this.yahoo = '';
				this.skype = '';
			}else {
				this.memberImg = img.Picture__c;
				if(img.YahooIM__c != null){
	            	this.yahoo = img.YahooIM__c;
	            }else {
	            	this.yahoo = '';
	            }
	            if(img.Skype__c != null){
	            	this.skype = img.Skype__c;
	            }else {
	            	this.skype = '';
	            }
			}*/
		}
		
		/**
		*@param String
		*/
		public void setProfile (String profile) {
			this.profile = profile;
		}
		
		/**
		*@param String
		*/
		public void setRole (String role) {
			this.role = role;
		}
		
		/**
		*@param String
		*/
		public void setTitle (String title) {
			this.title = title;
		}
		
		/**
		*@param Boolean
		*/
		public void setAdmin (Boolean admin) {
			this.admin = admin;	
		}
		
		/**
		*@return Boolean
		*/
		public Boolean getAdmin () {
			return admin;
		}
	}
	
	
	
	/** Pagination */
	
	/**
   	* Count number of result pages
   	*@void
   	*/
   	public void genCntPagination () {
   		cntPagination = (totalItemsNumber - (Math.mod(totalItemsNumber, numberOfItemsToShow)))/ numberOfItemsToShow;	
   		if (Math.mod(totalItemsNumber, numberOfItemsToShow) != 0 ) {
   			cntPagination++;
   		} 	
   	}
   	
   	/**
   	* Go next result page
   	*/
   	public void nextPage () {
   		currentPagination++;
   		firstRow = firstRow + numberOfItemsToShow;   		
   	}
   	
   	/**
   	* Go previus result page
   	*/
   	public void prevPage () {
   		currentPagination--;
   		firstRow = firstRow - numberOfItemsToShow;	
   	}
   	
   	/**
	*@return Integer
	*/
	public Integer getTotalItemsNumber () {
		return totalItemsNumber;
	}
	
   	/**
   	* Pagination Integer Getters
   	*@return Integer
   	*/
   	public Integer getFirstItem () {
		return (firstRow + 1);
	}
	
	/**
	* Assign a number to the last page's result
	*@return Integer
	*/
	public Integer getLastItem () {
		Integer lastItem;
		if ((currentPagination == cntPagination) || (currentPagination == 1 && (totalItemsNumber < numberOfItemsToShow))) {
			lastItem = firstRow + Math.mod(totalItemsNumber, numberOfItemsToShow);
		}else {
			lastItem = firstRow + 10;
		}
		return lastItem;
	}
   	
   	/**
   	* Return current page number
   	*@return Integer
   	*/
   	public Integer getCurrentPagination () {
   		return currentPagination;
   	}
   	
   	/**
   	* Return number of result pages
   	*@return Integer
   	*/
   	public Integer getCntPagination () {
   		return cntPagination;
   	}
   	
   	/**
   	* Return number of results
   	*@return Integer
   	*/
   	public Integer getNumberOfItemsToShow () {
   		return numberOfItemsToShow;
   	}
   	
   	/**
   	* Return the number of the first item of page
   	*@return Integer
   	*/
   	public Integer getFirstRow () {
   		return firstRow;
   	}
   	
   	/**
   	* Return if show Prev Link
   	*@return boolean
   	*/
	public boolean getPrevPageLinkShow () {
		return currentPagination != 1;
   	}
   	
   	/**
   	* Return if show Prev Link
   	*@return boolean
   	*/
   	public boolean getPrevPageShow () {
   		return currentPagination == 1;
   	}
   	
   	/**
   	* Return if show Next Link
   	*@return boolean
   	*/
   	public boolean getNextPageLinkShow () {
   		return !(currentPagination == cntPagination) || (cntPagination == 0);
   	}
   	
   	/**
   	* Return if show Next Link
   	*@return boolean
   	*/
   	public boolean getNextPageShow () {
   		return (currentPagination == cntPagination) || (cntPagination == 0);
   	}
   	
   	/**
	* Inner class for Letters type
	*
	*/
	public class Letters {
		String letter;
		Boolean containMembers;
		
		/**
		*@param String
		*/
		public void setLetter (String letter) {
			this.letter = letter;
		}
		
		/**
		*@return String
		*/
		public String getLetter () {
			return letter;
		}
		
		/**
		*@param Integer
		*/
		public void setContainMembers (Integer cntMembers) {
			this.containMembers = cntMembers == 0;
		}
		
		/**
		*@return Boolean
		*/
		public Boolean getContainMembers () {
			return containMembers;
		}
		
		
	} //End class Letters
	
	/**
	* Return list with letters and if contain Project members
	*@return List<Letters>
	*/
	public List<Letters> getLetterFilter () {
		List<Letters> letterFilter = new List<Letters>();
   		for (String item : lettersList) {
   			Letters currentLetter = new Letters();
   			Integer cntMembers = [select count() 
					   			  from ProjectMember__c 
					   			  where User__r.Name like :(item + '%') and project__c =:idProject];
   			currentLetter.setLetter(item);
   			currentLetter.setContainMembers(cntMembers);
   			letterFilter.add(currentLetter);
   		}
   		return letterFilter;		
	}
	
	/**
	* Return the Namespace Prefix
	*@return String
	*/
	public String getNamespace () {
        return ProjectUtil.getNamespace();
    } 
    
    /**
	*@param String idProject
	*/
	public void setIdProject(String proj){
		idProject = proj;
	}
	
	/**
	* Set memberId to remove
	*@param String memberId
	*/
	public void setRemoveMemberId (String memberId){
		removeMemberId = memberId; 
	}
	
	/*
	 * This is a temporary method to cover us until dynamic apex is back.  This will use hard coded
	 * SOQL statements in place of the dynamic statements
	 */
	public void sortList () {
		List<Member> membersList = new List<Member>();
		if (sortBy == System.currentPageReference().getParameters().get('sb')) {
			sortByDesc = !sortByDesc;
		}else {
			sortByDesc = false;
		}
		
		//Sort param
		if(System.currentPageReference().getParameters().get('sb') != null)
			sortBy = System.currentPageReference().getParameters().get('sb');
		
		List<ProjectMember__c> memberResultList = new List<ProjectMember__c>();

		if (sortByDesc) {
			if (letter == null || letter == '' || letter== 'ALL') {
				if (sortBy == 'User__r.Name') {
					memberResultList = [select id, 
											   Name, 
											   Profile__r.Name, 
											   Profile__r.Description__c, 
											   User__r.Name, 
											   User__r.Title, 
											   User__r.Id, 
											   User__r.CompanyName 
										from ProjectMember__c 
										where project__c =: idProject and User__r.IsActive != false
										order by User__r.Name desc];
				}
				if (sortBy == 'User__r.CompanyName') {
					memberResultList = [select id, 
											   Name, 
											   Profile__r.Name, 
											   Profile__r.Description__c, 
											   User__r.Name, 
											   User__r.Title, 
											   User__r.Id, 
											   User__r.CompanyName 
										from ProjectMember__c 
										where project__c =: idProject and User__r.IsActive != false
										order by User__r.CompanyName desc];						
				}	
				if (sortBy == 'User__r.Title') {
					memberResultList = [select id, 
											   Name, 											   
											   Profile__r.Name, 
											   Profile__r.Description__c, 
											   User__r.Name, 
											   User__r.Title, 
											   User__r.Id, 
											   User__r.CompanyName 
										from ProjectMember__c 
										where project__c =: idProject and User__r.IsActive != false
										order by User__r.Title desc];							
				}
				if (sortBy == 'Profile__r.Name') {
					memberResultList = [select id, 
											   Name, 											   
											   Profile__r.Name, 
											   Profile__r.Description__c, 
											   User__r.Name, 
											   User__r.Title, 
											   User__r.Id, 
											   User__r.CompanyName 
										from ProjectMember__c 
										where project__c =: idProject and User__r.IsActive != false
										order by Profile__r.Name desc];						
				}		
			}else {
				if (sortBy == 'User__r.Name') {
					memberResultList = [select id, 
											   Name, 											   
											   Profile__r.Name, 
											   Profile__r.Description__c, 
											   User__r.Name, 
											   User__r.Title, 
											   User__r.Id, 
											   User__r.CompanyName 
										from ProjectMember__c 
										where User__r.Name like: (letter + '%') 
										and project__c =: idProject and User__r.IsActive != false
										order by User__r.Name desc];					
				}
				if (sortBy == 'User__r.CompanyName') {
					memberResultList = [select id, 
											   Name,											   
											   Profile__r.Name, 
											   Profile__r.Description__c, 
											   User__r.Name, 
											   User__r.Title, 
											   User__r.Id, 
											   User__r.CompanyName 
										from ProjectMember__c 
										where User__r.Name like: (letter + '%') 
										and project__c =: idProject and User__r.IsActive != false
										order by User__r.CompanyName desc];							
				}	
				if (sortBy == 'User__r.Title') {
					memberResultList = [select id, 
											   Name, 
											   Profile__r.Name, 
											   Profile__r.Description__c, 
											   User__r.Name, 
											   User__r.Title, 
											   User__r.Id, 
											   User__r.CompanyName 
										from ProjectMember__c 
										where User__r.Name like: (letter + '%') 
										and project__c =: idProject and User__r.IsActive != false
										order by User__r.Title desc];							
				}
				if (sortBy == 'Profile__r.Name') {
					memberResultList = [select id, 
											   Name, 
											   Profile__r.Name, 
											   Profile__r.Description__c, 
											   User__r.Name, 
											   User__r.Title, 
											   User__r.Id, 
											   User__r.CompanyName 
										from ProjectMember__c 
										where User__r.Name like: (letter + '%') 
										and project__c =: idProject and User__r.IsActive != false
										order by Profile__r.Name desc];						
				}
			}
		}else {
			if (letter == null || letter == '' || letter== 'ALL') {
				if (sortBy == 'User__r.Name') {
					memberResultList = [select id, 
											   Name, 
									
											   Profile__r.Name, 
											   Profile__r.Description__c, 
											   User__r.Name, 
											   User__r.Title, 
											   User__r.Id, 
											   User__r.CompanyName 
										from ProjectMember__c 
										where project__c =: idProject and User__r.IsActive != false
										order by User__r.Name];
				}
				if (sortBy == 'User__r.CompanyName') {
					memberResultList = [select id, 
											   Name, 
											   Profile__r.Name, 
											   Profile__r.Description__c, 
											   User__r.Name, 
											   User__r.Title, 
											   User__r.Id, 
											   User__r.CompanyName 
										from ProjectMember__c 
										where project__c =: idProject and User__r.IsActive != false
										order by User__r.CompanyName asc];						
				}	
				if (sortBy == 'User__r.Title') {
					memberResultList = [select id, 
											   Name, 
											   Profile__r.Name, 
											   Profile__r.Description__c, 
											   User__r.Name, 
											   User__r.Title, 
											   User__r.Id, 
											   User__r.CompanyName 
										from ProjectMember__c 
										where project__c =: idProject and User__r.IsActive != false
										order by User__r.Title];							
				}
				if (sortBy == 'Profile__r.Name') {
					memberResultList = [select id, 
											   Name, 
											   Profile__r.Name, 
											   Profile__r.Description__c, 
											   User__r.Name, 
											   User__r.Title, 
											   User__r.Id, 
											   User__r.CompanyName 
										from ProjectMember__c 
										where project__c =: idProject and User__r.IsActive != false
										order by Profile__r.Name];						
				}
			}else {
				if (sortBy == 'User__r.Name') {
					memberResultList = [select id, 
											   Name,    
											   Profile__r.Name, 
											   Profile__r.Description__c, 
											   User__r.Name, 
											   User__r.Title, 
											   User__r.Id, 
											   User__r.CompanyName 
										from ProjectMember__c 
										where User__r.Name like: (letter + '%') 
										and project__c =: idProject and User__r.IsActive != false
										order by User__r.Name];					
				}
				if (sortBy == 'User__r.CompanyName') {
					memberResultList = [select id, 
											   Name, 
											   Profile__r.Name, 
											   Profile__r.Description__c, 
											   User__r.Name, 
											   User__r.Title, 
											   User__r.Id, 
											   User__r.CompanyName 
										from ProjectMember__c 
										where User__r.Name like: (letter + '%') 
										and project__c =: idProject and User__r.IsActive != false
										order by User__r.CompanyName];							
				}	
				if (sortBy == 'User__r.Title') {
					memberResultList = [select id, 
											   Name, 
											   Profile__r.Name, 
											   Profile__r.Description__c, 
											   User__r.Name, 
											   User__r.Title, 
											   User__r.Id, 
											   User__r.CompanyName 
										from ProjectMember__c 
										where User__r.Name like: (letter + '%') 
										and project__c =: idProject and User__r.IsActive != false
										order by User__r.Title];							
				}
				if (sortBy == 'Profile__r.Name') {
					memberResultList = [select id, 
											   Name, 
											   Profile__r.Name, 
											   Profile__r.Description__c, 
											   User__r.Name, 
											   User__r.Title, 
											   User__r.Id, 
											   User__r.CompanyName 
										from ProjectMember__c 
										where User__r.Name like: (letter + '%') 
										and project__c =: idProject and User__r.IsActive != false
										order by Profile__r.Name];						
				}
			}			
		}
				 
		for (ProjectMember__c item: memberResultList) {
			Member memberItem = new Member();
			memberItem.setName(item.User__r.Name);
			memberItem.setProfile(item.Profile__r.Name);
			memberItem.setTitle(item.User__r.Title);
			memberItem.setUserId(item.User__r.Id);	
			memberItem.setMemberImg(item.User__r.Id);
			memberItem.setCompany(item.User__r.CompanyName);
			membersList.add(memberItem);
		}
			
		totalItemsNumber = membersList.size();
		if (totalItemsNumber == 0 ) {
			cntPagination = 0;	
			firstRow = 0;
			currentPagination = 1;
		}else {
			firstRow = 0;
			currentPagination = 1;
			genCntPagination();	
		}
		members = membersList;	
	}
	
	
}