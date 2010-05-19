/**
* @author: Miguel Soares @ 07-04-2009
*/
public class GenerateEnvironmentTest {
	
    public static Project2__c project  		= new Project2__c();
    public static Project2__c project2 		= new Project2__c();
    public static Project2__c project3 		= new Project2__c();

    public static ProjectMember__c member  	= new ProjectMember__c();
    public static ProjectMember__c member2 	= new ProjectMember__c();

    public static ProjectTask__c task  		= new ProjectTask__c();
    public static ProjectTask__c task2 		= new ProjectTask__c();
    public static ProjectTask__c mile  		= new ProjectTask__c();
    
    public Static TaskComment__c comment	= new TaskComment__c();
    public Static TaskComment__c comment2	= new TaskComment__c();
    public Static TaskComment__c comment3	= new TaskComment__c();
    
    public static ProjectTaskPred__c pred 	= new ProjectTaskPred__c();
    
    public static ProjectAssignee__c assi 	= new ProjectAssignee__c();
    public static ProjectAssignee__c assi2 	= new ProjectAssignee__c();
    public static ProjectAssignee__c assi3 	= new ProjectAssignee__c();

    public static Attachment avatar 		= new Attachment(Name = 'avatar',ContentType = 'foo', Body = Crypto.generateMac('HMacSHA1', Blob.valueOf('String'), Blob.valueOf('String')));
    public static User user					= new User();
    
    public static List<ProjectProfile__c> profList = new List<ProjectProfile__c>();
	
	/**
    * Generate enviroment to test
    */
    public static testMethod void gen(){

        ProjectUtil.setIsTest( true );
        
        user = [ SELECT Id, Name FROM User LIMIT 1 ];
                
        // Creating profiles
        ProjectProfile__c projectProfile = new ProjectProfile__c();
        projectProfile.Name 					= 'Member Profile';
        projectProfile.ManageProjectTasks__c 	= false;
        projectProfile.CreateProjectTasks__c 	= true;
        profList.add( projectProfile );
            
        projectProfile = new ProjectProfile__c();
        projectProfile.Name 					= 'Public Profile';
        projectProfile.ManageProjectTasks__c 	= false;
        projectProfile.CreateProjectTasks__c 	= false;
        profList.add( projectProfile );

        projectProfile = new ProjectProfile__c();
        projectProfile.Name 					= 'Project Administrator';
        projectProfile.ManageProjectTasks__c 	= true;
        projectProfile.CreateProjectTasks__c 	= true;
        profList.add( projectProfile );
        
        insert profList;

        project.name 					= 'Project open';
        project.description__c 			= 'Open';
        project.Access__c 				= 'Description ...';
        project.priority__c 			= 'High';
        project.DisplayDuration__c 		= 'Days';
        project.WorkingHours__c 		= 8.0;
        project.DaysInWorkWeek__c 		= '5';
        project.Type__c 				= 'open';
        project.PublicProfile__c 		= profList[ 0 ].Id;
        project.NewmemberProfile__c 	= profList[ 1 ].Id;
        
        project2.name 					= 'Project Closed';
        project2.description__c 		= 'Description ...';
        project2.Access__c 				= 'Closed';
        project2.priority__c 			= 'Medium';
        project2.DisplayDuration__c 	= 'Days';
        project2.WorkingHours__c 		= 8.0;
        project2.DaysInWorkWeek__c 		= '5';
        project2.Type__c 				= 'closed';
    
        project3.name 					= 'Project Private';
        project3.description__c 		= 'Description ...';
        project3.Access__c 				= 'Private';
        project3.DisplayDuration__c 	= 'Days';
        project3.WorkingHours__c 		= 8.0;
        project3.DaysInWorkWeek__c 		= '5';
        project3.priority__c 			= 'Medium';
        project3.Type__c 				= 'private';
    
        List<Project2__c> projList = new List<Project2__c>();
        projList.add( project );
        projList.add( project2 );
        
        insert projList;

        avatar.parentId = projList[ 0 ].Id;
        insert avatar;
        
        projList[ 0 ].picture__c = avatar.id;
        update projList[ 0 ];

        // Owner for all projects inserted is the same. 
        // This project members are to delete
        member.User__c    = UserInfo.getUserId();
        member.Project__c = project.Id;
        member.Name		  = 'Member 1';	
        member.Profile__c = project.NewMemberProfile__c; 
        
        member2.User__c    = UserInfo.getUserId();
        member2.Project__c = project.Id;
        member.Name		  = 'Member 2';	
        member2.Profile__c = project.NewMemberProfile__c; 
        
        List<ProjectMember__c> memlist = new List<ProjectMember__c>();
        memList.add( member );
        memList.add( member2 );
        insert memList;
    
        // Tasks
        task.Name 			= 'task 1';
        task.Project__c 	= project.id;
        task.StartDate__c 	= Date.today();
        task.EndDate__c 	= Date.today();
        task.Notes__c		= 'fjfkl dsjfklds jfiosdj flksdj flkaj klfjs dlkf sjl';
        task.DurationUI__c 	= '2';
        
	    mile.Name 					= 'milestone';
	    mile.Project__c 			= project.id;
        mile.StartDate__c 			= Date.today();
        mile.EndDate__c 	= Date.today();
        mile.DurationUI__c 			= '2';
        mile.PercentCompleted__c 	= 55;
        mile.Milestone__c 			= true;
        
        task2.Name 				= 'task 2';
        task2.Project__c 		= project2.id;
        task2.StartDate__c 		= Date.today();
        task2.Notes__c			= 'fjfkl dsjfklds jfiosdj flksdj flkaj klfjs dlkf sjl';
        task2.EndDate__c 		= Date.today();
        task2.DurationUI__c 	= '2';      
        
        List<ProjectTask__c> taskList = new List<ProjectTask__c>();
        taskList.add( task );
        taskList.add( task2 );
        taskList.add( mile );
        
        insert taskList;
		
		  List<TaskComment__c> commentList = new List<TaskComment__c>();
		//Adding comments to tasks
		comment.Body__c = 'comment number 1';
		comment.Task__c = task.Id;
		comment2.Body__c = 'comment number 2';
		comment2.Task__c = task2.Id;
		comment3.Body__c = 'comment number 3';
		comment3.Task__c = task.Id;
		
		commentList.add( comment );
		commentList.add( comment2 );
		commentList.add( comment3 );
		
		insert commentList;
		
        pred.Name 		= 'Pred';
        pred.Parent__c 	= task.id;
        pred.Project__c = project.id;
        
        // Assignees
        assi.Name 				= 'Assignee 1';
        assi.Project__c 		= project.Id;
        assi.ProjectTask__c 	= task.Id;
        assi.User__c 			= member.User__c;
        
        assi2.Name			 	= 'Assignee 2';
        assi2.Project__c 		= project.Id;
        assi2.ProjectTask__c 	= task.Id;
        assi2.User__c 			= member.User__c;

        assi2.Name 				= 'Assignee 3';
        assi2.Project__c 		= project2.Id;
        assi2.ProjectTask__c 	= task.Id;
        assi2.User__c 			= member2.User__c;
    }
}