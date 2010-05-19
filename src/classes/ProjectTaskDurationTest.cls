/**
* @author Matias Menafra
* @createdDate 09/09/2009
*/
@isTest private class ProjectTaskDurationTest {
	
	public static ProjectTask__c pt;
	public static ProjectTask__c pt1;
	public static ProjectTask__c pt2;
	
	/**
	* Test Task Duration
	*/
	public static testMethod void generateEnvironment(){
		
		GenerateEnvironmentTest.gen();
		List<ProjectTask__c> tsks = new List<ProjectTask__c>();
		
		pt = new ProjectTask__c();
			pt.Name 				= 'Padre11';
			pt.StartDate__c 		= System.today();
			pt.EndDate__c 		= System.today();
			pt.DurationUI__c 		= '2';
		    pt.Project__c 			= GenerateEnvironmentTest.project.Id;
			pt.Priority__c 			= 'Medium';
			pt.PercentCompleted__c 	= 0.0;
		 tsks.add( pt );
		
		pt1 = new ProjectTask__c();
			pt1.Name 				= 'Padre22';
			pt1.StartDate__c 		= System.today();
			pt1.EndDate__c 		= System.today();
			pt1.DurationUI__c 		= '2';
		    pt1.Project__c 			= GenerateEnvironmentTest.project.Id;
			pt1.Priority__c 		= 'Medium';
			pt1.PercentCompleted__c = 0.0;
			pt1.ParentTask__c 		= pt.Id;
		tsks.add( pt1 );
		
		pt2 = new ProjectTask__c();
			pt2.Name 				= 'Padre22';
			pt2.StartDate__c 		= System.today();
			pt2.EndDate__c 		= System.today();
			pt2.DurationUI__c 		= '2';
		    pt2.Project__c 			= GenerateEnvironmentTest.project.Id;
			pt2.Priority__c 		= 'Medium';
			pt2.Milestone__c 		= true;
			pt2.PercentCompleted__c = 0.0;
			pt2.ParentTask__c 		= pt.Id;
		tsks.add( pt2 );
		
		insert tsks;		
	}
    
    /**
	* Test Task Duration
	*/
    public static testMethod void myUnitTest(){
    	
		generateEnvironment();
    	Test.startTest();

		ProjectTaskDuration d = new ProjectTaskDuration(pt);

		d.validateDurationInput(pt);
		
		pt = d.calculateTaskInsert(pt);
		pt.EndDate__c = null;
		pt = d.calculateTaskInsert(pt);
		pt2 = d.calculateTaskInsert(pt2);
		
		pt1 = d.calculateTaskUpdate(pt1, pt1);
		pt2 = d.calculateTaskUpdate(pt2, pt2);
		
		d.doCalculateEndDate(pt1);
		
		pt = d.doCalculateDuration(pt);
		
		pt = d.verifyStartDate(pt);
		pt = d.verifyEndDate(pt);
		
		pt2.DurationUI__c = '6';
		pt = d.parseDuration(pt2);
		pt2.DurationUI__c = '6h';
		pt = d.parseDuration(pt2);
		pt2.DurationUI__c = '6d';
		pt = d.parseDuration(pt2);
		pt2.DurationUI__c = '6H';
		pt = d.parseDuration(pt2);
		pt2.DurationUI__c = '6D';
		pt = d.parseDuration(pt2);
		
    	Test.stopTest();
    }     	
}