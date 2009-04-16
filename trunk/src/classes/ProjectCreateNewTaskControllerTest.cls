@isTest private class ProjectCreateNewTaskControllerTest {

    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();


		// Create a new Task
		System.currentPageReference().getParameters().put( 'id', GenerateEnvironmentTest.project.Id );
		System.currentPageReference().getParameters().put('task', GenerateEnvironmentTest.mile.id );
		ProjectTask__c newTask = new ProjectTask__c();
		newtask.Name = 'task 1';
		newtask.Project__c = GenerateEnvironmentTest.project.Id;
		newtask.StartDate__c = Date.today();
		newTask.EndDate__c = Date.today();
		newTask.Duration__c = 2;
		System.currentPageReference().getParameters().put('qmname', GenerateEnvironmentTest.mile.Name);
		System.currentPageReference().getParameters().put( 'qtsd', Date.toDay().format());
		System.currentPageReference().getParameters().put( 'qtdd', Date.toDay().format());
		System.currentPageReference().getParameters().put( 'qmdd', Date.toDay().format());
		System.currentPageReference().getParameters().put( 'qte', '2' );
		
		ProjectCreateNewTaskController newT = new ProjectCreateNewTaskController();
		newT.save();
		
		
		// Call getters and setters
		System.currentPageReference().getParameters().put( 'id', GenerateEnvironmentTest.project.Id );

		System.currentPageReference().getParameters().put('qmname', null );
		System.currentPageReference().getParameters().put('task', null );

		System.currentPageReference().getParameters().put( 'qtsd', Date.toDay().format());
		System.currentPageReference().getParameters().put( 'qtdd', Date.toDay().format());
		System.currentPageReference().getParameters().put( 'qte', '2' );		

 
		newT = new ProjectCreateNewTaskController();
		newT.getValidSizePicture();
		newT.saveAssignees();
		newT.getProjectId(); 
		newT.getValidTypePicture();
		newT.getAttachmentList();
		newT.getAssignees();
		newT.getAssignMember();
		newT.getUserPermissions();
		newT.getdateMy();
		newT.getassingTo();
		newT.getTask();
		newT.getTypeOfAction();
		newT.getNamespace();
		newT.getErrorAttachList();
		newT.getAtt1();
		newT.getAtt2();
		newT.getAtt3();
		newT.getAtt4();
		newT.getAtt5();
		newT.getAtt6();
		newT.getAtt7();
		newT.getAtt8();
		newT.getAtt9();
		newT.getAtt10();
		newT.getMembers();
		newT.getPercent();
		newT.getPercentDedicated();
		//newT.getTaskForEdit();
		newT.getPriority();

    	Attachment att = new Attachment(Name = 'avatar', Body = Crypto.generateMac('HMacSHA1', Blob.valueOf('String'), Blob.valueOf('String')));
    	att.ParentId = GenerateEnvironmentTest.task.Id;
    	insert att;
		newT.setAttachment( GenerateEnvironmentTest.task.Id );
		newT.setParam( GenerateEnvironmentTest.project.Id );
		newT.setTask(  GenerateEnvironmentTest.task );
		newT.setAssignees(  GenerateEnvironmentTest.assi.Id );


		newT.genTempTask();
    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    } 
}