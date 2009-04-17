trigger ProjectAfterDelete on Project2__c (after delete) {
	
	List<String> lstGN = new List<String>();
	for(Project2__c delProj : trigger.old){
		String projectQueue = 'Project' + delProj.Id;
		String projectSharing = 'ProjectSharing' + delProj.Id;
	    lstGN.add(projectQueue);
	    lstGN.add(projectSharing);
	}
	ProjectUtil.deleteGroup(lstGN);
		
}