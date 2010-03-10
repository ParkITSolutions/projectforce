trigger ProjectTaskAfterDelete on ProjectTask__c (after delete) {
    //Sets flag for deleting children Tasks
    ProjectUtil.setFlagValidationParentTask(false);
    System.debug('XXX trigger- projtaskafterdel 0 , ProjectUtil.childrenTaskToDelete='+ProjectUtil.childrenTaskToDelete);
    delete ProjectUtil.childrenTaskToDelete;
    System.debug('XXX trigger- projtaskafterdel 1');
    ProjectUtil.setFlagValidationParentTask(true);
    System.debug('XXX trigger- projtaskafterdel 2');
    if(ProjectUtil.getFlagValidationParentTask() && !ProjectUtil.isTest){
        Set<Id> parIds = new Set<Id>();
        for(ProjectTask__c pt : Trigger.old){
            if(!Trigger.oldMap.containsKey(pt.ParentTask__c)){
                parIds.add(pt.ParentTask__c);
            }
        }
        System.debug('XXX trigger- projtaskafterdel 3');
        ParentTask parent = new ParentTask();
        System.debug('XXX trigger- projtaskafterdel 4');
        BigListOfTasks bigListOfTasks = new BigListOfTasks(Trigger.old.get(0).Project__c);
        System.debug('XXX trigger- projtaskafterdel 5, bigListOfTasks ='+bigListOfTasks);
        List<String> taskIds = new List<String>();
        System.debug('XXX trigger- projtaskafterdel 6, parIds='+parIds);
        
        
        for(ProjectTask__c tsk : [select Id, Duration__c, DurationUI__c, Indent__c, ParentTask__c, PercentCompleted__c,  Project__c,  StartDate__c, EndDate__c from ProjectTask__c where ParentTask__c in : parIds limit 1000]){
        	System.debug('XXX trigger- projtaskafterdel 7');
            taskIds.add(tsk.Id);
        }
        //call to @future method
        System.debug('XXX trigger- projtaskafterdel 8');
        if(taskIds.size() > 0){
            ParentTask.batchUpdateParentTask(taskIds);
        }
        System.debug('XXX trigger- projtaskafterdel 9');
    }
    
}