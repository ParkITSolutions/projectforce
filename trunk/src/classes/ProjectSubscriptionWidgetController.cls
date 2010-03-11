/**
* @author Matias Menafra
* @createdDate 02/20/2010  
*/
public class ProjectSubscriptionWidgetController {
	
	public Boolean  isProduction 	{ set; get; }
	public String idProject 		{ set; get; } 
	
	/**
	* Constructor
	*/
	public ProjectSubscriptionWidgetController(){
		
		this.isProduction	= ProjectUtil.isProduction;
		this.idProject 		= System.currentPageReference().getParameters().get( 'id' );
	}
	
	/**
    * Test Project subscription Widget
    */
    public static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
		
		Test.setCurrentPageReference( new PageReference( 'Page.ProjectDetail' ) );
		System.currentPageReference().getParameters().put( 'id', GenerateEnvironmentTest.project.id );

		ProjectSubscriptionWidgetController subsWidget = new ProjectSubscriptionWidgetController();
		
    	Test.stopTest();
		ProjectUtil.setIsTest( false );    	
    }
}