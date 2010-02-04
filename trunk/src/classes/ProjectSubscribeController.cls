/**
*@author Matias Menafra 
*/
public class ProjectSubscribeController {
	
	public String idProject 			{ set; get; }
	public Integer subscriptionCount 	{ set; get; }

	/**
	* Constructor
	*/
	public ProjectSubscribeController () {
		
		this.idProject = System.currentPageReference().getParameters().get( 'id' );
	}
}