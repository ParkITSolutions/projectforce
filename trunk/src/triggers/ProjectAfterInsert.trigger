trigger ProjectAfterInsert on Project2__c bulk(after insert) {
		try {	
				
			List<Group> go = [Select g.Type, g.Name from Group g where Type = 'Organization'];
			
            //Customer Portal Group
            //List<Group> portalGroup = new List<Group>();
            //portalGroup = [Select g.Type, g.Name from Group g where Type = 'AllCustomerPortal'];

            //Customer Portal Group            
            List<Group> portalGroup = new List<Group>();
            if(ProjectsCreateNewProjectController.getAllowCustomerStatic()) 
            portalGroup = [Select g.Type, g.Name from Group g where Type = 'AllCustomerPortal'];
	           
            //Partner Portal Group
            List<Group> partnerGroup = new List<Group>();
            if(ProjectsCreateNewProjectController.getAllowPartnerStatic())
            partnerGroup = [Select g.Type, g.Name from Group g where Type = 'PRMOrganization'];
                        			
			// build for bulk
			Project2__c[] p = Trigger.new;
			
			for (Project2__c proj : Trigger.new) {
				/**
				* Group List To Insert.
				*/
				List<Group> newGroups = new List<Group>();
				
				/**
				* Create Sharing Group for current Team.
				*/		
				Group g = new Group();
				g.Name = 'projectSharing' + proj.Id;
				insert g;
				
				if(proj.PublicProfile__c != null || proj.NewMemberProfile__c != null){
                    GroupMember gm = new GroupMember();
                    gm.GroupId = g.Id;
                    gm.UserOrGroupId = go[0].Id;
                    insert gm;
                    
                    //If Customer Portal group exist a to GroupMember
                    if(portalGroup.size() > 0){
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
				// Create Project Queue
				Group gdqproj = new Group();
				gdqproj.Type = 'Queue';
				gdqproj.Name = 'Project' + proj.Id;
				insert gdqproj;
				
				String projectQueueId = gdqproj.id;
				
                // ### Allow SObjects to be managed by recently created queues ###
              
              	ProjectUtil.insertQueueSObjects(projectQueueId,proj.id);
                			 	
			   	/**
				* Create __Shared object for team
				*/
				Project2__Share projectS = new Project2__Share();
				projectS.ParentId = proj.Id;
				projectS.UserOrGroupId = g.Id;
			    projectS.AccessLevel = 'Read';
			    projectS.RowCause = 'Manual';
			    insert projectS;			    
			    
				/**
				* Create the first project member (the founder)
				*/
				ProjectMember__c firstProjectMember = new ProjectMember__c();
				firstProjectMember.User__c = Userinfo.getUserId();
				firstProjectMember.Name = UserInfo.getName();
				firstProjectMember.Project__c = proj.Id;
				insert firstProjectMember;
	
			} 
		}finally {
				
	        	
		}
	
	
}