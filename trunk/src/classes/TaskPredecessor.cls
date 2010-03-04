/**
*@author Matias Menafra @ 12/18/2009
*/
public class TaskPredecessor {

	public Integer 	lagTime 		{ set; get; }
	public String 	lagType 		{ set; get; }
	public String 	lagUnit 		{ set; get; }
	public String 	parent 			{ set; get; }
	public String 	predecessor 	{ set; get; }
	public String 	project 		{ set; get; }
	public String 	createdBy 		{ set; get; }
	
	/**
	* Constructor
	*/
	public TaskPredecessor(){
	}
	
	/**
    * Test Task Predecessor Class
    */
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
		
		TaskPredecessor taskPred = new TaskPredecessor();
		taskPred.lagTime 		= 0;
		taskPred.lagType 		= '';
		taskPred.lagUnit 		= '';
		taskPred.parent 		= '';
		taskPred.predecessor 	= '';
		taskPred.project 		= '';
		taskPred.createdBy 		= '';
		
    	Test.stopTest();
		ProjectUtil.setIsTest( false );    	
    }
}