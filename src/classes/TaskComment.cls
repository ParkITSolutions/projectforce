/**
* @author Matias Menafra 
* @createdDate 12/18/2009
*/
public class TaskComment {

	public String taskId 	{ set; get; }
	public String body 		{ set; get; }
	public String createdBy { set; get; }

	/**
	* Constructor
	*/ 
	public TaskComment(){
	}
	
	/**
	* Test ProjectDetailController
	*/
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
    	
    	TaskComment tc = new TaskComment();
    	
    	tc.taskId 		= '';
    	tc.body 		=  '';
    	tc.createdBy 	= '';
    	
    	tc.taskId 		= tc.taskId;
    	tc.body 		= tc.body;  
    	tc.createdBy 	= tc.createdBy;

    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    }			
}