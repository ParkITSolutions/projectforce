public with sharing class TaskAsigneeExtension {
    public List<ProjectMember__c> projectMemberList {get; set;}
    public ProjectTask__c classTask {get; set;}
    public ProjectAssignee__c classAssignee {get; set;}
    public String taskId {get; set;}
    public String projectId {get; set;} 
    public String paramProjectMember {get; set;}
    public String paramTask {get; set;}
    public User userAssignee {get; set;}
    public List<ProjectAssignee__c> assignees {get;set;}

    /**
    * Constructor:
    * Obtain taskId and projectId from parameters on the URL of the popup window
    * Since this can be call from the page where the VF page is added we also
    * take care about the option that nothing is passed buy URL and obtained
    * taskId from the standard controller and the get projectId from this taskId. 
    */
    public TaskAsigneeExtension( ApexPages.StandardController stdController ){
        this.taskId = System.currentPageReference().getParameters().get('tid');
        this.projectId = System.currentPageReference().getParameters().get('id');
        ProjectMember__c dummyProjectMember = new ProjectMember__c(Name = 'None');
        if(this.taskId==null){
            /**
            * This case is when no id is passed by URL:
            *   - get taskId from standard controller
            *   - get task with that id and then assign projectId
            *   - get project member list for that project
            */
            this.taskId = stdController.getId();
            List<ProjectTask__c> tasks = [Select p.StartDate__c, p.Project__c, p.Name, p.Id__c, p.Id, p.DurationUI__c From ProjectTask__c p WHERE Id=: taskId limit 1];
            if(tasks.size()>0) 
            {
                classTask = tasks.get(0);
                this.projectId = classTask.Project__c;
            }
            if(projectId!=null)
            {
                projectMemberList = [Select p.User__c, p.Project__c, p.Name, p.Id From ProjectMember__c p where p.Project__r.Id=: projectId];
            }
        } else {
            /**
            * This case is when id is passed by URL:
            *   - get project task linked to that projectId and taskId
            *   - get project member list for that project
            */
            
            List<ProjectTask__c> tasks = [Select p.StartDate__c, p.Project__c, p.Name, p.Id__c, p.Id, p.DurationUI__c From ProjectTask__c p WHERE Id=: taskId limit 1];
            if(tasks.size()>0) 
            {
                classTask = tasks.get(0);
                projectMemberList = [Select p.User__c, p.Project__c, p.Name, p.Id From ProjectMember__c p where p.Project__r.Id=: projectId];
            } 
        }
        
        /**
          added a dummy member to the projectMemberList to unassign a task.
        */
        if(projectMemberList.isEmpty()){
            projectMemberList.add(dummyProjectMember);
        }else{
            projectMemberList.add(0,dummyProjectMember);
        }
        /**
        * To display the name of the user assigned to the task:
        *   - get asignee list for that task
        *   - get user linked to that asignee element
        *   - assign name of the user to the variable used for that
        */
        assignees = [Select p.User__c, p.Project__c, p.ProjectTask__c, p.Name, p.Id From ProjectAssignee__c p where p.Project__c=:projectId and p.ProjectTask__c=:taskId];
        
        if (assignees.size()>0)
        {
            this.classAssignee = assignees.get(0);
            String idAux = this.classAssignee.User__c;
            List<User> users = [Select u.Name, u.Id From User u where u.Id =: idAux];
            if (users.size()>0)
                userAssignee = users.get(0);
        }
    }
    
    public void selectProjectMember(){  
        List<ProjectAssignee__c> assignees = [Select p.User__c, p.Project__c, p.ProjectTask__c, p.Name, p.Id From ProjectAssignee__c p where p.Project__c=:projectId and p.ProjectTask__c=:taskId];
        if (assignees.size()>0)
        {
            /**
            * A project member is already assigned to that project task, so we need to update the user
            * associated to the task assignee
            */
            this.classAssignee = assignees.get(0);
            
            //if member selected is not the dummy member
            if(paramProjectMember != ''){
                this.classAssignee.User__c = paramProjectMember;
                try
                {
                    update this.classAssignee;
                }    
                catch (DMLException ex)
                {}
            }else{
                try
                {
                    delete this.classAssignee;
                }    
                catch (DMLException ex)
                {}
            }
            
            /**
            * if member selected is not the dummy member
            */
        } else if(paramProjectMember != ''){
            /**
            * A new project member is assigned to the project task, so we need to insert the new user
            * associated to the task assignee
            */
            this.classAssignee = new ProjectAssignee__c();
            this.classAssignee.User__c = paramProjectMember;
            this.classAssignee.Project__c = this.projectId;
            this.classAssignee.ProjectTask__c = this.taskId;
            try
            {
                insert this.classAssignee;
            }
            catch (DMLException ex){}
        }
        /**
        * Set the name of the user assigned to display on the task detail page if there is one.
        */
        if(paramProjectMember != ''){
            String idAux = this.classAssignee.User__c;
            List<User> users = [Select u.Name, u.Id From User u where u.Id =: idAux];
            if (users.size()>0){
                userAssignee = users.get(0);
            }    
        }
        
    }

    /**
    *Delete the assignee and reload the page
    *@return PageReference to the curren task
    */
    public void deleteAssignee(){
        delete this.classAssignee;
    }
    public static testMethod void selectProjectMemberTest(){

		GenerateEnvironmentTest.gen();

		/*
        Project2__c project = new Project2__c();
        project.Name = 'SelectProjectMember Test';
        insert project;

        ProjectTask__c projTask = new ProjectTask__c();
        projTask.Name = 'Task for testing SelectProjectMember Test';
        projTask.Project__c = project.Id;
        projTask.StartDate__c = Date.today();
        projTask.EndDate__c = Date.today();
        projTask.DurationUI__c = '5';
        insert projTask;
        
        ProjectMember__c projMem = new ProjectMember__c();
        projMem.Project__c = project.Id;
        projMem.User__c = UserInfo.getUserId();
        projMem.Name = 'User Name for SelectProjectMember Test';
        insert projMem;
        */
        ApexPages.Standardcontroller sc = new ApexPages.StandardController( GenerateEnvironmentTest.task );
        TaskAsigneeExtension tTest = new TaskAsigneeExtension(sc);

        Test.startTest();
        
            tTest.selectProjectMember();
            
            System.currentPageReference().getParameters().put('id', GenerateEnvironmentTest.project.Id);
            System.currentPageReference().getParameters().put('tid', GenerateEnvironmentTest.task.Id);
            TaskAsigneeExtension tTest2 = new TaskAsigneeExtension(sc);
            tTest2.selectProjectMember();
            
        Test.stopTest();
    }

}