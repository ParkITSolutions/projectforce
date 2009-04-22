/**
*@author Miguel Soares @ 4/8/2009
*/
@isTest private class ProjectCreateNewTaskControllerTest {
	/**
	* Test ProjectCreateNewTaskController
	*/
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
		newT.att1.Name = 'nameman';   
		newT.att2.Name = 'nameman';   
		newT.att3.Name = 'nameman';   
		newT.att4.Name = 'nameman';   
		newT.att5.Name = 'nameman';   
		newT.att6.Name = 'nameman';   
		newT.att7.Name = 'nameman';   
		newT.att8.Name = 'nameman';   
		newT.att9.Name = 'nameman';   
		newT.att10.Name = 'nameman';   
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
		newT.saveAttachmentsAndAccess();
		//newT.getTaskForEdit();
		newT.getPriority();

    	Attachment att = new Attachment(Name = 'avatar', Body = Crypto.generateMac('HMacSHA1', Blob.valueOf('String'), Blob.valueOf('String')));
    	att.ParentId = GenerateEnvironmentTest.task.Id;
    	insert att;
		newT.setAttachment( GenerateEnvironmentTest.task.Id );
		newT.setParam( GenerateEnvironmentTest.project.Id );
		newT.setTask(  GenerateEnvironmentTest.task );
		newT.setAssignees(  GenerateEnvironmentTest.assi.Id );

		ProjectCreateNewTaskController.assingTo ss = new ProjectCreateNewTaskController.assingTo();
		ss.setPercent( null );
		ss.setPercent( 10 );
		ss.setIdMember( 'idOfAMember' );
		ss.getIdMember();
		ss.getPercent();
		ProjectCreateNewTaskController.myAttachment tt = new ProjectCreateNewTaskController.myAttachment();
		tt.setBodyLenght( 10 );
		tt.setIdAttachment( 'sdsad' );
		tt.setNameAttachment( 'sadas' );
		tt.setContentType('image/jpeg');
		tt.setContentType('application/pdf');
		tt.setContentType('text/plain');
		tt.setContentType('application/msword');
		tt.setContentType('application/x-zip-compressed');
		tt.setContentType( 'dsfas');
		tt.getNameAttachment();
		tt.getContentType();
		tt.getidAttachment();
		tt.getBodyLenght();
		ProjectCreateNewTaskController.dateMyFormat dd = new ProjectCreateNewTaskController.dateMyFormat();
		dd.setLastModify( System.now());
		dd.setCreateDate( System.now());
		dd.setHours( 2 );
		dd.setMember( 'ada' );
		dd.setPercent( 3 );
		dd.getPercent();
		dd.getMember();
		dd.getHours();
		dd.getCreateDate();
		dd.getLastModify();

		newT.genTempTask();
    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    } 
}