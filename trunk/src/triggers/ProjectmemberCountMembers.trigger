trigger ProjectmemberCountMembers on ProjectMember__c ( after delete, after insert ){
    
	if( !ProjectUtil.flags.containsKey( 'firstMember' ) || ( ProjectUtil.flags.containsKey( 'firstMember' ) && !ProjectUtil.flags.get( 'firstMember' ))){
	    List<Project2__c> projectsToUpdate 	= new List<Project2__c>();
	    Project2__c prjTemp;
	    Set<Id> projectsToSearch 			= new Set<Id>();
	    Map<Id,Project2__c> projectsToMembers = new Map<Id,Project2__c>();
	    List<ProjectMember__c> actualTriggerList;
	    Integer plusThis = 0;
	    
	    if( trigger.isInsert ){
	    	actualTriggerList = trigger.new;
	    	plusThis = 1;
	    }
	    
	    if( trigger.isDelete ){
	    	actualTriggerList = trigger.old;
	    	plusThis = -1;
	    }	

        for( ProjectMember__c member : actualTriggerList ){
        	if( projectsToSearch == null || !projectsToSearch.contains( member.Project__c )){
	            projectsToSearch.add( member.Project__c );
        	}
        }

	    for( Project2__c p : [ SELECT Id, Members__c FROM Project2__c WHERE id in: projectsToSearch ]){
	    	projectsToMembers.put( p.id, p );
	    }

        for( ProjectMember__c member : actualTriggerList ){
        	prjTemp = projectsToMembers.get( member.Project__c );
        	prjTemp.Members__c += plusThis;
        	projectsToMembers.put( prjTemp.id, prjTemp );
        }
        
        projectsToUpdate.addAll( projectsToMembers.values());	        
	    Database.update( projectsToUpdate, false );
	}
}