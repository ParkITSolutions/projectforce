public class GenerateEnvironmentTest {

	// Create 3 intances of Project2__c
	public static Project2__c project  = new Project2__c();
	public static Project2__c project2 = new Project2__c();

	public static ProjectMember__c member  = new ProjectMember__c();
	public static ProjectMember__c member2 = new ProjectMember__c();

	// Create 2 intances of ProjectTask__c and 1 milestones
	public static ProjectTask__c task  = new ProjectTask__c();
	public static ProjectTask__c task2 = new ProjectTask__c();
	public static ProjectTask__c mile  = new ProjectTask__c();
	
	// Create 2 project assignee
	public static ProjectAssignee__c assi = new ProjectAssignee__c();
	public static ProjectAssignee__c assi2 = new ProjectAssignee__c();
	public static ProjectAssignee__c assi3 = new ProjectAssignee__c();



	public static void gen(){
		
		// Creating profiles
		Integer cnt = 0;
		ProjectProfile__c projectProfile = new ProjectProfile__c();
		List<ProjectProfile__c> profList = new List<ProjectProfile__c>();
		cnt = [select count() from ProjectProfile__c where Name = 'Member Profile'];
		
		//Can create tasks, cannot manage.	
       	if(cnt == 0){
       	    projectProfile = new ProjectProfile__c();
       	    projectProfile.Name = 'Member Profile';
       	    projectProfile.ManageProjectTasks__c = false;
       	    projectProfile.CreateProjectTasks__c = true;
       	    profList.add( projectProfile );
       	    
       	}
       	
      	cnt = [select count() from ProjectProfile__c where Name = 'Public Profile'];
      	//Cant create nor manage.
       	if(cnt == 0){
       	    projectProfile = new ProjectProfile__c();
       	    projectProfile.Name = 'Public Profile';
       	    projectProfile.ManageProjectTasks__c = false;
       	    projectProfile.CreateProjectTasks__c = false;
       	    profList.add( projectProfile );
       	}
       	
       	cnt = [select count() from ProjectProfile__c where Name = 'Project Administrator'];
       	if(cnt == 0){
       	    projectProfile = new ProjectProfile__c();
       	    projectProfile.Name = 'Project Administrator';
       	    projectProfile.ManageProjectTasks__c = true;
       	    projectProfile.CreateProjectTasks__c = true;
       	    profList.add( projectProfile );
       	}
		if( profList.size() > 0 )
		insert profList;

		
		// Persiting onjects

		// Project2__c
		project.name = 'Project 1 name';
		project.description__c = 'Description ...';
		project.priority__c = 'High';
		project.sprint__c = '12';
		
		project2.name = 'Project 2 name';
		project2.description__c = 'Description ...';
		project2.priority__c = 'Medium';
		project2.sprint__c = '13';
	
		List<Project2__c> projList = new List<Project2__c>();
		projList.add( project );
		projList.add( project2 );
		insert projList;
		
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
		task.StartDate__c = Date.today();
		task.EndDate__c = Date.today();
		task.Duration__c = 2;
		
		task2.Name = 'task 1';
		task2.StartDate__c = Date.today();
		task2.EndDate__c = Date.today();
		task2.Duration__c = 2;
		
		mile.Name = 'task 1';
		mile.StartDate__c = Date.today();
		mile.EndDate__c = Date.today();
		mile.Duration__c = 2;
		mile.Milestone__c = true;
		
		List<ProjectTask__c> taskList = new List<ProjectTask__c>();
		taskList.add( task );
		taskList.add( task2 );
		taskList.add( mile );
		insert taskList;
		
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