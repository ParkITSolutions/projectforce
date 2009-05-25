public class ProjectOverlayDeleteAssigneeTest {
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();

		ProjectOverlayDeleteAssigneeController po = new ProjectOverlayDeleteAssigneeController();
		po.genPermissions();
		po.setIdDeletes( GenerateEnvironmentTest.assi.id );
		po.getIdDeletes();
		po.deleteAssignee();
 
    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    } 
}