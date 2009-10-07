@isTest private class TaskDependenciesTest {

	static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
    	
    	TaskDependencies td = new TaskDependencies( GenerateEnvironmentTest.project.id );
    	
    	ProjectTask__c task = GenerateEnvironmentTest.task;
    	ProjectTask__c task2 = GenerateEnvironmentTest.task;
    	ProjectTask__c mile = GenerateEnvironmentTest.mile;
    	List<ProjectTaskPred__c> listPtp = new List<ProjectTaskPred__c>();    	
		ProjectTaskPred__c ptp = new ProjectTaskPred__c();
			ptp.Project__c = GenerateEnvironmentTest.project.id;
			ptp.Predecessor__c = task.id;
			ptp.Parent__c = task2.id;
			ptp.Lag_Time__c = 0;
			ptp.Lag_Type__c = 'Finish-to-Start';
		listPtp.add(ptp);
		 ptp = new ProjectTaskPred__c();
			ptp.Project__c = GenerateEnvironmentTest.project.id;
			ptp.Predecessor__c = task2.id;
			ptp.Parent__c = mile.id;
			ptp.Lag_Time__c = 0;
			ptp.Lag_Type__c = 'Finish-to-Start';
		listPtp.add(ptp);

		insert listPtp;
    	
    	
    	td.goGoGo( task, task2 );
    	
    	task2.startDate__c = Date.valueOf(task2.startDate__c).addDays( -10 );    	 
    	td.goGoGo( task, task2 );
    	
    	ProjectTask__c taskAux = task.clone(); 
    	taskAux.startDate__c = Date.valueOf(task.startDate__c).addDays( 4 );    	 
    	taskAux.endDate__c   = Date.valueOf(task.startDate__c).addDays( 4 );    	 
    	td.movingTask(task, taskAux);
    	
    	td.changeLag( listPtp[ 0 ]);
				
		 ptp = new ProjectTaskPred__c();
			ptp.Project__c = GenerateEnvironmentTest.project.id;
			ptp.Predecessor__c = mile.id;
			ptp.Parent__c = task.id;
			ptp.Lag_Time__c = 0;
			ptp.Lag_Type__c = 'Finish-to-Start';
		try{
			td.checkCyclicDependencie(task.id, task2.id);
			//td.checkCyclicDependencie(task.id, mile.id);
			insert ptp;
			td.checkCyclicDependencie(task.id, mile.id);	
			td.InsertinfPred( listPtp[ 0 ]);
		}catch( Exception e ){}
 		
		
    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    }
         	
}