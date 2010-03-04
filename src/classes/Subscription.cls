/**
* @author Matias Menafra 
* @createdDate 12/18/2009
*/
public class Subscription {

	public String 	project 						{ set; get; }
	public Boolean 	ProjectMemberJoinLeave 			{ set; get; }
	public Boolean	ProjectTaskAssignedToMe 		{ set; get; }
	public Boolean 	ProjectTaskAssignToMeChanged 	{ set; get; }
	public Boolean 	ProjectTaskChanged 				{ set; get; }
	public Boolean 	ProjectTaskDeleted 				{ set; get; }
	public String 	UserId 							{ set; get; }
	
	/**
	* Constructor
	*/
	public Subscription(){
	}
	
	/**
    * Test Subscription Class
    */
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
		
		Subscription subs = new Subscription();
		subs.project 						= '';
		subs.ProjectMemberJoinLeave 		= true;
		subs.ProjectTaskAssignedToMe 		= true;
		subs.ProjectTaskAssignToMeChanged 	= true;
		subs.ProjectTaskChanged 			= true;
		subs.ProjectTaskDeleted 			= true;
		subs.UserId 						= '';
		
    	Test.stopTest();
		ProjectUtil.setIsTest( false );    	
    }
}