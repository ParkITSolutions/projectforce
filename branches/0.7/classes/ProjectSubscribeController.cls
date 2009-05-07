/**
*@author Ignacio Toledo @ 03/24/2009
*/
public class ProjectSubscribeController {
	
	public String idProject = System.currentPageReference().getParameters().get('id');
	Integer subscriptionCount;

	/**
	* Constructor
	*/
	public ProjectSubscribeController () {
	}
	
	/**
	*@return Integer
	*/
	public Integer getSubscriptionCount () {
		return subscriptionCount;
	}
	
	/**
	*@param String
	*/
	public void setIdProject(String idProject) {
		this.idProject = idProject; 
	}
	
	/**
	*@return String
	*/
	public String getIdProject() {
		return idProject;
	}
}