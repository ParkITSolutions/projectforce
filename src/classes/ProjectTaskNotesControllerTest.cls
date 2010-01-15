public with sharing class ProjectTaskNotesControllerTest {
	static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();

		ProjectTask__c pt = new ProjectTask__c();
		
		ProjectTaskNotesController nt = new ProjectTaskNotesController( new ApexPages.StandardController( pt ));
		nt.CancelEdit();
		
		System.currentPageReference().getParameters().put('id_task', GenerateEnvironmentTest.task.id );
		nt = new ProjectTaskNotesController( new ApexPages.StandardController( GenerateEnvironmentTest.task ));
		nt.SaveEditAndExit();
		
		nt = new ProjectTaskNotesController( new ApexPages.StandardController( pt ));
		nt.SaveEdit();
		


    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    }    	
}