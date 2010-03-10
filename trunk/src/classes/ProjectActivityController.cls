/**
* @author Matias Menafra  
* @createdDate 1/20/2010
*/
public with Sharing class ProjectActivityController {
	
	public String 		projectId 	{ set; get; }
	public Paginator 	paginator 	{ set; get; }
	
	/**
	* Constructor
	*/
	public ProjectActivityController(){
		
		this.projectId 				= System.currentPageReference().getParameters().get( 'id' );
		this.paginator 				= new Paginator();
		this.paginator.project.id 	= this.projectId;
		
		paginator.loadProjectActivities();
	}
	
	/**
    * Test Project Activity Page
    */
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
		
		System.currentPageReference().getParameters().put( 'id', GenerateEnvironmentTest.project.id );
		
		ProjectActivityController projectActivity = new ProjectActivityController();
		
    	Test.stopTest();
		ProjectUtil.setIsTest( false );    	
    } 
}