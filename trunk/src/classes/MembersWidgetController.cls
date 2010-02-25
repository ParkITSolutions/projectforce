/** 
* @author Nicolas Dominguez 
* @dateCreated 08/02/2009
*/
public class MembersWidgetController {
	
	public UserPermissions userPermissions	 	{ set; get; }
	public String projectId   					{ set; get; }
	public Boolean isManager   					{ set; get; }
	public List<ProjectMember> projectMembers;
	
	/**
    * Empty Constructor
    */
	public MembersWidgetController(){
		this.userPermissions 	= new UserPermissions();
		genPermissions();
	}

	/**
	* generates permissions for an especific user
	*/
	public void genPermissions() {
		this.userPermissions.setId( UserInfo.getUserId() );
		this.userPermissions.setProject( this.projectId );
		this.userPermissions.setObjectType( 'Project' );
		this.userPermissions.setPermissions();
		this.isManager = userPermissions.getCanManage();
	}
	
	/**
	* reloadMemberList 
	* @refresh the projectMembers List
	*/
	public void reloadMemberList()
	{ 
		this.projectMembers = getProjectMembers();
	}
	
	/**
	* Get the project Members
	* @return listProjectMember
	*/
	public List<ProjectMember> getProjectMembers() {
		List<ProjectMember> listProjectMember = new List<ProjectMember>();

		for (ProjectMember__c projMember :	DAOFactory.getInstance().getMembersToWidget( projectId )){
			ProjectMember projAux = new ProjectMember();
			projAux.id 				= projMember.Id;
			projAux.name 			= projMember.Name;
			projAux.CreatedDate 	= projMember.CreatedDate;
			projAux.isAdmin 		= (projMember.Profile__r.Name == 'Project Administrator');
			
			listProjectMember.add(projAux);
		}
		return listProjectMember;
	}
}