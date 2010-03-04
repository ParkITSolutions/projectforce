/**
* @author Andres Canavesi
*/
public class DAOTask {
    
    private DAOAssignee DAOAssignee;
    
    /**
    * Constructor
    */
    public DAOTask(){
        this.DAOAssignee = new DAOAssignee();
    }
    
    /**
    * Inserts a task
    * @param task
    * @param assignedTo
    */
    public void insertTask( ProjectTask__c task, String[] assignees ){
        task.PercentCompleted__c = ProjectUtil.getDefaultTaskPercentCompleted();
        task.Priority__c = ProjectUtil.getDefaultTaskPriority();
        insert task; 
        DAOAssignee.insertAssignees( task.Id, assignees, task.Project__c );
    }
    
    /** Update task
    *@param ProjectTask__c
    */
    public void updateTask (ProjectTask__c task){
        update task;
    }
    
    /**
    * deletes a task
    * @param tasks tasks ids string separated by ":"
    */
    public void deleteTasks( String tasks ){
        
        List<String> tasksIds = new List<String>();
        
        tasksIds = tasks.split(':'); 
        
        List<ProjectTask__c> tasksToDelete = [select Id 
                                              from ProjectTask__c 
                                              where id in: tasksIds];
            
        delete tasksToDelete;
    }
    
    /**
    * gets a task by its id
    * @param id
    * @return task a ProjectTask__c
    */
    public ProjectTask__c get( String taskId ){
        
        ProjectTask__c task = new ProjectTask__c();
        
        task = [select Id, Name, Milestone__c, Project__c
                from ProjectTask__c 
                where Id =:taskId
                limit 1];
        
        return task;
    }
    
    /**
    * gets all tasks of a given project
    * @param projectId
    * @param filter a filter criteria
    * @param orderBy column name
    * @param orderAsc true if order way must be ascending or descendant
    * @letter letter to filter
    * @return tasks a list of tasks
    */
    public ApexPages.StandardSetController getByProject( String projectId, String filter, String orderBy, Boolean orderAsc, String letter ){
        
        if(letter=='All'){
            letter='';
        }
        
        String orderWay = 'DESC';
        
        if( orderAsc ){
            
            orderWay = 'ASC';
        }
        
        String condition = '';
        
        if( filter == '1' ){ //all
            
            condition = '';
        }
        
        if( filter == '2' ){ //all tasks
            
            condition = 'and Milestone__c = false';
        }
        
        if( filter == '3' ){ //all milestones
            
            condition = 'and Milestone__c = true';
        }
        
        if( filter == '4' ){ //my tasks and milestones (assigned to me)
            
            condition = 'and id in (select ProjectTask__c from ProjectAssignee__c where User__c = \''+Userinfo.getUserId()+'\')'; 

        }
        
        if( filter == '5' ){ //completed tasks
            
            condition = 'and Milestone__c = false '+
                        'and PercentCompleted__c = 100 ';
        }
        
        if( filter == '6' ){ //overdue tasks
            
            condition = 'and Milestone__c = false '+
                        'and Status__c != \'Resolved\' '+
                        'and Status__c != \'Closed\' '+
                        'and EndDate__c < '+String.valueOf(System.today())+' ';
        }
        
        if( filter == '7' ){ //overdue milestones
            
            condition = 'and Milestone__c = true '+
                        'and Status__c != \'Resolved\' '+
                        'and Status__c != \'Closed\' '+
                        'and StartDate__c < '+String.valueOf(System.today())+' ';
        }
        
        String query = 'select id, ' + 
                            'Id__c, ' +
                            'Name, ' +
                            'Milestone__c, ' +
                            'Priority__c, ' +
                            'PercentCompleted__c, ' + 
                            'Status__c,' + 
                            'Duration__c, ' +
                            'StartDate__c, ' + 
                            'EndDate__c, ' +
                            'OwnerId, '+
                            ' (Select Id, User__c, User__r.Name, User__r.Id,PercentDedicated__c From ProjectsAssignees__r order by User__r.Name) ' +
                        'from ProjectTask__c  ' + 
                        'where Project__c = \''+projectId+'\' ' +  
                        'and Name like \''+letter+'%\'' +  
                        ''+condition +' ' + 
                        'order by '+orderBy+' '+orderWay; 

        ApexPages.StandardSetController tasks = new ApexPages.StandardSetController( Database.getQueryLocator( query ) );
        
        if( tasks.getResultSize() == 0 ){
        
            return new ApexPages.StandardSetController( new List<ProjectTask__c>() );
        }
        
        return tasks;
    }
    
    /**
    *
    * @param tasksIds ids separated by ":"
    * @return tasks a tasks list
    */
    public List<ProjectTask__c> getTasks( String tasksIds ){
        
        List<String> tasksIdsList = new List<String>();
        
        tasksIdsList = tasksIds.split( ':' ); 
        
        List<ProjectTask__c> tasks = [select Id, Name, Milestone__c
                                      from ProjectTask__c 
                                      where id in: tasksIdsList];
        
        return tasks;
    }
    
    /**
    * 
    * @param taskId
    * @return task
    */
    public List<ProjectTask__c> getInfoTaskById( Id taskId ){
        return [
            Select p.Id,p.Project__c,p.Project__r.Name, p.Name, p.notes__c, p.CreatedById,
            (Select Id, User__c, User__r.Name, User__r.Id,PercentDedicated__c From ProjectsAssignees__r order by User__r.Name)
            From ProjectTask__c p 
            where p.Id =: taskId limit 1
            ];
    }
    
    /**
    * 
    * @param taskId
    * @return task
    */
    public ProjectTask__c getTaskByCustomId( String customId ){
        
        ProjectTask__c task = new ProjectTask__c();
        try{
            task = [select Id, Name, Project__c, Id__c
                from ProjectTask__c 
                where Id__c =:customId
                limit 1];
        }
        catch( Exception e ){
            task = null;
        }
        
        return task;
    }
    
    /**
    * 
    * @param projectId
    * @param searchTerm
    * @param namespace
    * @return searchResults
    */
    public ApexPages.StandardSetController searchForTasksByProject( String projectId, String searchTerm, String namespace ){
        
        String searchQ = '%'+ searchTerm +'%';
        //TODO Only searching in Task name field, Have to change DEscription type to textarea for it to be filterable
        ApexPages.StandardSetController searchResults = new ApexPages.StandardSetController( Database.getQueryLocator( [Select Id, Name, Description__c, Project__c From ProjectTask__c Where Project__c =:projectId 
                                                                                                                                                                                        AND Name LIKE :searchQ   ] ) );
        
        if( searchResults.getResultSize() == 0 ){
            return new ApexPages.StandardSetController( new List<ProjectTask__c>() );
        }
        
        return searchResults;   
    }

    /**
    * 
    * @param filter
    * @param orderBy
    * @param orderAsc
    * @param projectId
    * @param letter
    * @return task by user
    */
    public ApexPages.StandardSetController loadTasksByUser( String filter, String orderBy, Boolean orderAsc, String projectId, String letter ){
        if(letter=='All'){
            letter='';
        }
        String sql = 'SELECT project__c, ProjectTask__c, project__r.name, ProjectTask__r.name, ProjectTask__r.startDate__c, ProjectTask__r.endDate__c, ProjectTask__r.status__c, ProjectTask__r.priority__c, ProjectTask__r.milestone__c, ProjectTask__r.percentCompleted__c, ProjectTask__r.DurationUI__c '+ 
                     'FROM ProjectAssignee__c '+
                     'WHERE User__c = ';
                     
       
        sql += '\'' +UserInfo.getUserId()+ '\' ';
        
        sql += 'and ProjectTask__r.name like \''+letter+'%\' '   ;

        String orderWay = 'DESC';
        
        if( orderAsc ){
            orderWay = 'ASC';
        }
        
        
        if( projectId != '' && projectId != null )
            sql += ' AND Project__c = ' + '\'' + projectId + '\'';            
            
        sql += ' ORDER BY ' + orderBy + ' ' + orderWay ;
        ApexPages.StandardSetController tasks = new ApexPages.StandardSetController( Database.getQueryLocator( sql ));

        if( tasks.getResultSize() == 0 ){
            return new ApexPages.StandardSetController( new List<ProjectAssignee__c>() );
        }
        
        return tasks; 
    }   
    
    /**
    *Get task and project info with ProjectTask__c objetc
    *param id id of the task
    *return task data of the task
    */
    public ProjectTask__c getTaskInfoWithProjectRel( id idTask ){
        ProjectTask__c task = new ProjectTask__c();
        try{
            task = [ SELECT id, name, project__c, project__r.name FROM ProjectTask__c WHERE id =: idTask LIMIT 1 ];
        }catch( QueryException e){
            task = null;
        }
        
        return task;
    }
    
    /**
    *
    *@param String idTaskAssignee
    */
    public void deleteTaskAssignee( String idTaskAssignee ){
    	try{
	    	ProjectAssignee__c projAssig = [Select Id from ProjectAssignee__c  where Id =: idTaskAssignee limit 1][0];
	    	if ( projAssig != null )
	    		delete projAssig;
    	}
    	catch(Exception e){}
    }
}