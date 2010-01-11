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
	*/
	public ProjectActivity( String projectId, DateTime timeStamp, String modifiedBy, String action, String changeType, Project2__c oldProject, Project2__c newProject){
		
		super(projectId, timeStamp, modifiedBy, action, changeType);
		this.oldProject = oldProject;
		this.newProject = newProject;
	}
	
	/**
	* 
	*/
	public override void log(){
		
		if(this.oldProject.Name != this.newProject.Name){
			this.name 	= this.newProject.Name;
			//tipo de cambio
		}
		if(this.oldProject.Access__c != this.newProject.Access__c){
			this.access = this.newProject.Access__c;
			//tipo de cambio
		}
		
		DAOFactory.getInstance().logProjectActivity(this.projectId, this.timeStamp, this.modifiedBy, this.action ,this.name, this.access);
	}
}