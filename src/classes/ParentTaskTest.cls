@isTest private class  ParentTaskTest {
	/**
	* Test  ProjectOverviewController
	*@void
    *@static
	*/
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();

		ParentTask pT = new ParentTask();

		pT.setProjectId( GenerateEnvironmentTest.project.id );
		//pT.setTaskIndent( GenerateEnvironmentTest.task.id );    	
    	pT.getTaskChildren( GenerateEnvironmentTest.task, GenerateEnvironmentTest.task2 );
    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    }     	
    	
}