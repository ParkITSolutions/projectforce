public class ProjectMembersWidgetController {

	private Project2__c project = new  Project2__c();
	private Boolean showWidget = false;
	private Id idProfile;
	private String IdAct = '';
	private Boolean already = false;

	public List<Project2__c> membersToInsert = new List<Project2__c>();
	public List<User> mailList = new List<User>();
	public Integer groupCount = 1;	
	public String projectName = null;
	public Member newMemberVars = new Member();
	public Boolean isAdministrator;
	//bool to send alert e-mail to added members
	public Boolean emailNotifications = false;
	//New save
	public Integer countSaved = 0;
	public Boolean reset = false;
	public List<Project2__c> memberListToolkit = new List<Project2__c>();
	public Integer memberListToolkitCount = 0;
    // Sharing rules
	public userPermissions userPermissionsI = new userPermissions();


	/**
	* Constructor
	*/
	public ProjectMembersWidgetController(){
		
		IdAct = system.currentPageReference().getParameters().get( 'id' );
		//genPermissions();
	}	

	

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
        *@param String names
        */
		public void setColleagueNames (String names) {
			this.colleagueNames = names;
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

}