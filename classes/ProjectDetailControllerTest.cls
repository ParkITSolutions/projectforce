/**
*@author Miguel Soares @ 04/08/2009
*/
public class ProjectDetailControllerTest {
	
	/**
	* Test ProjectDetailController
	*/
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
    	System.currentPageReference().getParameters().put( 'id', GenerateEnvironmentTest.project.Id );
    	ProjectDetailController pD = new ProjectDetailController();
    	
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