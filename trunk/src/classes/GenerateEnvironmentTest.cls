/**
*@author: Miguel Soares @ 07-04-2009
*/
public class GenerateEnvironmentTest {

    /**
    * Create 3 intances of Project2__c
    */ 
    public static Project2__c project  = new Project2__c();
    public static Project2__c project2 = new Project2__c();
    public static Project2__c project3 = new Project2__c();

    public static ProjectMember__c member  = new ProjectMember__c();
    public static ProjectMember__c member2 = new ProjectMember__c();

    /**
    *  Create 2 intances of ProjectTask__c and 1 milestones
    */
    public static ProjectTask__c task  = new ProjectTask__c();
    public static ProjectTask__c task2 = new ProjectTask__c();
    public static ProjectTask__c mile  = new ProjectTask__c();
    
    public static ProjectTaskPred__c pred = new ProjectTaskPred__c();
    
     /**
    *  Create 3 project assignee
    */
    public static ProjectAssignee__c assi = new ProjectAssignee__c();
    public static ProjectAssignee__c assi2 = new ProjectAssignee__c();
    public static ProjectAssignee__c assi3 = new ProjectAssignee__c();

	/**
    *  Create 1 attachment
    */
    public static Attachment avatar = new Attachment(Name = 'avatar', Body = Crypto.generateMac('HMacSHA1', Blob.valueOf('String'), Blob.valueOf('String')));
    public static User us = new User();
    
    public static List<ProjectProfile__c> profList = new List<ProjectProfile__c>();
     
	
	/**
    *  Generate enviroment to test
    *@void
    *@static
    */
    public static testMethod void gen(){

            ProjectUtil.setIsTest( true ); 
        
        us = [ SELECT Id, Name FROM User LIMIT 1 ];
                
        // Creating profiles
        
        ProjectProfile__c projectProfile = new ProjectProfile__c();
        projectProfile.Name = 'Member Profile';
        projectProfile.ManageProjectTasks__c = false;
        projectProfile.CreateProjectTasks__c = true;
        profList.add( projectProfile );
            
        projectProfile = new ProjectProfile__c();
        projectProfile.Name = 'Public Profile';
        projectProfile.ManageProjectTasks__c = false;
        projectProfile.CreateProjectTasks__c = false;
        profList.add( projectProfile );

        projectProfile = new ProjectProfile__c();
        projectProfile.Name = 'Project Administrator';
        projectProfile.ManageProjectTasks__c = true;
        projectProfile.CreateProjectTasks__c = true;
        profList.add( projectProfile );
        insert profList;

        
        // Persiting onjects
        

        // Project2__c
        project.name = 'Project 1 name';
        project.description__c = 'Description ...';
        project.priority__c = 'High';
        project.sprint__c = '12';
        project.Type__c = 'open';
        project.PublicProfile__c = profList[ 0 ].Id;
        project.NewmemberProfile__c = profList[ 1 ].Id;
        
        project2.name = 'Project 2 name';
        project2.description__c = 'Description ...';
        project2.priority__c = 'Medium';
        project2.sprint__c = '13';
        project2.Type__c = 'close';
    
        project3.name = 'Project 2 name';
        project3.description__c = 'Description ...';
        project3.priority__c = 'Medium';
        project3.sprint__c = '13';
        project3.Type__c = 'private';
    
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
        member.Profile__c = project.NewMemberProfile__c; 
        
        member2.User__c    = UserInfo.getUserId();
        member2.Project__c = project.Id;
        member2.Profile__c = project.NewMemberProfile__c; 
        
        List<ProjectMember__c> memlist = new List<ProjectMember__c>();
        memList.add( member );
        memList.add( member2 );
        insert memList;
    
        // Tasks
        task.Name = 'task 1';
        task.Project__c = project.id;
        task.StartDate__c = Date.today();
        task.EndDate__c = Date.today();
        task.Duration__c = 2;
        
        mile.Name = 'milestone';
        mile.Project__c = project.id;
        mile.StartDate__c = Date.today();
        mile.EndDate__c = Date.today();
        mile.Duration__c = 2;
        mile.PercentCompleted__c = 55;
        mile.Milestone__c = true;
        
        task2.Name = 'task 2';
        task2.Project__c = project2.id;
        task2.StartDate__c = Date.today();
        task2.EndDate__c = Date.today();
        task2.Duration__c = 2;      
        
        List<ProjectTask__c> taskList = new List<ProjectTask__c>();
        taskList.add( task );
        taskList.add( task2 );
        taskList.add( mile );
        insert taskList;

        pred.Name = 'Pred';
        pred.Parent__c = task.id;
        pred.Project__c = project.id;
        
        insert pred;        
        
        // Assignies
        assi.Name = 'Assignee 1';
        assi.Project__c = project.Id;
        assi.ProjectTask__c = task.Id;
        assi.User__c = member.User__c;
        
        assi2.Name = 'Assignee 2';
        assi2.Project__c = project.Id;
        assi2.ProjectTask__c = task.Id;
        assi2.User__c = member.User__c;

        assi2.Name = 'Assignee 3';
        assi2.Project__c = project2.Id;
        assi2.ProjectTask__c = task.Id;
        assi2.User__c = member2.User__c;

        
    }
}