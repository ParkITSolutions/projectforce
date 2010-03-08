public class DAOFactoryTest {
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
    	
    	ProjectTask__c tAux = new ProjectTask__c();
        tAux.Name 			= 'task 1';
        tAux.Project__c 	= GenerateEnvironmentTest.project.id;
        tAux.StartDate__c 	= Date.today();
        tAux.EndDate__c 	= Date.today();
        tAux.DurationUI__c 	= '2';
    	insert tAux;
    	
    	DAOFactory f = DAOFactory.getInstance();
    	
    	List<String> strList = new List<String>();
    	strList.add( GenerateEnvironmentTest.user.id ); 
    	try{
    		f.insertTask( new ProjectTask__c(), strList);
    	}catch (Exception e){}
    	
    	f.updateTask( GenerateEnvironmentTest.task );
    	
    	strList = new List<String>();
    	
    	strList.add( GenerateEnvironmentTest.task2.id );
    	f.getTasks( tAux.id );
    	
    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    }
    	
    static testMethod void myUnitTest2(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
    	ProjectTask__c tAux = new ProjectTask__c();
        tAux.Name 			= 'task 1';
        tAux.Project__c 	= GenerateEnvironmentTest.project.id;
        tAux.StartDate__c 	= Date.today();
        tAux.EndDate__c 	= Date.today();
        tAux.DurationUI__c 	= '2';
    	insert tAux;
    	
    	DAOFactory f = DAOFactory.getInstance();

    	f.deleteTasks( tAux.id );
    	
    	f.getTask( GenerateEnvironmentTest.task.id );
    	f.getTaskByCustomId([ select id__c from ProjectTask__c limit 1 ].id__c );
    	
    	f.ProjectTaskNotesObtainData(GenerateEnvironmentTest.task.id);

    	f.taskInfoWithProjectRel(GenerateEnvironmentTest.task.id);
    	
    	f.deleteTaskAssignee( GenerateEnvironmentTest.assi.id );
    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    }
    	
    static testMethod void myUnitTest3(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
    	ProjectTask__c tAux = new ProjectTask__c();
        tAux.Name 			= 'task 1';
        tAux.Project__c 	= GenerateEnvironmentTest.project.id;
        tAux.StartDate__c 	= Date.today();
        tAux.EndDate__c 	= Date.today();
        tAux.DurationUI__c 	= '2';
    	insert tAux;
    	DAOFactory f = DAOFactory.getInstance();
    	
    	//f.getMemberByUserId( GenerateEnvironmentTest.member.id );
    	f.deleteMembers( GenerateEnvironmentTest.member.id, GenerateEnvironmentTest.project.id );
    	f.isCRMAdministrator();
    	
    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    }

    static testMethod void myUnitTest4(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
    	ProjectTask__c tAux = new ProjectTask__c();
        tAux.Name 			= 'task 1';
        tAux.Project__c 	= GenerateEnvironmentTest.project.id;
        tAux.StartDate__c 	= Date.today();
        tAux.EndDate__c 	= Date.today();
        tAux.DurationUI__c 	= '2';
    	insert tAux;
    	DAOFactory f = DAOFactory.getInstance();

    	f.getCandidatesToAssign( GenerateEnvironmentTest.task.id );
    	f.getProjetsInfoByMember( GenerateEnvironmentTest.user.id );
    	
    	f.insertAssignees( GenerateEnvironmentTest.task.id, new List<String>{GenerateEnvironmentTest.user.id}, GenerateEnvironmentTest.project.id );
    	
    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    }
}