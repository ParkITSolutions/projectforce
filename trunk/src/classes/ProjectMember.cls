/**
* @author Matias Menafra 
* @createdDate 12/18/2009
*/
public class ProjectMember {

	public String id 			{ set; get; }
	public String profile 		{ set; get; }
	public String projectId 	{ set; get; }
	public String userId 		{ set; get; }
	public String username 		{ set; get; }
	public String name 			{ set; get; }
	public Date createdBy 		{ set; get; }
	public Boolean isAdmin		{ set; get; }
	public DateTime CreatedDate	{ set; get; }
	
	/**
	* Constructor
	*/
	public ProjectMember(){
	}
	
	/**
    * Test 
    */
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
		
		ProjectMember prjMember = new ProjectMember();
		
    	Test.stopTest();
		ProjectUtil.setIsTest( false );    	
    }
}