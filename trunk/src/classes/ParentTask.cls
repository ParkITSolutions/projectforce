/**
*@author: Matias Menafra - Sep 1, 2009
*/
public class ParentTask {
	
	public List<ProjectTask__c> updates = new List<ProjectTask__c>();
	
	/**
	* Class constructor
	*/
	public ParentTask (){
		
	}
	
	public List<ProjectTask__c> getTaskChildren(ProjectTask__c task){
		
		List<ProjectTask__c> children = [select Id, StartDate__c, EndDate__c, PercentCompleted__c, ParentTask__c from ProjectTask__c where ParentTask__c =: task.Id];
		return children;
		
	}
	
	public void checkParentTask(ProjectTask__c task){ 
		
		if(task.ParentTask__c != null){
			ProjectTask__c parentTask = [select Id, StartDate__c, EndDate__c, PercentCompleted__c from ProjectTask__c where Id =: task.ParentTask__c];
			ProjectTask__c auxTask    = new ProjectTask__c();	
			auxTask.StartDate__c      = null;
			auxTask.EndDate__c 		  = null;
			Double percentage		  = 0.0;
			
			List<ProjectTask__c> children = this.getTaskChildren(parentTask);
			for(ProjectTask__c nTask : children) {
				if(auxTask.StartDate__c != null){
					if(nTask.StartDate__c <= auxTask.StartDate__c){
						auxTask.StartDate__c = nTask.StartDate__c;
					}
				}
				else{
					auxTask.StartDate__c = nTask.StartDate__c;
				}
				if(auxTask.EndDate__c != null){
					if(nTask.EndDate__c >= auxTask.EndDate__c){
						auxTask.EndDate__c = nTask.EndDate__c;
					}
				}
				else{
					auxTask.EndDate__c = nTask.EndDate__c;
				}
				
				if(nTask.PercentCompleted__c != null){
					System.debug('>>>>>>>>>>  Before PERCENTAGE   '+ percentage+'  >>>>>>>>>>>>');
					percentage = percentage + nTask.PercentCompleted__c;
					System.debug('>>>>>>>>>>   PERCENTAGE   '+ percentage+'  >>>>>>>>>>>>');
				}
				
			}
			
			parentTask.StartDate__c = auxTask.StartDate__c;
			parentTask.EndDate__c   = auxTask.EndDate__c;
			if(percentage != 0.0){
				parentTask.PercentCompleted__c = percentage / children.size();
			}
			ProjectUtil.setFlagValidationParentTask(false);
			this.updates.add(parentTask);
			ProjectUtil.setFlagValidationParentTask(true);
			System.debug('>>>>>>>>>>   RUN  >>>>>>>>>>>>');
			System.debug('childs :'+children.size());
			System.debug('percentage :'+percentage);
			System.debug('Satrt :'+parentTask.StartDate__c);
			System.debug('End : '+parentTask.EndDate__c);
			System.debug('%%'+parentTask.PercentCompleted__c);
			System.debug('---------------------------------------');
			this.checkParentTask(parentTask);
		}
		else{
			update this.updates;
			System.debug('-------------->>>>>>>>>>>>>>>>>>>> UPDATING  '+ this.updates.size());
		}
	}
}