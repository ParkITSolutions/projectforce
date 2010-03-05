public class DAOFactoryTest {
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
    	
    	DAOFactory f = DAOFactory.getInstance();
    	
    	List<String> strList = new List<String>();
    	strList.add( GenerateEnvironmentTest.user.id ); 
    	f.insertTask( new ProjectTask__c(), strList);
    	
    	f.updateTask( GenerateEnvironmentTest.task );
    	
    	strList = new List<String>();
    	
    	strList.add( GenerateEnvironmentTest.task2.id );
    	f.getTasks( GenerateEnvironmentTest.task.id );
    	f.deleteTasks( GenerateEnvironmentTest.task.id );
    	
    	f.getTask( GenerateEnvironmentTest.task.id );
    	f.getTaskByCustomId([ select id__c from ProjectTask__c limit 1 ].id__c );
    	
    	f.ProjectTaskNotesObtainData(GenerateEnvironmentTest.task.id);

    	f.taskInfoWithProjectRel(GenerateEnvironmentTest.task.id);
    	
    	f.deleteTaskAssignee( GenerateEnvironmentTest.assi.id );
    	
    	
    	
    	//
    	f.deleteMembers( GenerateEnvironmentTest.member.id, GenerateEnvironmentTest.project.id );
    	f.isCRMAdministrator();
    	f.getMemberByUserId( GenerateEnvironmentTest.user.id );
    	f.getCandidatesToAssign( GenerateEnvironmentTest.task.id );
    	f.getProjetsInfoByMember( GenerateEnvironmentTest.user.id );
    	
    	//
    	f.insertAssignees( GenerateEnvironmentTest.task.id, new List<String>{GenerateEnvironmentTest.user.id}, GenerateEnvironmentTest.project.id );
    	
    	
    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    }
}