trigger ProjectAfterUpdate on Project2__c (after update) {
			
			List<String> groupsNames = new List<String>();
			List<String> idsProject = new List<String>();
			for (Project2__c iterProj : Trigger.new) {
				groupsNames.add('ProjectSharing' + iterProj.Id);
				idsProject.add(iterProj.Id);
			}
			List<Group> groupList = [select id, name from Group where name in:groupsNames];
			List<GroupMember> groupMemberList = [select UserOrGroupId, GroupId, id from GroupMember where GroupId in:groupList];
			List<Group> go = [Select g.Type, g.Name from Group g where Type = 'Organization'];
			List<ProjectMember__c> projectMemberList = [select project__c, id, User__c from ProjectMember__c where project__c in:idsProject];
			
            //Customer Portal Group            
            List<Group> portalGroup = new List<Group>();
           	portalGroup = [Select g.Type, g.Name from Group g where Type = 'AllCustomerPortal'];

            //Partner Portal Group
            List<Group> partnerGroup = new List<Group>();
           	partnerGroup = [Select g.Type, g.Name from Group g where Type = 'PRMOrganization'];	
            			
			for (Integer it = 0; it < Trigger.new.size(); it++) {
				
				Project2__c oldProj = Trigger.old[it];
				Project2__c newProj = Trigger.new[it];
				
				//If old team was open or close
				if(oldProj.PublicProfile__c != null || oldProj.NewMemberProfile__c != null){

					if(newProj.PublicProfile__c == null && newProj.NewMemberProfile__c == null){

						String groupName = 'projectSharing' + newProj.Id;
						Group projectGroup;
						Boolean findGroup = false;
						Integer countGroup = 0;
						while (!findGroup && countGroup < groupList.size()) {
							if (groupList[countGroup].Name == groupName) {
								findGroup = true;	
								projectGroup = groupList[countGroup];
							}
							else {
								countGroup++;
							}	
						}
						
						//Delete Everyone Member
						Boolean findGM = false;
						Integer countGM = 0;
						GroupMember gm;
						
						while (!findGM && countGM < groupMemberList.size()) {

							if (groupMemberList[countGM].UserOrGroupId == go[0].id && groupMemberList[countGM].GroupId == projectGroup.Id) {
								findGM = true;
								gm = groupMemberList[countGM];
								List<String> groupMembersIds = new List<String>();
								groupMembersIds.add(gm.id);
								ProjectUtil.deleteGroupMembers(groupMembersIds);
							}
							else {
								countGM++;	
							}	
						}
						
						if( portalGroup.size() > 0){
							for( GroupMember j: groupMemberList ){
								if( j.UserOrGroupId == portalGroup[ 0 ].Id && j.GroupId == projectGroup.Id ){
									List<String> groupMembersIds = new List<String>();
									groupMembersIds.add( j.Id );
									ProjectUtil.deleteGroupMembers(groupMembersIds);
								}	
							}
						}
						
						if( partnerGroup.size() > 0){
							for( GroupMember j : groupMemberList ){
								if( j.UserOrGroupId == partnerGroup[ 0 ].Id && j.GroupId == projectGroup.Id ){
									List<String> groupMembersIds = new List<String>();
									groupMembersIds.add( j.Id );
									ProjectUtil.deleteGroupMembers(groupMembersIds);
								}	
							}
						}

						//Create GroupMember for all Project Members
						List<GroupMember> groupMembers = new List<GroupMember>();
						for (ProjectMember__c iterMember : projectMemberList) {
							if (iterMember.Project__c == newProj.Id) {	
								GroupMember newGroupMember = new GroupMember();
								newGroupMember.GroupId = projectGroup.Id;
								newGroupMember.UserOrGroupId = iterMember.User__c;
								groupMembers.add(newGroupMember); 
							}
						}
						insert groupMembers;
					}else{
						//If Customer Portal group exist add GroupMember
						List<GroupMember> gm2 = new List<GroupMember>();
						Group instance = new Group();
						if(portalGroup.size() > 0 ){
							GroupMember gmPortal = new GroupMember();
							// Get GroupMember if exists
							instance = [ SELECT Id FROM Group WHERE Name =: groupsNames[ it ] LIMIT 1 ];
							gm2 = [ SELECT Id FROM GroupMember WHERE GroupId =: instance.Id AND UserOrGroupId =: portalGroup[0].Id ];
							
							if(newProj.AllowCustomerUsers__c){
								if( gm2.size() == 0 ){					
				                    gmPortal.GroupId = instance.Id;
				                    gmPortal.UserOrGroupId = portalGroup[0].Id;
				                    insert gmPortal;
								} 
							}else if( gm2.size() > 0){
								List<String> groupMembersIds = new List<String>();
								groupMembersIds.add(gm2[0].id);
								ProjectUtil.deleteGroupMembers(groupMembersIds);												
							}
						}                
	
						//If Partner Portal group exist add GroupMember
						if(partnerGroup.size() > 0 ){
								
							GroupMember gmPortal = new GroupMember();
							// Get GroupMember if exists
							instance = [ SELECT Id FROM Group WHERE Name =: groupsNames[ it ] LIMIT 1 ];
							gm2 = [ SELECT Id FROM GroupMember WHERE GroupId =: instance.Id AND UserOrGroupId =: partnerGroup[0].Id ];
							
							if(newProj.AllowPartnerUsers__c){
								if( gm2.size() == 0 ){					
				                    gmPortal.GroupId = instance.Id;
				                    gmPortal.UserOrGroupId = partnerGroup[0].Id;
				                    insert gmPortal;
								}
							}else if( gm2.size() > 0){
								List<String> groupMembersIds = new List<String>();
								groupMembersIds.add(gm2[0].id);
								ProjectUtil.deleteGroupMembers(groupMembersIds);
							}											
						}else{
							
						}					
					}
				}else{

					if(newProj.PublicProfile__c != null || newProj.NewMemberProfile__c != null){
						
						String groupName = 'ProjectSharing' + newProj.Id;
						Group projectGroup;
						Boolean findGroup = false;
						Integer countGroup = 0;
						while (!findGroup && countGroup < groupList.size()) {
							if (groupList[countGroup].Name == groupName) {
								findGroup = true;	
								projectGroup = groupList[countGroup];
							}
							else {
								countGroup++;
							}	
						}				
						
						//Delete all GroupMembers
						Boolean findGM = false;
						Integer countGM = 0;
						List<String> groupMembersIds = new List<String>();
						for (GroupMember groupMemberIter : groupMemberList) {
							if (groupMemberIter.GroupId == projectGroup.Id) {
								groupMembersIds.add(groupMemberIter.id);
							}	
						}
						ProjectUtil.deleteGroupMembers(groupMembersIds);
						
						//Create Everyone Member
						GroupMember newGroupMember = new GroupMember();
						newGroupMember.GroupId = projectGroup.Id;
						newGroupMember.UserOrGroupId = go[0].Id;
						insert newGroupMember;

						//If Customer Portal group exist add GroupMember
						if(newProj.AllowCustomerUsers__c){
							if(portalGroup.size() > 0 ){
								GroupMember gmPortal = new GroupMember();
			                    gmPortal.GroupId = projectGroup.Id;
			                    gmPortal.UserOrGroupId = portalGroup[0].Id;
			                    insert gmPortal;
							}  
						}              
	
						//If Partner Portal group exist add GroupMember
						if(newProj.AllowPartnerUsers__c){
							if(partnerGroup.size() > 0 ){
								GroupMember gmPortal = new GroupMember();
			                    gmPortal.GroupId = projectGroup.Id;
			                    gmPortal.UserOrGroupId = partnerGroup[0].Id;
			                    insert gmPortal;
							}
						}
					}
				}
			}
			
}