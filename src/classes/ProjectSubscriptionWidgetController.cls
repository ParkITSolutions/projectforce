/**
*@author Matias Menafra  
*/
public class ProjectSubscriptionWidgetController {
	
	public String idProject { set; get; } 
	
	/**
	* Constructor
	*/
	public ProjectSubscriptionWidgetController(){
		
		this.idProject = System.currentPageReference().getParameters().get( 'id' );
	}
}