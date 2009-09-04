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
    
	List<ProjectAssignee__c> projectAssigneeList = new List<ProjectAssignee__c>();
	for( ProjectAssignee__c pa : [Select Id from ProjectAssignee__c where ProjectTask__c in :Trigger.old limit 1000])
		projectAssigneeList.add(pa);
	delete projectAssigneeList;
	
	List<ProjectTaskPred__c> projectTaskPredList = new List<ProjectTaskPred__c>();
	for( ProjectTaskPred__c ptp : [select Id from ProjectTaskPred__c where Parent__c in : Trigger.old or Predecessor__c in : Trigger.old limit 1000])
		projectTaskPredList.add( ptp );
	delete projectTaskPredList;

	//Delete Attachments
	List<Attachment> attachs = new List<Attachment>();
	for( Attachment a : [select Id from Attachment where parentId in : Trigger.old limit 1000])
		attachs.add( a );
	delete attachs;
	
	List<ProjectTask__c> children = new List<ProjectTask__c>();
	for(ProjectTask__c t : [select Id from ProjectTask__c where ParentTask__c in : Trigger.old limit 1000]){
		children.add(t);
	}
	ProjectUtil.setFlagValidationParentTask(false);
	delete children;
	ProjectUtil.setFlagValidationParentTask(true);
	
}