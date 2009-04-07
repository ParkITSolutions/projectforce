trigger ProjectAfterInsert on Project2__c  (after insert) {	
    if (!ProjectUtil.currentlyExeTrigger) {
        try {
            ProjectProfile__c defaultProfile = [select Id from ProjectProfile__c where Name = 'Project Administrator' limit 1];
            //Organizatrion Group 
            List<Group> go = [Select g.Type, g.Name from Group g where Type = 'Organization'];

            //Customer Portal Group            
            List<Group> portalGroup = new List<Group>();
            if(ProjectCreateNewProjectController.getAllowCustomerStatic()) 
            portalGroup = [Select g.Type, g.Name from Group g where Type = 'AllCustomerPortal'];
	           
            //Partner Portal Group
            List<Group> partnerGroup = new List<Group>();
            if(ProjectCreateNewProjectController.getAllowPartnerStatic())
            partnerGroup = [Select g.Type, g.Name from Group g where Type = 'PRMOrganization'];
            
            
            // build for bulk
            Project2__c[] t = Trigger.new;
            
            for (Project2__c team : Trigger.new) {
                /**
                * Group List To Insert.
                */
                List<Group> newGroups = new List<Group>();
                
                /**
                * Create Sharing Group for current Team.
                */      
                Group g = new Group();
                g.Name = 'ProjectSharing' + team.Id;
                insert g;
                
                if(team.PublicProfile__c != null || team.NewMemberProfile__c != null){
                    
                    //Create GroupMember for everyone member
                    GroupMember gm = new GroupMember();
                    gm.GroupId = g.Id;
                    gm.UserOrGroupId = go[0].Id;
                    insert gm;
                    
					//If Customer Portal group exist add GroupMember
					if(portalGroup.size() > 0 ){
						GroupMember gmPortal = new GroupMember();
	                    gmPortal.GroupId = g.Id;
	                    gmPortal.UserOrGroupId = portalGroup[0].Id;
	                    insert gmPortal;
					}                

					//If Partner Portal group exist add GroupMember
					if(partnerGroup.size() > 0 ){
						GroupMember gmPortal = new GroupMember();
	                    gmPortal.GroupId = g.Id;
	                    gmPortal.UserOrGroupId = partnerGroup[0].Id;
	                    insert gmPortal;
					}  
                }   
                        
                /* ### Create Queues ###*/
                    
                // Create DiscussionForum Queue
                Group gdqw = new Group();
                gdqw.Type = 'Queue';
                gdqw.Name = 'Project' + team.Id;
                insert gdqw;
                
                String pQId = gdqw.id;
                
                ProjectUtil.insertQueueSObjects (pQId, team.Id );
                Project2__c tempTeam = [select ownerId, Id, Name from Project2__c where Id =: team.Id limit 1];
                tempTeam.ownerId = pQId;
                // We set this to true becuase we dont want all the minifeed triggers and update 
                // triggers firing off when all we want to do is update the owner id.
                ProjectUtil.currentlyExeTrigger = true;
                
                upsert tempTeam;                /*
		        // ### Allow SObjects to be managed by recently created queues ###
		        List<QueueSobject> sobjectsQueueAllowed = new List<QueueSobject>();
		        
		        // Project Tasks - assignees
		        QueueSobject allowAsignee = new QueueSobject(SobjectType = Schema.SObjectType.ProjectAssignee__c.getName() ,QueueId = pQId);
		        sobjectsQueueAllowed.add(allowAsignee);
		        
		        QueueSobject allowTasks = new QueueSobject(SobjectType = Schema.SObjectType.ProjectTask__c.getName() ,QueueId = pQId);
		        sobjectsQueueAllowed.add(allowTasks);
		        
		        QueueSobject allowProject = new QueueSobject(SobjectType = Schema.SObjectType.Project2__c.getName() ,QueueId = pQId);
		        sobjectsQueueAllowed.add(allowProject);
		       
		        QueueSobject allowProjectTaskPred = new QueueSobject(SobjectType = Schema.SObjectType.ProjectTaskPred__c.getName() ,QueueId = pQId);
		        sobjectsQueueAllowed.add(allowProjectTaskPred);
		        
		        QueueSobject allowProjectMembers = new QueueSobject(SobjectType = Schema.SObjectType.ProjectMember__c.getName() ,QueueId = pQId);
		        sobjectsQueueAllowed.add(allowProjectMembers);  
		        
		        // Insert all the allowed sobjects  
		        //Database.SaveResult[] lsr = Database.insert(sobjectsQueueAllowed);
				upsert sobjectsQueueAllowed;

                //Upsert Team owner
                Project2__c tempTeam = [select ownerId, Id, Name from Project2__c where Id =: team.Id limit 1];
                tempTeam.ownerId = pQId;
                // We set this to true becuase we dont want all the minifeed triggers and update 
                // triggers firing off when all we want to do is update the owner id.
                ProjectUtil.currentlyExeTrigger = true;
                
                update tempTeam;
                */
                ProjectUtil.currentlyExeTrigger = false;
                        
                // Create __Shared object for team
                Project2__Share teamS = new Project2__Share();
                teamS.ParentId = team.Id;
                teamS.UserOrGroupId = g.Id;
                teamS.AccessLevel = 'Read';
                teamS.RowCause = 'Manual';
                insert teamS;  
            
                // Create the first team member (the founder)
                /*
                ProjectMember__c firstTeamMember = new ProjectMember__c();
                firstTeamMember.User__c = Userinfo.getUserId();
                firstTeamMember.Name = UserInfo.getName();
                firstTeamMember.Project__c = team.Id;
                firstTeamMember.Profile__c = defaultProfile.Id;
                insert firstTeamMember;
                */
            }
        } finally {
            ProjectUtil.currentlyExeTrigger = false;
        }
    }
    else {
        ProjectProfile__c defaultProfile = [select Id from ProjectProfile__c where Name = 'Project Administrator' limit 1];
        for (Project2__c team : Trigger.new) {
            ProjectMember__c firstTeamMember = new ProjectMember__c();
            firstTeamMember.User__c = Userinfo.getUserId();
            firstTeamMember.Name = UserInfo.getName();
            firstTeamMember.Project__c = team.Id;
            firstTeamMember.Profile__c = defaultProfile.Id;
            insert firstTeamMember; 
        }
    }
}