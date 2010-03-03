public with sharing class TaskPdfExportControllerTest {
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
    	
    	Attachment att = new Attachment(Name = 'avatar', Body = Crypto.generateMac('HMacSHA1', Blob.valueOf('String'), Blob.valueOf('String')));
    	att.ParentId = GenerateEnvironmentTest.task.id;
    	insert att;
    	
    	ProjectTask__c Task = new ProjectTask__c();
        task.Name 			= 'task 1';
        task.Project__c 	= GenerateEnvironmentTest.project.id;
        task.StartDate__c 	= Date.today();
        task.EndDate__c 	= Date.today();
        task.DurationUI__c 	= '2';
    	insert task;

		List<ProjectAssignee__c> lAssi = new List<ProjectAssignee__c>();
		ProjectAssignee__c assi = new ProjectAssignee__c();
        assi.Name 				= 'Assignee 1';
        assi.Project__c 		= GenerateEnvironmentTest.project.Id;
        assi.ProjectTask__c 	= task.Id;
        assi.User__c 			= GenerateEnvironmentTest.user.id;
		lAssi.add( assi );
		
		ProjectAssignee__c assi2 = new ProjectAssignee__c();
        assi2.Name 				= 'Assignee 2';
        assi2.Project__c 		= GenerateEnvironmentTest.project.Id;
        assi2.ProjectTask__c 	= task.Id;
        assi2.User__c 			= GenerateEnvironmentTest.user.id;
        assi2.PercentDedicated__c = 10.0;
		lAssi.add( assi2 );
        
		insert lAssi;
		    	
    	GenerateEnvironmentTest.task.parentTask__c = task.id;
    	update GenerateEnvironmentTest.task;
    	
    	System.currentPageReference().getParameters().put( 'id', GenerateEnvironmentTest.task.id );
    	TaskPdfExportController pdf = new TaskPdfExportController();
    	
    	pdf.getUserPermissions();
    	pdf.setTaskId( GenerateEnvironmentTest.task.id );
    	Boolean parent = pdf.getIsTaskParent();    
    	
    	
    	TaskPdfExportController.ProjectAssignee innerPA = new TaskPdfExportController.ProjectAssignee();
    	innerPA.getId();
    	innerPA.setAssigneeId( 'sfds' );
    	innerPA.getAssigneeId();
    	innerPA.setId( GenerateEnvironmentTest.user.id );
    	innerPA.getName();
    	innerPA.setName( 'name' );
    	innerPA.getPercent();
    	innerPA.setPercent( 10 );
    	
		TaskPdfExportController.AttachmentInfo innerAI = new TaskPdfExportController.AttachmentInfo(); 
		innerAI.getId();
		innerAI.setId( GenerateEnvironmentTest.user.id );
		innerAI.getName();
		innerAI.setName( 'name' );
		innerAI.getAttachImage();
		innerAI.setAttachImage( 'a');

		TaskPdfExportController.TaskDetails innerTD = new TaskPdfExportController.TaskDetails();
		innerTD.id = '';
		innerTD.id = innerTD.id;
		innerTD.status = '';
		innerTD.status = innerTD.status;
		innerTD.Asignee = new List<TaskPdfExportController.ProjectAssignee>();
		innerTD.Asignee = innerTD.Asignee;
		innerTD.HasAsignee = true;
		innerTD.HasAsignee = innerTD.HasAsignee;
		innerTD.CantAssignees = 2 ;
		innerTD.CantAssignees = innerTD.CantAssignees;
		innerTD.IsTaskOwner = true;
		innerTD.IsTaskOwner = innerTD.IsTaskOwner;
		innerTD.assignToMe = true;
		innerTD.assignToMe = innerTD.assignToMe;
		innerTD.Name = 'name';
		innerTD.Name = innerTD.Name;
		innerTD.ProjectName = 'name';
		innerTD.ProjectName = innerTD.ProjectName;
		innerTD.ProjectId = '';
		innerTD.ProjectId = innerTD.ProjectId;
		innerTD.Priority = '';
		innerTD.Priority = innerTD.Priority;
		innerTD.StartDate = '';
		innerTD.StartDate = innerTD.StartDate;
		innerTD.DueDate = '';
		innerTD.DueDate = innerTD.DueDate;
		innerTD.Estimate = 12.0;
		innerTD.Estimate = innerTD.Estimate;
		innerTD.Description = '';
		innerTD.Description = innerTD.Description;
		innerTD.ParentTaskName = '';
		innerTD.ParentTaskName = innerTD.ParentTaskName;
		innerTD.ParentTaskId = '';
		innerTD.ParentTaskId = innerTD.ParentTaskId;
		innerTD.LastModifiedById = '';
		innerTD.LastModifiedById = innerTD.LastModifiedById;
		innerTD.LastModifiedByName = '';
		innerTD.LastModifiedByName = innerTD.LastModifiedByName;
		innerTD.LastModifiedDate = '';
		innerTD.LastModifiedDate = innerTD.LastModifiedDate;
		innerTD.CreatedById = '';
		innerTD.CreatedById = innerTD.CreatedById;
		innerTD.CreatedByName = '';
		innerTD.CreatedByName = innerTD.CreatedByName;
		innerTD.CreatedDate = '';
		innerTD.CreatedDate = innerTD.CreatedDate;
		innerTD.Milestone = true;
		innerTD.Milestone = innerTD.Milestone;
		innerTD.PercentCompleted = 10;
		innerTD.PercentCompleted = innerTD.PercentCompleted;
		innerTD.ShowAttachs = true;
		innerTD.ShowAttachs = innerTD.ShowAttachs;
		innerTD.Files = new List<TaskPdfExportController.AttachmentInfo>();

    
    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    }	
}