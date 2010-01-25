@isTest 
private class UserTasksControllerTest {


	static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
    	
    	
    	System.currentPageReference().getParameters().put( 'id', GenerateEnvironmentTest.project.id ) ;
 		UserTasksController us = new UserTasksController();
 		
 		List<SelectOption> prjs = us.getProjectSelectOps();
 		
 		if( prjs.size() > 0 ){
 			us.setOpSelected( GenerateEnvironmentTest.project.id);
 		}
 		
 		us.selectProjectBasicData(); 
 		us.selectAllPeojectName();
 		
 
 		us.order = 'ASC';
 		us.setingOrder();
 		us.order = 'DESC';
 		us.setingOrder();
 
 
 		// Calling all setters and getters
 		us.setTasks( us.getTasks() );
 		String attachmentId = us.getAttachmentPrjId(); // 1 SOQL
 		
 		us.getRows();	// Pagination
 		us.setLastPage( us.getLastPage() );
 		us.getPage();
 		us.setPage( 'next' );
 		us.setPage( 'previous' );
 		us.getNotShowFirst();
 		us.getShowDetail();
 		us.getCurrentProject();
 		us.setCurrentProject( new Project() );
 		
 		
 		
    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    }
}