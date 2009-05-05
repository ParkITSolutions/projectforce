trigger ProjectAssigneeBeforeInsert on ProjectAssignee__c (before insert) {
  if (ApexPages.currentPage()!=null) {
     String TaskId = ApexPages.currentPage().getParameters().get('task');	
	
     Map<String,ProjectAssignee__c> AuxMap = new Map<String,ProjectAssignee__c>();
	 //Map<String,ProjectAssignee__c> AuxMap=[Select p.User__c From ProjectAssignee__c p where projectTask__c =: TaskId];

	 for (ProjectAssignee__c iter :[Select p.User__c From ProjectAssignee__c p where projectTask__c =: TaskId]) {
		AuxMap.put(iter.User__c, iter);
	 }	
	
	 ProjectUtil.BaseMap=AuxMap; 	
  	
  	
  	
  }




}