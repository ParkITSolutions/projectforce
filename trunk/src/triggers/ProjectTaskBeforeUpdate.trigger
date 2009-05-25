trigger ProjectTaskBeforeUpdate on ProjectTask__c (before update) {
	
	Map<String,ProjectTask__c> AuxMap = new Map<String,ProjectTask__c>();

    for ( ProjectTask__c pT : Trigger.old ){
   	 	AuxMap.put(pT.id,pT);
    } 
    ProjectUtil.BaseMap=AuxMap; 
    
    
    
}