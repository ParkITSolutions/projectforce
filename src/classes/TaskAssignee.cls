/**
* @author Matias Menafra 
* @createdDate 12/18/2009
*/
public class TaskAssignee {
	
	public String Id			{ set; get; }
	public String name			{ set; get; }
	public String project 		{ set; get; }
	public String projectTask 	{ set; get; }
	public String user			{ set; get; }
	
	/**
	* Constructor
	*/
	public TaskAssignee(){
	
	}
	
	/**
	* Test ProjectDetailController
	*/
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();

		TaskAssignee tA = new TaskAssignee();
		
		tA.id 			= GenerateEnvironmentTest.assi.Id;
		tA.name 		= GenerateEnvironmentTest.assi.name;
		tA.project 		= GenerateEnvironmentTest.assi.project__c;
		tA.projectTask 	= GenerateEnvironmentTest.assi.projectTask__c;
		tA.user 		= UserInfo.getUserId();
    	
		tA.id 			= tA.id;
		tA.name 		= tA.name;
		tA.project 		= tA.project;
		tA.projectTask 	= tA.projectTask;
		tA.user 		= tA.user;

    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    }		
}