trigger ProjectTaskAfterDelete on ProjectTask__c (after delete) {
	
	ParentTask parent = new ParentTask(); 
	parent.setProjectId(Trigger.old.get(0).Project__c);
	Map<Id,ProjectTask__c> tasks = new Map<Id,ProjectTask__c>();
	for( ProjectTask__c tsk : Trigger.old){
		tasks.put(tsk.Id, tsk);
	}
	
	for(ProjectTask__c tsk2 : tasks.values()){
		if(tasks.get(tsk2.ParentTask__c) != null){
			//if(tsk2.ParentTask__c !=  null){
				parent.checkParentTask(tsk2);
			//}
		}
	}
	
}