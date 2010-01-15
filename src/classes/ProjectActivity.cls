/**
* @author Matias Menafra 1/7/2010
*/
public class ProjectActivity extends ActivityLog{

	private String name;
	private String access;
	private Project2__c oldProject;
	private Project2__c newProject;
	
	/**
	* Constructor
	* @param String projectId
	* @param DateTime timeStamp
	* @param String modifiedBy
	* @param String action
	* @param Project2__c oldProject
	* @param Project2__c newProject
	*/
	public ProjectActivity( String projectId, DateTime timeStamp, String modifiedBy, String action, Project2__c oldProject, Project2__c newProject ){
		
		super( projectId, timeStamp, action );
		this.memberId 	= modifiedBy;
		this.oldProject = oldProject;
		this.newProject = newProject;
	}
	
	/**
	* Method which will take care of logging individual changes to Project Object
	* @return void
	*/
	public override void log(){
		
		ProjectMember__c member = DAOFactory.getInstance().getMemberByUserId( this.memberId );
		this.modifiedBy = member.Name;
		
		if( this.action == 'update' ){
			//Verifys change in Project Name
			if( this.oldProject.Name != this.newProject.Name ){
				this.name 		= this.newProject.Name;
				this.changeType = '';
				DAOFactory.getInstance().logProjectActivity( this.projectId, this.timeStamp, this.modifiedBy, this.action, this.changeType, this.name, '' );
			}
			
			//Verifys change in Project Access Level
			if( this.oldProject.Access__c != this.newProject.Access__c ){
				this.access 	= this.newProject.Access__c;
				this.changeType = '';
				DAOFactory.getInstance().logProjectActivity( this.projectId, this.timeStamp, this.modifiedBy, this.action, this.changeType, '', this.access );
			}
		}
		
	}
}