trigger ProjectTaskBeforeDelete on ProjectTask__c (before delete) 
{
	// Send email to subscribers members
	ProjectSubscribersEmailServices pEmail = new ProjectSubscribersEmailServices();
	List<String> lstTasksId = new List<String>(); 
    for ( ProjectTask__c pT : Trigger.old ){
    	lstTasksId.add(pT.id);
    }
    
    pEmail.sendMailForTaskDeleted( lstTasksId );
    
    ProjectUtil.DeleteTaskMailSent=true;
    
	List<ProjectAssignee__c> projectAssigneeList = [Select Id from ProjectAssignee__c where ProjectTask__c in :Trigger.old  ];    	
	delete projectAssigneeList;
	
	List<ProjectTaskPred__c> projectTaskPredList = [select Id from ProjectTaskPred__c where Parent__c in : Trigger.old or Predecessor__c in : Trigger.old]; 
	delete projectTaskPredList;

	//Delete Attachments
	List<Attachment> attachs = [select Id from Attachment where parentId in : Trigger.old];
	delete attachs;

}