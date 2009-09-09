trigger ProjectTaskAfterDelete on ProjectTask__c (after delete) {
	
	Map<Id,ProjectTask__c> taskIds = new Map<Id,ProjectTask__c>();
	for(ProjectTask__c  tsk : Trigger.old){
		taskIds.put(tsk.Id, tsk);
	}
	List<ProjectTask__c> children = new List<ProjectTask__c>();
	for(ProjectTask__c t : [select Id, Duration__c, DurationUI__c, Indent__c, ParentTask__c, PercentCompleted__c,  Project__c,  StartDate__c, EndDate__c from ProjectTask__c where ParentTask__c in : taskIds.values() limit 1000]){
		if(!taskIds.containsKey(t.Id)){
			children.add(t);
		}
	}
	ProjectUtil.setFlagValidationParentTask(false);
	delete children;
	ProjectUtil.setFlagValidationParentTask(true);
	
	if(ProjectUtil.getFlagValidationParentTask()){
		Set<Id> parIds = new Set<Id>();
		List<ProjectTask__c> tasks = new List<ProjectTask__c>();
		for(ProjectTask__c pt : Trigger.old){
			if(!Trigger.oldMap.containsKey(pt.ParentTask__c)){
				parIds.add(pt.ParentTask__c);
				tasks.add(pt);
			}
		}
		
		ParentTask parent = new ParentTask();
		parent.setProjectId(Trigger.old.get(0).Project__c);
		for(ProjectTask__c tsk : [select Id, Duration__c, DurationUI__c, Indent__c, ParentTask__c, PercentCompleted__c,  Project__c,  StartDate__c, EndDate__c from ProjectTask__c where ParentTask__c in : parIds limit 1000]){
			parent.checkParentTask(tsk);
		}
	}
	
	
}