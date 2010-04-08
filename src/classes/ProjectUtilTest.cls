/**
* @author Miguel Soares
* @createdDate 04/14/2009
*/
public class ProjectUtilTest {
		
	/**
	* Test  ProjectUtil
	*/
    public static testMethod void myUnitTest(){
    	
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

    	Date startDate;
    	Date endDate;
    	Integer l = 4;
    	startDate = Date.today().addDays(-1);
    	for( Integer k = 0; k < 31; k ++){
    		startDate = startDate.addDays( 1 );
    		for( Integer w = 1; w < 8; w++ ){
    			if( ProjectUtil.daysMap.get( Datetime.valueOf( startDate + '00:00:00').format( 'EEE' )) <= w ){
	    			endDate = ProjectUtil.calculateEndDateWithEndDateAndDuration( startDate, w, l );
	    			System.assert(ProjectUtil.calulateDurationUntilBigCrash( startDate, endDate, w )==l, 'ERROR: '+ '\n Duration result '+ProjectUtil.calulateDurationUntilBigCrash( startDate, endDate, w )+ '\n Expected result '+ l);
    			}
    		}
    	}
    	
    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    } 
}