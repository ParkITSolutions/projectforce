trigger ProjectTaskAfterInsert on ProjectTask__c (after insert) {
    if (!ProjectUtil.currentlyExeTrigger) {
    	ProjectUtil.currentlyExeTrigger = true;
		try {		
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
			    
			    //Testing
			    
		    			List<ProjectTask__c> childTasks = new List<ProjectTask__c>();
						childTasks = [select Id , ParentTask__c from ProjectTask__c where ParentTask__c =: m.Id];
						System.debug('-------------->>>>>>>>>>>>>>>>>>>POR PREGUNTAR  ' + childTasks.size() + '   id: '+m.Id);
						if(childTasks.size() == 0){
							System.debug('-------------->>>>>>>>>>>>>>>>>>>> Entrando child Size');
							if(m.ParentTask__c != null){
								System.debug('-------------->>>>>>>>>>>>>>>>>>>> Entrando Insert Tarea con padre');
								ParentTask parent = new ParentTask();
								parent.checkParentTask(m);
							}
						}
						//Testing
						
			}
			insert tasks;
			insert assigns;
		}
		finally{
		}
    	ProjectUtil.currentlyExeTrigger = false;
    }
}