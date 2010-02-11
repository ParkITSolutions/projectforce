/**
* @author Andres Canavesi
*/
public class PromptOverlayController {
	
	public boolean 	includeNewTask 			{ set; get; }
	public boolean 	includeNewMilestone		{ set; get; }
	public boolean 	includeAttachment		{ set; get; }
	public boolean 	includeNewMember 		{ set; get; }
	public boolean 	includeNewAssignee		{ set; get; }
	
	/**
	* Constructor
	*/
	public PromptOverlayController(){
		this.includeNewAssignee = false;
	}
}