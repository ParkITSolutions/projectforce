trigger ProjectAssigneeAfterInsert on ProjectAssignee__c ( after insert ){
	
	List<String> assignees = new List<String>();

	try{
        
  		List<String> teamSharingGroupNames = new List<String>();		
		for( ProjectAssignee__c p : Trigger.new ){
			teamSharingGroupNames.add( 'ProjectSharing' + p.Project__c );
			assignees.add( p.id );
		}
		
		Map<String, Id> teamMap = new Map<String, Id>();					
		for( Group g: [select id, name from Group where Name in: teamSharingGroupNames] ){
			teamMap.put( g.Name, g.Id );
		}
		
		List<ProjectAssignee__Share> assignee = new List<ProjectAssignee__Share>();
		
		for( ProjectAssignee__c m : Trigger.new ){
			
			ProjectAssignee__Share p = new ProjectAssignee__Share();
			p.ParentId 		= m.Id;							
			p.UserOrGroupId = teamMap.get( 'ProjectSharing' + m.Project__c );
		    p.AccessLevel 	= 'Read';
		    p.RowCause 		= 'Manual';
		    assignee.add( p );
		}

		//Insert share objects
		insert assignee;
		
		/*
		Email services have been disabled
		//Send e-mail notifications
		ProjectSubscribersEmailServices mail = ProjectSubscribersEmailServices.getInstance();
		mail.sendMailForTaskAssigned( assignees );
		*/
		
	}
	catch( Exception e ){
		
	}
}