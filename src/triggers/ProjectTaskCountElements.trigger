trigger ProjectTaskCountElements on ProjectTask__c (after delete, after insert){
   
    Project2__c prjToUpdate;
    List<Project2__c> projectsToUpdate 	= new List<Project2__c>();
    List<Id> projectsToSearch 			= new List<Id>();
    Map<Id,List<ProjectTask__c>> projectsToTasks = new Map<Id,List<ProjectTask__c>>();
   	Map<Id,Project2__c> idsPrj = new Map<Id,Project2__c>(); 
    Set<Id> prjIds = new Set<Id>();
    
   	ProjectUtil.flags.put( 'deletingTaskOnly', true );
    if( trigger.isInsert ){
    	
        for( ProjectTask__c task : trigger.new ){
        	if( prjIds == null){
        		prjIds.add( task.Project__c );
        	}else if( !prjIds.contains( task.Project__c )){
        		prjIds.add( task.Project__c );
        	}
        }
    	
    	for( Project2__c p : [ select Id, Milestones__c, Tasks__c from Project2__c where Id in: prjIds ]){	
    		idsPrj.put( p.id, p );
    	}

        for( ProjectTask__c task : trigger.new ){
            
            prjToUpdate = idsPrj.get( task.Project__c );
            
            if( task.Milestone__c ){
            	prjToUpdate.Milestones__c = ( prjToUpdate.Milestones__c == null ) ? 1 : prjToUpdate.Milestones__c + 1; 
            }else{
            	prjToUpdate.Tasks__c = ( prjToUpdate.Tasks__c == null ) ? 1 : prjToUpdate.Tasks__c + 1;
            }
            
            idsPrj.put( prjToUpdate.id, prjToUpdate );
            
        }
        
        projectsToUpdate.addAll( idsPrj.values());
 	    
 	    if( projectsToUpdate.size() > 0){
	    	Database.update( projectsToUpdate );
	    }
    }
    
    if(( !ProjectUtil.flags.containsKey( 'DelAllTasks' ) || !ProjectUtil.flags.get( 'DelAllTasks' )) && trigger.isDelete ){    	
    	Integer tasks = 0;
        
        for( ProjectTask__c task : trigger.old ){
        	if( prjIds == null){
        		prjIds.add( task.Project__c );
        	}else if( !prjIds.contains( task.Project__c )){
        		prjIds.add( task.Project__c );
        	}
        }
    	
    	for( Project2__c p : [ select Id, Milestones__c, Tasks__c from Project2__c where Id in: prjIds ]){	
    		idsPrj.put( p.id, p );
    	}
    	
        for( ProjectTask__c task : trigger.old ){
			prjToUpdate = idsPrj.get( task.Project__c );
			if( task.Milestone__c ){
				if( prjToUpdate.Milestones__c > 0 ){
					prjToUpdate.Milestones__c -= 1;
				}
			}else{
				if( prjToUpdate.Tasks__c > 0 ){
					prjToUpdate.Tasks__c -= 1;
				}
			}
			
            idsPrj.put( prjToUpdate.id, prjToUpdate );
        }
        projectsToUpdate.addAll( idsPrj.values());
	    if( projectsToUpdate.size() > 0){
	    	Database.update( projectsToUpdate );
	    }
    }
   	ProjectUtil.flags.put( 'deletingTaskOnly', false );
    
}