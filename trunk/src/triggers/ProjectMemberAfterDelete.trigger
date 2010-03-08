trigger ProjectMemberAfterDelete on ProjectMember__c (after delete) {
    if (!ProjectUtil.currentlyExeTrigger) {

		ProjectUtil.currentlyExeTrigger = true;
	    try {
	
			List<String> idsProject = new List<String>();
			List<String> projectSharingNames = new List<String>();
			for (ProjectMember__c tm : Trigger.old) {
				idsProject.add(tm.Project__c);
				projectSharingNames.add('ProjectSharing' + tm.Project__c);
			}
		
			List<Group> groupProjectSharing = [select g.Id, g.Name from Group g where g.Name in:projectSharingNames limit 1000];
				 	
		    List<Project2__c> projectList = [select t.PublicProfile__c ,t.NewMemberProfile__c, t.Id, t.Name from Project2__c t where t.Id in: idsProject limit 1000];
		
			List<ProjectProfile__c> lstTp = [Select t.Id, t.Name, t.CreateProjectTasks__c, t.ManageProjectTasks__c from ProjectProfile__c t limit 1000];
			
			List<String> groupsNames = new List<String>();
			List<String> userIds = new List<String>();
			for (ProjectMember__c tm : Trigger.old) {
				groupsNames.add('Project' + tm.Project__c);
				userIds.add(tm.User__c);
			}
			
		//Delete subscription
			string pId=idsProject[0];
			List<ProjectSubscription__c> unsubscribe=[select id, ProjectTaskAssignedToMe__c, ProjectTaskAssignToMeChanged__c, ProjectTaskChanged__c, ProjectTaskDeleted__c, Project__c, User__c from ProjectSubscription__c where User__c in :userIds and Project__c =: pId limit 1000];
			if ( unsubscribe.size()>0)
				delete  unsubscribe;
								    
			List<Group> ManageQueueList = [ select Id, Name From Group where Name in: groupsNames and Type = 'Queue' order by Name limit 1000];
												
			List<GroupMember> gmList = [select Id, UserOrGroupId, GroupId from GroupMember where UserOrGroupId in:userIds and GroupId in: ManageQueueList limit 1000];
											
			List<GroupMember> gmAllList = [select gm.Id, UserOrGroupId, GroupId from GroupMember gm where gm.UserOrGroupId in: userIds limit 1000];
			
			List<String> gm = new List<String>();
			
			for (ProjectMember__c tm : Trigger.old) {
			
				//Get Group
				Group g = new Group();
				
				String groupName = 'ProjectSharing' + tm.Project__c;
				Boolean findGroup = false;
				Integer countGroup = 0;
				while (!findGroup && countGroup < groupProjectSharing.size()) {
					if (groupProjectSharing[countGroup].Name == groupName) {
						findGroup = true;
						g = groupProjectSharing[countGroup];	
					}
					countGroup++;
				}
				 
				if (g != null) {
					//Get Project
					Project2__c t = new Project2__c();			
					Boolean findTeam = false;
					Integer countTeam = 0;
					while (!findTeam && countTeam < projectList.size()) {
						if (projectList[countTeam].Id == tm.Project__c) {
							findTeam = true;
							t = projectList[countTeam];
						}
						countTeam++;	
					}	
					
					//If project access is private, delete group member.
					ProjectProfile__c tp = new ProjectProfile__c();				
					Boolean findProfile = false;
					Integer countProfile = 0;
					while (!findProfile && countProfile < lstTp.size()) {
						if (lstTp[countProfile].Id == tm.Profile__c) {
							findProfile = true;	
							tp = lstTp[countProfile];
						}
						countProfile++;
					}
					
					List<Group> ManageQueue = new List<Group>(); 
					Map<String,Group> groupIdsMap = new Map<String,Group>();
					for (Group iterQueue : ManageQueueList) {
						if (iterQueue.Name.indexOf(tm.Project__c) != -1) {
							ManageQueue.add(iterQueue);
							groupIdsMap.put(iterQueue.Id, iterQueue);
						}
					}
					
					for (GroupMember iterGroupMember : gmList) {
						if (iterGroupMember.UserOrGroupId == tm.User__c && groupIdsMap.containsKey(iterGroupMember.GroupId)) {
							gm.add(iterGroupMember.id);	
						}	
					}
					
					if(t.PublicProfile__c == null && t.NewMemberProfile__c == null){			
						Boolean findGM = false;
						Integer countGM = 0;
						while (!findGM && countGM < gmAllList.size()) {
							if (gmAllList[countGM].GroupId == g.Id && gmAllList[countGM].UserOrGroupId == tm.User__c) {
								findGM = true;	
								gm.add(gmAllList[countGM].id);
							}
							countGM++;
						}
					}
				}
			}
			System.debug( '===>>>> ' + gm);
			projectUtil.deleteGroupMembers(gm);
		
	    } finally {
	        ProjectUtil.currentlyExeTrigger = false;
	    }

	ProjectUtil.currentlyExeTrigger = false;

    }
	
}