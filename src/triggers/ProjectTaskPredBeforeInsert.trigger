trigger ProjectTaskPredBeforeInsert on ProjectTaskPred__c (before insert) {

	TaskDependencies td = new TaskDependencies();

	for(ProjectTaskPred__c p :  Trigger.new  ){
		td.InsertinfPred(p);
		td.updateNow();
	}
	
}