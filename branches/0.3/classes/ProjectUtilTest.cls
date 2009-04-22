/**
*@author Miguel Soares @ 04/14/2009
*/
public class ProjectUtilTest {
		
	/**
	* Test  ProjectUtil
	*/
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
    	
    	ProjectUtil pu = new ProjectUtil();
    	
    	ProjectUtil.setIsTest( true );
    	ProjectUtil.getIsTest();
    	ProjectUtil.setisRunnig( true );
    	ProjectUtil.getisRunnig();
		ProjectUtil.getNamespace();

		List<String> lStr = new List<String>();
		lStr.add( 'aaa' );
		ProjectUtil.deleteGroupMembers( lStr );
		ProjectUtil.deleteGroup( lStr );
		
		List<Attachment> lAtt = new List<Attachment>();
		lAtt.add( GenerateEnvironmentTest.avatar);
		ProjectUtil.validateFileSize( lAtt );

    	
    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    } 
}