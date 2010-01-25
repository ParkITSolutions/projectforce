/**
*@author Matias Menafra  1/20/2009
*/
public class ProjectActivityController {
	
	public String projectId 	{ set; get; }
	public Paginator paginator 	{ set; get; }
	
	/**
	* Constructor
	*/
	public ProjectActivityController(){
		
		this.projectId 				= System.currentPageReference().getParameters().get('id');
		this.paginator 				= new Paginator();
		this.paginator.project.id 	= this.projectId;
		
		paginator.loadProjectActivities();
	} 
}