/**
*@author Ignacio Toledo @ 3/17/2008
*/
public without sharing class ProjectMembersListController {
	
	public String idProject = System.currentPageReference().getParameters().get('id');
	public String removeMemberId = System.currentPageReference().getParameters().get('delId');
	
	public String   massiveRemoveMemIds;
	public List<Id> massiveRemoveMemIds2 = new List<Id>();
	public Boolean  deletingAllAmdsErr = false;
 	List<ProjectMember__c> idsToDel = new List<ProjectMember__c>();
 	
	public String delName;
	public String letter = System.currentPageReference().getParameters().get('ltr');
	public Boolean sortByDesc = false;
	public String sortBy = 'User__r.Name';
	public Boolean error = false;
	public Boolean finish = false;
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
		    	TaskDependencies pb = new TaskDependencies();
		
		genPermissions();
		genMembers();
	}
	
	/**
	*
	*@param String s
	*@return void
	*/
	public void setMassiveRemoveMemIds( String s ){
  		 this.MassiveRemoveMemIds = s;
		 this.massiveRemoveMemIds2 = MassiveRemoveMemIds.split( '::' );
		 
	}
	
	/**
	*
	*@return void
	*/
	public Boolean getDeletingAllAmdsErr(){
		return deletingAllAmdsErr;
	}
	
	/**
	*
	*@return String
	*/
	public String getMassiveRemoveMemIds(){
 		String po;
		for( Id i : this.massiveRemoveMemIds2 )
		po += i + '::';
		
		return po;
 	}
	
	/**
	* Delete members
	*@return void
	*/ 
	public void massiveRemove(){
 		 if( this.massiveRemoveMemIds2.size() > 0 ) {
			this.idsToDel = [ select Id, Profile__r.Name 
								from ProjectMember__c 
								where Id in: massiveRemoveMemIds2 ];
								
 			this.deletingAllAmdsErr = this.noMoreAdmins();
			if( !this.deletingAllAmdsErr )
			delete this.idsToDel;
		 } 
 	}
	
	/**
	*
	*@return Boolean
	*/
	public Boolean noMoreAdmins(){
		
		Boolean noMore = false;
		List<ProjectMember__c> adminMembersList = new List<ProjectMember__c>();      
		List<Id> adminMembersListIds = new List<Id>();      
		List<Id> adminMembersListIdsToDel = new List<Id>();      

		adminMembersList = [ select Id 
								from ProjectMember__c 
								where Profile__r.Name = 'Project Administrator' and Project__c =: idProject ];
		if( adminMembersList.size() > 0 )
			for( ProjectMember__c a : adminMembersList )
			adminMembersListIds.add( a.Id );
					
		if( this.idsToDel.size() > 0 )
			for( ProjectMember__c a : this.idsToDel )
				if( a.Profile__r.Name == 'Project Administrator' )
				adminMembersListIdsToDel.add( a.Id );
		
		noMore = ( adminMembersListIds.size() == adminMembersListIdsToDel.size());
   		return noMore;
	}	
	
	/**
	* Return list of members
	*@return List<Member>
	*/
	public List<Member> getMembers(){
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
	* sort by field
	*@param String s 
	*@return void
	*/
	public void setSortBy (String s){
		sortBy = s;	
	}
	
	/**
	* Returns error
	*@return boolean error
	*/
	public Boolean getError(){
		return error;	
	}
	
	/**
	*@param Boolean e
	*return void
	*/
	public void setError(Boolean e){
		error = e;
	}
	
	/**
	* Return error
	*@return boolean
	*/
	public Boolean getFinish(){
		return finish;	
	}
	
	/**
	*@param Boolean f
	*@return void
	*/
	public void setFinish(Boolean f){
		finish = f;
	}
	
	/**
	*@return void
	*/
	public void resetErrorAndFinish(){
		error = false;	
		finish = false;
	}
	
	/**
	* Return user permissions
	*@return UserPermissions
	*/
	public UserPermissions getUserPermissions () {
		genPermissions();
		return userPermissions;
	}	
	
	/**
	* Return if the user to delete is the last admin
	*@return Boolean
	*/
	public Boolean getIsLastAdmin () {
		return isLastAdmin;	
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
	*@param String profile
	*@return void
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
	* Sets the id of the member to edit
	*@param String s member id
	*@return void
	*/
	public void setEditMemberId (String s){
		editMemberId = s;	
	}
		
	/**
	*@return String Name
	*/	
	public String getProjectName () {
		Project2__c currentProject = [select Name from Project2__c where id=: idProject];
		String pName = currentProject.Name;

		if( pName.length() > 24 )
		pName = pName.substring( 0, 23 );
		return pName;	 
		
	}
	
	/**
	*@return String ID
	*/	
	public String getProjectId () {
		return idProject;	
	}
	
	/**
	*@param String idProject
	*@return void
	*/	
	public void setProjectId(String idProject){
		this.idProject = idProject;	
	}
	
	/**
	* Return number of admin(s) in the Project
	*@return Integer
	*/	
	public Integer getAdminCount () {
		Integer countAdmin = [select count() 
								from ProjectMember__c 
								where project__c = :idProject and Profile__r.ManageProjectTasks__c = true];
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
						where project__c =:idProject and User__c =:UserInfo.getUserId() 
						limit 1];
						
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
	*@return void
	*/
	public void assignRemoveId () {
		if (System.currentPageReference().getParameters().get('delId') != null) {
			removeMemberId = System.currentPageReference().getParameters().get('delId');	
		}		       
		delName = [select User__r.Name 
					from ProjectMember__c 
					where User__c =: removeMemberId and project__c =: idProject 
					limit 1].User__r.Name; 
	}
	
	/**
	* Return the Name of the user to remove
	*@return String
	*/
	public String getDelName () {
		return delName;
	}
		
	/**
	* Join Project
	*@return void
	*/
	public void joinProject(){
		ProjectMember__c projectMember = new ProjectMember__c();
		projectMember.User__c = UserInfo.getUserId();
		projectMember.Profile__c = [select Id 
										from ProjectProfile__c 
										where Name = 'Member Profile' 
										limit 1].Id;
										
		projectMember.Project__c = this.getProjectId();
		insert projectMember;
	}
	
	
	/**
	* Unjoin Project
	*@return void
	*/
	public void unjoinProject(){
		List<ProjectMember__c> member = [select Id, User__c 
											from ProjectMember__c 
											where User__c =: UserInfo.getUserId() and Project__c =: this.getProjectId()];
		if(member.size() > 0){
			delete member[0];
		}
	}
	
	/**
	* Refresh member list
	*@return void
	*/
	public void refresh() {
 		genPermissions();
		genMembers();
	}
	
	/**
	* Generate user permissions
	*@return void
	*/
	public void genPermissions() {
		userPermissions.setId(UserInfo.getUserId());
		userPermissions.setProject(idProject);
		userPermissions.setObjectType('Project');
		userPermissions.setPermissions();		
	}
	
	/**
	* Redirect after remove a member
	*@return void
	*/
	public void removeMember () {
		error = false;
		finish = false;
 		List<ProjectMember__c> delMember = new List<ProjectMember__c>();
		delMember = [select User__r.Name  
						from ProjectMember__c 
						where Id =: removeMemberId and project__c =: idProject];
									  	
		List<ProjectMember__c> admins = new List<ProjectMember__c>(); 
		admins = [Select p.Id 
					From ProjectMember__c p 
					where p.Profile__r.Name = 'Project Administrator' and p.Project__c =: idProject and Id !=: removeMemberId];
	
		if (admins.size() >0){
			error = false;
			finish = true;
			delete delMember;	
		}else{
			error = true;
			finish = false;	
		}
		
		genPermissions(); 
	}
	

	/**
	* Stuff before edit
	*@return void
	*/
	public void assignEditId () {
		if (System.currentPageReference().getParameters().get('editId') != null) {
			editMemberId = 	System.currentPageReference().getParameters().get('editId');
		}
		editMember = [select id, User__r.name, Profile__c, User__r.companyName, User__r.Title  
						from ProjectMember__c  
						where User__c =: editMemberId and project__c =: idProject 
						limit 1];
		
		Integer countAdmin = [select count()  
								from ProjectMember__c 
								where project__c = :idProject];
							  
		Boolean isAdmin = [select Profile__r.ManageProjectTasks__c 
							from ProjectMember__c 
							where Project__c =:idProject and User__c=:editMemberId 
							limit 1 ].Profile__r.ManageProjectTasks__c;
		
		isLastAdmin = (editMemberId == UserInfo.getUserId()) && isAdmin;
		
		editMemberProfile = editMember.Profile__c;
	}

	/**
	* 
	*@return boolean
	*/
	public Boolean isLastMemberAdmin (){
		List<ProjectMember__c> members = new List<ProjectMember__c>();
		members = [Select d.Name, User__c 
					From ProjectMember__c d 
					where Profile__r.Name = 'Project Administrator' and Project__c =: idProject];
					
		if(members.size() == 1 && members[0].User__c == UserInfo.getUserId())
			return true;
		else
			return false;		
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
	*@return List<SelectOption> profiles select option list
	*/
	public List<SelectOption> getProfilesOptions () {
		List<SelectOption> options = new List<SelectOption>();
		for (ProjectProfile__c item: [select id, Name from ProjectProfile__c order by Name]) {
			options.add(new SelectOption(item.id,item.Name));
		}
		return options;
	}
	
	/**
	*@return List<SelectOption> profile list option filter
	*/
	public List<SelectOption> getProfilesOptionsFilter () {
		List<SelectOption> options = new List<SelectOption>();
		for (ProjectProfile__c item: [select id, Name 
										from ProjectProfile__c 
										where ManageProjectTasks__c = true 
										order by Name]) {
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
	* Sets letter value
	*@param String s
	*return void
	*/
	public void setLetter(String s){
		letter = s;	
	}
	
	/**
	* Search members
	*@return void
	*/
	public void genMembers() {
		List<Member> membersList = new List<Member>();
		
		sortByDesc = false;
		sortBy = 'User__r.Name';
		
		if(System.currentPageReference().getParameters().get('ltr') != null)
			letter = System.currentPageReference().getParameters().get('ltr');
				
		if (letter == null || letter == '' || letter == 'ALL') {
			for (ProjectMember__c item: [select id, Name, Profile__r.Name, Profile__r.ManageProjectTasks__c,
			 								Profile__r.Description__c, User__r.Name, User__r.Title, 
			 								User__r.Id, User__r.CompanyName 
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
			for (ProjectMember__c item: [select id, Name, Profile__r.Name, Profile__r.ManageProjectTasks__c, 
											Profile__r.Description__c, User__r.Name, User__r.Title, User__r.Id, 
											User__r.CompanyName 
											from ProjectMember__c 
											where User__r.Name like :(letter + '%') and User__r.IsActive != false and project__c =:idProject 
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
	
	/** Pagination */
	
	/**
   	* Count number of result pages
   	*@return void
   	*/
   	public void genCntPagination () {
   		cntPagination = (totalItemsNumber - (Math.mod(totalItemsNumber, numberOfItemsToShow)))/ numberOfItemsToShow;	
   		if (Math.mod(totalItemsNumber, numberOfItemsToShow) != 0 ) {
   			cntPagination++;
   		} 	
   	}
   	
   	/**
   	* Go next result page
   	*@return void
   	*/
   	public void nextPage () {
   		currentPagination++;
   		firstRow = firstRow + numberOfItemsToShow;   		
   	}
   	
   	/**
   	* Go previus result page
   	*return void
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
		if ((currentPagination == cntPagination) || (currentPagination == 1 
			&& (totalItemsNumber < numberOfItemsToShow))) {
				
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
	*@param String proj
	*@return void
	*/
	public void setIdProject(String proj){
		idProject = proj;
	}
	
	/**
	* Set memberId to remove
	*@param String memberId
	*@return void
	*/
	public void setRemoveMemberId (String memberId){
		removeMemberId = memberId; 
	}
	
	/**
	* 
	*@return string
	*/
	public String getRemoveMemberId(){
		return removeMemberId;	
	}
	
	/*
	 * This is a temporary method to cover us until dynamic apex is back.  This will use hard coded
	 * SOQL statements in place of the dynamic statements
	 *@return void
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

		String dQuery;
		dQuery = 'SELECT Id, Profile__r.Name,Profile__r.Description__c, User__r.Name, User__r.Title,User__r.Id, User__r.CompanyName ' +
		' from ProjectMember__c ' + 
		' where ' + ((letter == null || letter == '' || letter== 'ALL') ? '' : ' User__r.Name like \'' + letter + '%\' and ' ) + ' project__c = \'' + idProject + '\'  and User__r.IsActive != false order by ' + sortBy + ((sortBydesc) ? ' desc ' : ' asc');
		memberResultList = Database.query( dQuery );
				 
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
	
	/**
	* 
	*@return boolean
	*/
	public static boolean getCanManageStatic(){
		return UserPermissions.getCanManageStatic();	
	}
	
	
   	
   	/**
	* Inner Class for Letters type
	*@class
	*/
	public class Letters {
		
		String letter;
		Boolean containMembers = false;
		
		/**
		*@param String letter
		*@return void
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
		*@param Integer cntMembers
		*@return void
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
	} 

		
	/**
	* Inner Class for Member class
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
		*@return String 
		*/
		public String getUserId (){
			return userId;
		}
		
		/**
		*@return String 
		*/
		public String getProjectMemberId (){
			return projectMemberId;
		}
		
		/**
		*@param String projectMemberId
		*@return void
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
		*@param String userId
		*@return void
		*/
		public void setUserId (String userId) {
			this.userId = userId;
		}
		
		/**
		*@param String company
		*@return void
		*/
		public void setCompany (String company) {
			this.company = company;
		}
		
		/**
		*@param String name
		*@return void
		*/
		public void setName (String name) {
			this.name = name;
		}
		
		/**
		*@param String memberId
		*@return void
		*/
		public void setMemberImg (String memberId) {
			
		}
		
		/**
		*@param String profile
		*@return void
		*/
		public void setProfile (String profile) {
			this.profile = profile;
		}
		
		/**
		*@param String role
		*@return void
		*/
		public void setRole (String role) {
			this.role = role;
		}
		
		/**
		*@param String title
		*@return void
		*/
		public void setTitle (String title) {
			this.title = title;
		}
		
		/**
		*@param Boolean admin
		*@return void
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
}