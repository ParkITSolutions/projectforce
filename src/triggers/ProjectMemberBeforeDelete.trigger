trigger ProjectMemberBeforeDelete on ProjectMember__c (before delete){
    if (!ProjectUtil.currentlyExeTrigger){

		ProjectUtil.currentlyExeTrigger = true;
	    try{
			// Send email to subscribers members
			ProjectSubscribersEmailServices pEmail = new ProjectSubscribersEmailServices();
			List<String> lstPMId = new List<String>();
		    for ( ProjectMember__c pM : Trigger.old ){
		    	lstPMId.add(pM.id);
		    }
		    
		    pEmail.sendMemberJoinLeave( lstPMId, 'leave' );
	    }finally{
	        ProjectUtil.currentlyExeTrigger = false;
	    }
		ProjectUtil.currentlyExeTrigger = false;
    }
}