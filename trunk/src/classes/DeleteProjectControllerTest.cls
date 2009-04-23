/**
*@author: Miguel Soares @ 15-04-2009
*/
@isTest private class DeleteProjectControllerTest {
	
	/**
    * Test DeleteProjectController
    *@void
    *@static
    */
	static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
    	
    	System.currentPageReference().getParameters().put( 'id', GenerateEnvironmentTest.project.id );
    	DeleteProjectController dpc = new DeleteProjectController();
    	
    	dpc.setProjectId( GenerateEnvironmentTest.project.id );
    	dpc.getProjectId();
    	dpc.deleteProject();

    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    }
         	
}