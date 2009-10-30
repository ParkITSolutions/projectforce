trigger ProjectMemberBeforeDelete on ProjectMember__c (before delete){
    if (!ProjectUtil.currentlyExeTrigger){

		ProjectUtil.currentlyExeTrigger = true;
	    try{
			List<String> lstPMId = new List<String>();
		    for ( ProjectMember__c pM : Trigger.old ){
		    	lstPMId.add(pM.id);
		    }
		    
		    ProjectSubscribersEmailServices.sendMemberJoinLeaveFuture( lstPMId, 'leave' );
	    }finally{
	        ProjectUtil.currentlyExeTrigger = false;
	    }
		ProjectUtil.currentlyExeTrigger = false;
    }
}