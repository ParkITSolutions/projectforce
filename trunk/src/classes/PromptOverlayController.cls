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
	
	/**
    * Test Prompt overlay component
    */
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
		
		PromptOverlayController prompt = new PromptOverlayController();
		prompt.includeNewTask 		= true;
		prompt.includeNewMilestone 	= true;
		prompt.includeAttachment 	= true;
		prompt.includeNewMember 	= true;
		prompt.includeNewAssignee 	= true;
		
    	Test.stopTest();
		ProjectUtil.setIsTest( false );    	
    }
}