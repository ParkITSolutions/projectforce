/**
* @author Miguel Soares
* @createdDate 04/08/2009
*/
public class ProjectDetailControllerTest{
	
	/**
	* Test ProjectDetailController
	*/

    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
    	Test.startTest();
		//ApexPages.currentPage= new PageReference( '/apex/ProjectDetail?id=' + GenerateEnvironmentTest.project.Id);
    	System.currentPageReference().getParameters().put( 'id', GenerateEnvironmentTest.project.Id );
    	ApexPages.StandardController stdCtrl;//   = new ApexPages.StandardController();
    	ProjectDetailController pD = new ProjectDetailController( stdCtrl );
    	ProjectDetailController pD2 = new ProjectDetailController();
    	
    	pD.projectId = GenerateEnvironmentTest.project.Id;
    	//pd.getTeamIdParam();
    	
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