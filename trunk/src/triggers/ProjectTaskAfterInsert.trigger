trigger ProjectTaskAfterInsert on ProjectTask__c (after insert) {
    if (!ProjectUtil.currentlyExeTrigger) {
        ProjectUtil.currentlyExeTrigger = true;
        try {       
            
            ParentTask parent = new ParentTask();
            BigListOfTasks bigListOfTask = new BigListOfTasks(Trigger.new.get(0).Project__c);
            TaskDependencies td = new TaskDependencies(Trigger.new[0].project__c);
            
            List<String> projectSharingGroupNames = new List<String>();     
            for(ProjectTask__c p : Trigger.new) {
                projectSharingGroupNames.add('ProjectSharing' + p.Project__c);
            }
            
            Map<String, Id> projectMap = new Map<String, Id>();                 
            for(Group g: [select id, name from Group where Name in: projectSharingGroupNames]) {
                projectMap.put(g.Name, g.Id);
            }
            
            List<ProjectTask__Share> tasks = new List<ProjectTask__Share>();
            List<ProjectAssignee__c> assigns = new List<ProjectAssignee__c>();
            for(ProjectTask__c m : Trigger.new) {
                
                ProjectTask__Share p = new ProjectTask__Share();
                p.ParentId = m.Id;
                p.UserOrGroupId = projectMap.get('ProjectSharing' + m.Project__c);
                p.AccessLevel = 'Read';
                p.RowCause = 'Manual';
                tasks.add(p);
                
                //Re-Evaulates Parent nodes after Inserting a task with a Parent
                if(m.ParentTask__c != null){
                    ProjectTask__c aux = ParentTask.getParentTask(m).clone();
                    if(aux.Milestone__c == true){
                        aux.EndDate__c = aux.StartDate__c;
                        aux.Milestone__c = false;
                        BigListOfTasks.setById(aux);

                        ProjectUtil.setFlagValidationParentTask(false);
                        ProjectUtil.setTaskDependenciesFlag(false);
                        ProjectUtil.flags.put('exeParentTaskUpdate', false);
                        update aux;
                        ProjectUtil.setFlagValidationParentTask(true);
                    }
                    //then check and update its parent
                    td.delAllRelsFromMe( ParentTask.getParentTask(m));
                    
                    //ParentTask.checkParentTask( m );
                    List<String> taskIdLst = new List<String>();
                    taskIdLst.add( m.Id );
                    ParentTask.batchUpdateParentTask( taskIdLst );
                }
                        
            }
            insert tasks;
            insert assigns;
        }
        finally{
        }
        ProjectUtil.currentlyExeTrigger = false;
    }
}