trigger ProjectTaskAfterInsert on ProjectTask__c (after insert) {
    if (!ProjectUtil.currentlyExeTrigger) {
    	ProjectUtil.currentlyExeTrigger = true;
		try {		
			
			ParentTask parent = new ParentTask();
			BigListOfTasks bigListOfTasks = new BigListOfTasks(Trigger.new.get(0).Project__c);
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
					ParentTask.checkParentTask(m);
                	td.delAllRelsFromMe( parent.getParentTask(m));
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