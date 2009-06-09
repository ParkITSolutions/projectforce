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
				/**
				* @If Task or Milestone havent assignee
				**/
				/**
				if( ProjectUtil.getFlagAssignee()){
					List<ProjectAssignee__c> assigned = [select Id from ProjectAssignee__c where ProjectTask__c =: m.Id];
					if(assigned.isEmpty()){
						ProjectAssignee__c Assign = new ProjectAssignee__c();
						Assign.User__c = UserInfo.getUserId();
						Assign.ProjectTask__c = m.Id;
						Assign.Project__c = m.Project__c;
						assigns.add(Assign);
					}
				}
				*/
			}
			insert tasks;
			insert assigns;
		}
		finally{
		}
    	ProjectUtil.currentlyExeTrigger = false;
    }
}