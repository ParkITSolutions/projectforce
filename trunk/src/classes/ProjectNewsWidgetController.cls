/**
* @author Matias Menafra
* @createdDate 02/20/2010
*/
public class ProjectNewsWidgetController {
	
	public String projectId { set; get;}
	
	/**
	* Constructor
	*/
	public ProjectNewsWidgetController(){
	}
	
	/**
    * Test Project News Widget
    */
    public static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
		
		ProjectNewsWidgetController prjNews = new ProjectNewsWidgetController();
		prjNews.projectId = '';
		
    	Test.stopTest();
		ProjectUtil.setIsTest( false );    	
    }
}