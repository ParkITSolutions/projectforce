/**
* @author Matias Menafra
* @createdDate 02/20/2010
*/
public with Sharing class ProjectNewsWidgetController {
	
	public Boolean  isProduction 	{ set; get; }
	public String projectId 		{ set; get;}
	
	/**
	* Constructor
	*/
	public ProjectNewsWidgetController(){
		this.isProduction = ProjectUtil.isProduction;
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