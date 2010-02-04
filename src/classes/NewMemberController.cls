/*
*@author Nicolas Dominguez @ 03/02/2010
*/
public class NewMemberController {

	public Boolean emailNotifications 		{ set; get; }
	public Boolean isAdministrator 			{ set; get; }
	public Member newMemberVars 			{ set; get; }
	public String idProject   				{ set; get; }
	public String projectName				{ set; get; }
	public UserPermissions userPermission 	{ set; get; }
	
	
	public NewMemberController(){
		newMemberVars 	= new Member();
		this.userPermission = new UserPermissions();
		this.idProject 	= System.currentPageReference().getParameters().get( 'id' );

		this.loadProjectName();
		this.genPermissions();
	}
	
	public void action(){
	}
	
			
	/**
	* Return the Namespace Prefix
	*@return String
	*/
	public String getNamespace () {
        return ProjectUtil.getNamespace();
    } 
	/**
	* Load Project Name
	*@return String team name
	*/
	public void loadProjectName () {
		if(projectName == null)
			this.projectName = [select Name from Project2__c where id =: idProject].Name;

	}
	
	/**
    * Load permission for current user
    */
 	private void genPermissions(){
 		
        userPermission.setId(UserInfo.getUserId());
        userPermission.setProject(idProject);
        userPermission.setObjectType('Project');
        userPermission.setPermissions();
    }
	
	
	
	//////////////////////////////
	public class Member {	
		public String profileId			{ set; get; }
		//public String message			{ set; get; }
		//public String teamRole		{ set; get; }
		public String colleagueNames	{ set; get; }
		
	}
	//////////////////////////////
}