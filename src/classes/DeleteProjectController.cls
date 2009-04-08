/**
*@author: Alvaro Scuccimarra @ 01-04-2009
*/
public class DeleteProjectController {
	
	private String projectId = System.currentPageReference().getParameters().get('id');

	//Getters and Setters
	public String getProjectId() {	
		return projectId;
	}
	
	public void setProjectId(String id) {	
		projectId = id;
	}
	
	/**
	* Delete Project
	*/
	public PageReference deleteProject(){

		PageReference pr = new PageReference( '/apex/projectOverview' );
		List<Project2__c> projectToDelete = new List<Project2__c>();		
		projectToDelete = [select Id from Project2__c where Id =: projectId];
		pr.setRedirect( true );
		if ( projectToDelete.size() > 0 ){
			delete projectToDelete[0];
		}
		return pr;
	}
}