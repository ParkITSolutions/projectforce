/**
*@author Miguel Soares @ 04/08/2009
*/
@isTest private class ProjectDetailControllerTest {
	
	/**
	* Test ProjectDetailController
	*@void
    *@static
	*/
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
    	System.currentPageReference().getParameters().put( 'id', GenerateEnvironmentTest.project.Id );
    	
    	ApexPages.StandardController stdCtrl;
    	ProjectDetailController pD = new ProjectDetailController( stdCtrl );
    	ProjectDetailController pD2 = new ProjectDetailController();
    	
    	pD.setTeamIdParam( GenerateEnvironmentTest.project.Id );
    	pd.getTeamIdParam();
    	
		pD.setIsPublic( true );
		pD.setIsMember( false );
		pD.getIsPublic();
		pD.getIsMember();
		pD.joinProject();
		pD.unjoinProject();
		pD.projectRedirect();
		pD.getTeamspace();
		pD.getTeamspaceImage();
		pD.getIsLastMemberAdmin();
		pD.getUserPermission();
		pD.getIsManager();
    	
    	pd.getInTeamSubscription();
    	
    	
    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    }    	
}