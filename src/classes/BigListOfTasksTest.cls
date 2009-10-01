@isTest private class BigListOfTasksTest {
	
	public static ProjectTask__c pt;
	public static ProjectTask__c pt1;
	public static ProjectTask__c pt2;
	
	public static testMethod void generateEnvironment(){
		
		GenerateEnvironmentTest.gen();
		List<ProjectTask__c> tsks = new List<ProjectTask__c>();
		
		pt = new ProjectTask__c();
			pt.Name = 'Padre11';
			pt.StartDate__c = System.today();
			pt.DurationUI__c = '2';
		        pt.Project__c = GenerateEnvironmentTest.project.Id;
			pt.Priority__c ='Medium';
			pt.PercentCompleted__c = 0.0;
		 tsks.add( pt );
		
		pt1 = new ProjectTask__c();
			pt1.Name = 'Padre22';
			pt1.StartDate__c = System.today();
			pt1.DurationUI__c = '2';
		        pt1.Project__c =  GenerateEnvironmentTest.project.Id;
			pt1.Priority__c ='Medium';
			pt1.PercentCompleted__c = 0.0;
			pt1.ParentTask__c = pt.Id;
		tsks.add( pt1 );
		
		pt2 = new ProjectTask__c();
			pt2.Name = 'Padre22';
			pt2.StartDate__c = System.today();
			pt2.DurationUI__c = '2';
		        pt2.Project__c =  GenerateEnvironmentTest.project.Id;
			pt2.Priority__c ='Medium';
			pt2.Milestone__c = true;
			pt2.PercentCompleted__c = 0.0;
			pt2.ParentTask__c = pt.Id;
		tsks.add( pt2 );
		
		insert tsks;		
	}
	
	 public static testMethod void myUnitTest(){
			
		generateEnvironment();
		BigListOfTasks bigListOfTask = new BigListOfTasks(GenerateEnvironmentTest.project.Id);
		
    	Test.startTest();
		
		ProjectTask__c aux = BigListOfTasks.get(0);
		ProjectTask__c pt3 = new ProjectTask__c();
		BigListOfTasks.add(pt3);
		
		BigListOfTasks.setById(pt2);
		
		ProjectTask__c aux2 = BigListOfTasks.getById(pt.Id);
		
		List<ProjectTask__c> lst = BigListOfTasks.getByParentId(pt.Id);
		
		Integer size = BigListOfTasks.size();
		Test.stopTest();		 
	 }
}