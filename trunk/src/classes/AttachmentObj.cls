/**
* @author Matias Menafra @ 2/1/2010
*/
public class AttachmentObj {

	public String realId			{ set; get; }
	public String name 				{ set; get; }
	public String weight 			{ set; get; }
	public DateTime createdDate 	{ set; get; }
	public String createdBy 		{ set; get; }
	public String image		 		{ set; get; }
	public String contentType 		{ set; get; }
	
	
	/**
	* Constructor
	*/
	public AttachmentObj(){
	}
	
	/**
    * Test 
    */
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
		
		AttachmentObj attachment = new AttachmentObj();
		
    	Test.stopTest();
		ProjectUtil.setIsTest( false );    	
    }
}