trigger ProjectMemberAfterInsert on ProjectMember__c (after insert) 
{
    if (!ProjectUtil.currentlyExeTrigger) {
    	ProjectUtil.currentlyExeTrigger = true;
    	try {
			// Send email to subscribers members
			List<String> lstPMId = new List<String>();
		    for ( ProjectMember__c pM : Trigger.new){
		    	lstPMId.add(pM.id);
		    }
			ProjectSubscribersEmailServices mail = ProjectSubscribersEmailServices.getInstance();
		    mail.sendMemberJoinLeave( lstPMId, 'join' );
		    
            List<String> idsTeam = new List<String>();
            List<String> idsProfile = new List<String>();
            List<String> groupsNames = new List<String>();
            for (ProjectMember__c pm : Trigger.new) {
                groupsNames.add('Project' + pm.Project__c);
                groupsNames.add('ProjectSharing' + pm.Project__c);
                idsTeam.add(pm.Project__c);
                idsProfile.add(pm.Profile__c);    
            }
            
            List<Project2__c> teamList = [select id, name, PublicProfile__c, NewMemberProfile__c 
            								from Project2__c 
            								where id in: idsTeam
            								limit 1000];
            								
            List<Group> ManageQueueList = [select Id, Name 
            								From Group 
            								where Name in: groupsNames
            								limit 1000];
            
            List<ProjectProfile__c> tpList = [select t.Id, t.Name, t.CreateProjectTasks__c, t.ManageProjectTasks__c 
            									from ProjectProfile__c t  
            									where t.Id in:idsProfile
            									limit 1000];
            
            for(ProjectMember__c tm : Trigger.new) {
                //Get Team Sharing Group
                String groupName = 'ProjectSharing' + tm.Project__c;
                Group g;
                Boolean findTSG = false;
                Integer countTSG = 0;
                while (!findTSG && countTSG < ManageQueueList.size()) {
                    if (ManageQueueList[countTSG].Name == groupName) {
                        findTSG = true;
                        g = ManageQueueList[countTSG];
                    }
                    countTSG++; 
                }
                
                //Get Project
                Project2__c t;
                Boolean findTeam = false;
                Integer countTeam = 0;
                while (!findTeam && countTeam < teamList.size()) {
                    if (teamList[countTeam].Id == tm.Project__c) {
                        findTeam = true;
                        t = teamList[countTeam];    
                    }
                    countTeam++;    
                }
                
                // ### Determine Project access level ###
                if(t.PublicProfile__c == null && t.NewMemberProfile__c == null){
                    //If project is private
                    GroupMember gm = new GroupMember();
                    gm.GroupId = g.Id;
                    gm.UserOrGroupId = tm.User__c;
                    insert gm;  
                }
                
                // Determine Different Queue Additions
                //////////////////////////////////////
                List<GroupMember> groupMembers = new List<GroupMember>();
                ProjectProfile__c tp = new ProjectProfile__c();
                Boolean findProfile = false;
                Integer countProfile = 0;
                while (!findProfile && countProfile < tpList.size()) {
                    if (tpList[countProfile].id == tm.Profile__c) {
                        findProfile = true; 
                        tp = tpList[countProfile];
                    }
                    countProfile++; 
                }
                
                if (findProfile) {
        
                    if(tp.ManageProjectTasks__c || tp.CreateProjectTasks__c){
                        
                        String queueName = 'Project' + tm.Project__c;
                        Boolean findGroup = false;
                        Integer countGroup = 0;
                        
                        while (!findGroup && countGroup < ManageQueueList.size()) {
                            if (ManageQueueList[countGroup].Name == queueName) {
                                findGroup = true;
                                GroupMember gm = new GroupMember();
                                gm.UserOrGroupId = tm.User__c;
                                gm.GroupId = ManageQueueList[countGroup].Id;
                                groupMembers.add(gm);   
                            }
                            countGroup++;   
                        }
                    }
                    
                    insert groupMembers;
                    
                    /**
                    * Insert into the Sharing Table 
                    */
                    ProjectMember__Share tms = new ProjectMember__Share();
                    tms.ParentId = tm.Id;
                    tms.UserOrGroupId = g.Id;
                    tms.AccessLevel = 'Read';
                    tms.RowCause = 'Manual';
                    insert tms; 
                
                }
            }   
        } 
        finally{
    		ProjectUtil.currentlyExeTrigger = false;
        }
    }
}