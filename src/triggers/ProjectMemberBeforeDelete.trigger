trigger ProjectMemberBeforeDelete on ProjectMember__c (before delete){
    if (!ProjectUtil.currentlyExeTrigger){

		ProjectSubscribersEmailServices mail = ProjectSubscribersEmailServices.getInstance();
		ProjectUtil.currentlyExeTrigger = true;
	    try{
			List<String> lstPMId = new List<String>();
		    for ( ProjectMember__c pM : Trigger.old ){
		    	lstPMId.add(pM.id);
		    	
		    	//Logging Changes for Project Members
			    MemberActivity memberActivity = new MemberActivity( pM.Project__c, DateTime.now(), UserInfo.getUserId(), 'delete', pM );	
				memberActivity.log();
		    }
		    
		    mail.sendMemberJoinLeave( lstPMId, 'leave' );
	    }finally{
	        ProjectUtil.currentlyExeTrigger = false;
	    }
		ProjectUtil.currentlyExeTrigger = false;
    }
}