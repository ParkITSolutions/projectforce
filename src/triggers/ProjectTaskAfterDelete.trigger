trigger ProjectTaskAfterDelete on ProjectTask__c (after delete) {
	//Sets flag for deleting children Tasks
	ProjectUtil.setFlagValidationParentTask(false);
	delete ProjectUtil.childrenTaskToDelete;
	ProjectUtil.setFlagValidationParentTask(true);
	
	if(ProjectUtil.getFlagValidationParentTask()){
		Set<Id> parIds = new Set<Id>();
		for(ProjectTask__c pt : Trigger.old){
			if(!Trigger.oldMap.containsKey(pt.ParentTask__c)){
				parIds.add(pt.ParentTask__c);
			}
		}
		
		ParentTask parent = new ParentTask();
		parent.setProjectId(Trigger.old.get(0).Project__c);
		for(ProjectTask__c tsk : [select Id, Duration__c, DurationUI__c, Indent__c, ParentTask__c, PercentCompleted__c,  Project__c,  StartDate__c, EndDate__c from ProjectTask__c where ParentTask__c in : parIds limit 1000]){
			parent.checkParentTask(tsk);
		}
	}
	
}