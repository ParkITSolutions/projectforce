trigger ProjectTaskBeforeDelete on ProjectTask__c (before delete){
    
    //Creates list of Task Ids to use in query for mass removal
    //and Creates a List for email sending to subscribirs
    List<String>   taskLst = new List<String>();
    Map<Id,ProjectTask__c> taskIds = new Map<Id,ProjectTask__c>();
    for( ProjectTask__c  tsk : Trigger.old ){
        taskIds.put( tsk.Id, tsk );
        taskLst.add( tsk.Id);
    }
    /*
    //Creates class to call method for sending emails 
    ProjectSubscribersEmailServices mail = ProjectSubscribersEmailServices.getInstance();
    mail.sendMailForTaskDeleted( taskLst );
    
    ProjectUtil.DeleteTaskMailSent = true;
    */
    
    //Deletes all Task Assignees 
    List<ProjectAssignee__c> projectAssigneeList = new List<ProjectAssignee__c>();
    for( ProjectAssignee__c pa : [Select Id from ProjectAssignee__c where ProjectTask__c in : Trigger.old limit 1000])
        projectAssigneeList.add(pa);
    delete projectAssigneeList;
    
    //Deletes All task links between tasks
    List<ProjectTaskPred__c> projectTaskPredList = new List<ProjectTaskPred__c>();
    for( ProjectTaskPred__c ptp : [select Id from ProjectTaskPred__c where Parent__c in : Trigger.old or Predecessor__c in : Trigger.old limit 1000])
        projectTaskPredList.add( ptp );
    delete projectTaskPredList;

    //Delete Attachments
    List<Attachment> attachs = new List<Attachment>();
    for( Attachment a : [select Id from Attachment where parentId in : Trigger.old limit 1000])
        attachs.add( a );
    delete attachs;
    
    //Add to children List all childs for later deletion
    ProjectUtil.childrenTaskToDelete = new List<ProjectTask__c>();
    
    if( ProjectUtil.getFlagValidationParentTask() ){
	    //Gets all tasks which are children from the Task we are Deleting
	    for( ProjectTask__c t : [select Id, Duration__c, DurationUI__c, Indent__c, ParentTask__c, PercentCompleted__c,  Project__c,  StartDate__c, EndDate__c from ProjectTask__c where ParentTask__c in : taskIds.values() limit 1000] ){
	        //if same task already in Trigger.old doesn't add to children List for removal
	        if( !taskIds.containsKey( t.Id ) ){
	            ProjectUtil.childrenTaskToDelete.add( t );
	        }
	    }
    }
}