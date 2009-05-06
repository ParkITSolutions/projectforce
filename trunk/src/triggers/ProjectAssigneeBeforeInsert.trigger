trigger ProjectAssigneeBeforeInsert on ProjectAssignee__c (before insert) {
  List <ProjectAssignee__c> m = Trigger.new;
  String TaskId=m.get(0).ProjectTask__c;
	
     Map<String,ProjectAssignee__c> AuxMap = new Map<String,ProjectAssignee__c>();

	 for (ProjectAssignee__c iter :[Select p.User__c From ProjectAssignee__c p where projectTask__c =: TaskId]) {
		AuxMap.put(iter.User__c, iter);
	 }	
	
	 ProjectUtil.BaseMap=AuxMap; 	

}