trigger ProjectTaskBeforeUpdate on ProjectTask__c (before update) {
	
	Map<String,ProjectTask__c> AuxMap = new Map<String,ProjectTask__c>();
 	List<Id> tasksInTrrNewIds = new List<Id>();
	List<ProjectTask__c> parentTasks = new List<ProjectTask__c>();

	for( ProjectTask__c pTN : Trigger.new){
 		tasksInTrrNewIds.add( pTN.ParentTask__c );
 		if(pTn.Milestone__c){
 			
 			if(pTn.EndDate__c != null)
			pTn.EndDate__c.addError('The Milestones can not have End Date.');
 			
 			if(pTn.ParentTask__c != null)
			pTn.ParentTask__c.addError('The Milestones can not have Parent Task.');
 			
 		}
     }

	parentTasks = [ select id, Project__c from ProjectTask__c where id in: tasksInTrrNewIds ];
	
    ProjectTask__c tempPTOld = new ProjectTask__c();
    ProjectTask__c tempPTNew = new ProjectTask__c();
    for( Integer k = 0; k < Trigger.old.size(); k++ ){

    	tempPTOld = Trigger.old.get( k );
    	tempPTNew = Trigger.new.get( k );		
    	
    	if( tempPTOld.Project__c != tempPTNew.Project__c)
    	tempPTNew.addError( 'You can not modify project.');

		if( parentTasks.size() > 0 )
	    	if( tempPTOld.Project__c != parentTasks.get( k ).Project__c )
	    	tempPTNew.addError( 'Invalid parent task value.');

   	 	AuxMap.put( tempPTOld.id, tempPTOld );
    } 
    ProjectUtil.BaseMap=AuxMap;    
}