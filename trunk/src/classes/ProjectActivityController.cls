/**
* @author Matias Menafra  
* @createdDate 1/20/2010
*/
public class ProjectActivityController {
	
	public String projectId 	{ set; get; }
	public Paginator paginator 	{ set; get; }
	
	/**
	* Constructor
	*/
	public ProjectActivityController(){
		
		this.projectId 				= System.currentPageReference().getParameters().get('id');
		this.paginator 				= new Paginator();
		this.paginator.project.id 	= this.projectId;
		
		paginator.loadProjectActivities();
	}
	
	/**
    * Test 
    */
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
		
		Test.setCurrentPageReference(new PageReference('Page.ProjectDetail'));
		System.currentPageReference().getParameters().put( 'id', GenerateEnvironmentTest.project.id );

		
    	Test.stopTest();
		ProjectUtil.setIsTest( false );    	
    } 
}