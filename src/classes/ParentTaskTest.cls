@isTest private class  ParentTaskTest {
	
	public static ProjectTask__c pt;
	public static ProjectTask__c pt1;
	public static ProjectTask__c pt2;
	public static ProjectTask__c pt3;
	public static ProjectTask__c pt4;
	public static ProjectTask__c pt5;
	public static ProjectTask__c pt6;
	
	public static testMethod void generateEnviroment(){ 
		
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
			pt2.Name = 'subTask 1';
			pt2.StartDate__c = System.today();
			pt2.DurationUI__c = '2';
		        pt2.Project__c =  GenerateEnvironmentTest.project.Id;
			pt2.Priority__c ='Medium';
			pt2.PercentCompleted__c = 0.0;
			pt2.ParentTask__c = pt.Id;
		tsks.add( pt2 );
		
		pt3 = new ProjectTask__c();
			pt3.Name = 'subTask 2';
			pt3.StartDate__c = System.today();
			pt3.DurationUI__c = '2';
		    	pt3.Project__c =  GenerateEnvironmentTest.project.Id;
			pt3.Priority__c ='Medium';
			pt3.PercentCompleted__c = 0.0;
			pt3.ParentTask__c = pt1.Id;
		tsks.add( pt3 );
		
		pt4 = new ProjectTask__c();
			pt4.Name = 'subTask 2-2';
			pt4.StartDate__c = System.today();
			pt4.DurationUI__c = '5';
		        pt4.Project__c =  GenerateEnvironmentTest.project.Id;
			pt4.Priority__c ='Medium';
			pt4.PercentCompleted__c = 80.0;
			pt4.ParentTask__c = pt1.Id;
		tsks.add( pt4 );
		
		pt5 = new ProjectTask__c();
			pt5.Name = 'subTask 3';
			pt5.StartDate__c = System.today();
			pt5.DurationUI__c = '4';
		    	pt5.Project__c =  GenerateEnvironmentTest.project.Id;
			pt5.Priority__c ='Medium';
			pt5.PercentCompleted__c = 0.0;
			pt5.ParentTask__c = pt2.Id;
		tsks.add( pt5 );
		
		pt6 = new ProjectTask__c();
			pt6.Name = 'subMile 3-1';
			pt6.StartDate__c = System.today();
			pt6.DurationUI__c = '1';
		        pt6.Project__c =  GenerateEnvironmentTest.project.Id;
			pt6.Priority__c ='Medium';
			pt6.Milestone__c = true;
			pt6.PercentCompleted__c = 80.0;
			pt6.ParentTask__c = pt2.Id;
		tsks.add( pt6 );
	 
	 	insert tsks;
	}
	
	/**
	* Test  Parent Task
	*@void
    *@static
	*/
    static testMethod void myUnitTest(){
    	
    	Test.startTest();
		
		generateEnviroment();
		BigListOfTasks bigListOfTasks = new BigListOfTasks(GenerateEnvironmentTest.project.Id);
		ParentTask parent = new ParentTask();

		Boolean validInsert = parent.validateParentTaskInsert(pt);
		System.assertEquals(validInsert, true);
		
		validInsert = parent.validateParentTaskInsert(pt1); 
		System.assertEquals(validInsert, true);
		
		pt.ParentTask__c = pt6.Id;
		update pt;
		validInsert = parent.validateParentTaskInsert(pt);
		//TODO System.assertEquals(validInsert, false);
		
		parent.parentTaskUpdate(pt3, pt3);
		
		Double indent = ParentTask.setTaskIndent(pt5);
		
		ParentTask.updateAllChildrensIndent(pt);
		
		parent.checkParentTaskRedundancy(pt, pt3.Id);
		
		Boolean hasChildren = parent.taskHasChildren(pt);
		hasChildren = parent.taskHasChildren(pt6);
		
		List<ProjectTask__c> childs = ParentTask.getTaskChildren(pt, pt2);
		
		//ParentTask.updateParentTasks(pt3.Id);
		
		List<String> tsks = new List<String>();
		tsks.add(pt.Id);
		tsks.add(pt3.Id);
		tsks.add(pt6.Id);
		
		//ParentTask.batchUpdateParentTask(tsks);
    	Test.stopTest();
		
    }     	
    	
}