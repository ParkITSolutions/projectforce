trigger ProjectAfterDelete on Project2__c (after delete) {
	
			
			List<Group> projectq = [select g.Id, g.Name from Group g where g.Name like 'Project%' or g.Name like 'projectSharing%'];
				
			for(Project2__c delProj : trigger.old){
				
				String projectQueue = 'Project' + delProj.Id;
				String projectSharing = 'projectSharing' + delProj.Id;
				
				List<Group> groupDel = new List<Group>();
				for (Group iterGroup: projectq) {
					if (iterGroup.Name == projectQueue || iterGroup.Name == projectSharing) {
						groupDel.add(iterGroup);	
					}	
				}
				delete groupDel;
			}

			
}