/**
*@author: Matias Menafra - Sep 1, 2009
*/
public class ParentTask {
	
	public Map<Id,ProjectTask__c> updates = new Map<Id,ProjectTask__c>();
	public BigListOfTask taskList;
	
	/**
	* Class constructor
	*/
	public ParentTask (){
	}
	
	public void setProjectId (String projectId){ 
		this.taskList = new BigListOfTask(projectId);
	}
	
	public Double setTaskIndent(ProjectTask__c task){
		
		if(task.ParentTask__c != null){
			ProjectTask__c parentTask = this.taskList.getById(task.ParentTask__c);									
			return ParentTask.Indent__c + 1.0;
		}
		else
			return	0.0;		
	}
	
	public Boolean taskHasChildren(ProjectTask__c task){
		List<ProjectTask__c> children = this.taskList.getByParentId(task.Id);
		if(children.size() > 0){
			return true;
		}
		else{
			return false;		
		}
	}
	
	public List<ProjectTask__c> getTaskChildren(ProjectTask__c task, ProjectTask__c hijo){
		
		List<ProjectTask__c> children = this.taskList.getByParentId(task.Id);
		if(children.size() != 0){
			Boolean found = false;
			for(ProjectTask__c ntask : children){
				if(ntask.Id == hijo.Id){
					System.debug('se encontro el hijo');
					found = true;
					ntask = hijo;
				}
			}
			if(!found){
				children.add(hijo);
			}
		}
		else{
			children.add(hijo);
		}
		
		return children;
	}
	
	public void checkParentTask(ProjectTask__c task){ 
		
		if(task.ParentTask__c != null){
			System.debug('-------------------------------->>>> Recursion '+ task.Id);
			ProjectTask__c parentTask = this.taskList.getbyId(task.ParentTask__c);
			ProjectTask__c auxTask    = new ProjectTask__c();	
			auxTask.StartDate__c      = null;
			auxTask.EndDate__c 		  = null;
			Double percentage		  = 0.0;
			
			List<ProjectTask__c> children = this.getTaskChildren(parentTask, task);
			System.debug('-------------------------------->>>> num Childs  '+ children.size());
			for(ProjectTask__c nTask : children) {
				if(auxTask.StartDate__c != null){
					if(task.Id != nTask.Id){
						if(nTask.StartDate__c <= auxTask.StartDate__c){
							auxTask.StartDate__c = nTask.StartDate__c;
						}
					}
					else{
						if(task.StartDate__c <= auxTask.StartDate__c){
							auxTask.StartDate__c = task.StartDate__c;
						}
					}
				}
				else{
					System.debug ('primera vez valor start '+nTask.StartDate__c);
					if(task.Id != nTask.Id){
						auxTask.StartDate__c = nTask.StartDate__c;
					}
					else{
						auxTask.StartDate__c = task.StartDate__c;
					}
					
				}
				
				if(auxTask.EndDate__c != null){
					if(task.Id != nTask.Id){
						if(nTask.EndDate__c >= auxTask.EndDate__c){
							auxTask.EndDate__c = nTask.EndDate__c;
						}
					}
					else{
						if(task.EndDate__c >= auxTask.EndDate__c){
							auxTask.EndDate__c = task.EndDate__c;
						}
					}
				}
				else{
					System.debug ('primera vez valor end '+nTask.EndDate__c);
					if(task.Id != nTask.Id){
						auxTask.EndDate__c = nTask.EndDate__c;
					}
					else{
						auxTask.EndDate__c = task.EndDate__c;
					}
					
				}
				
				if(nTask.PercentCompleted__c == null ){
					nTask.PercentCompleted__c = 0.0;
				}
					if(task.Id != nTask.Id){
						percentage = percentage + nTask.PercentCompleted__c;
					}
					else{
						if(task.PercentCompleted__c == null){
							percentage = percentage + 0.0;
						}
						else{
							percentage = percentage + task.PercentCompleted__c;
						}
					}
				
				
			}
			
			parentTask.StartDate__c = auxTask.StartDate__c;
			parentTask.EndDate__c   = auxTask.EndDate__c;
			if(percentage != 0.0){
				parentTask.PercentCompleted__c = percentage / children.size();
			}

			ProjectUtil.setFlagValidationParentTask(false);
			this.updates.put(parentTask.Id, parentTask);
			ProjectUtil.setFlagValidationParentTask(true);
			
			this.checkParentTask(parentTask);
		}
		else{
			for(ProjectTask__c t : this.updates.values()){
				System.debug('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
				System.debug('++++++++++++++++++++++++ task id :'+ t.Id);
				System.debug('++++++++++++++++++++++++ task StartDate :'+ t.StartDate__c);
				System.debug('++++++++++++++++++++++++ task EndDate :'+ t.EndDate__c);
				System.debug('++++++++++++++++++++++++ task Parent :'+ t.ParentTask__c);
				System.debug('++++++++++++++++++++++++ task Percentage :'+ t.PercentCompleted__c);
				System.debug('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
			}
			ProjectUtil.setFlagValidationParentTask(false);
			update this.updates.values();
			ProjectUtil.setFlagValidationParentTask(true);
		}
	}
	
	
	
	public Class BigListOfTask{
		private List<List<ProjectTask__c>> bList = new List<List<ProjectTask__c>>();
		
		public bigListOfTask(String projectId){
			
			for( List<ProjectTask__c> ptList : [ select Id, Duration__c, DurationUI__c, Indent__c, ParentTask__c, PercentCompleted__c,  Project__c,  StartDate__c, EndDate__c from ProjectTask__c where Project__c =: projectId ])
				this.bList.add(ptList);
		}

		private void add( ProjectTask__c task, Integer ind ){
			
			if( this.bList[this.bList.size() - 1 ].size() < 200)
				this.bList[this.bList.size() - 1 ].add( task );
			else
				this.bList[this.bList.size()].add( task );
		}
		
		private ProjectTask__c get( Integer ind ){
			return bList[  ind / 200 ][ ind - Math.mod( ind, 200 )*200];
		}

	
		private ProjectTask__c getById( Id taskId ){
			
			ProjectTask__c ret = new ProjectTask__c();
			for( List<ProjectTask__c> ptList : this.bList ){
				for(ProjectTask__c pt :ptList ){
					if( pt.id == taskId ){
						ret =  pt;
						break;
						break;
					}	
				}
			}
			
			return ret;
		}		
		
		private List<ProjectTask__c> getByParentId( Id parentTaskId ){
	
			List<ProjectTask__c> r = new List<ProjectTask__c>();
			for( List<ProjectTask__c> ptList : this.bList )
				for(ProjectTask__c pt :ptList )
					if( pt.ParentTask__c == parentTaskId )
					r.add( pt );
			
			return r;
		}		
		
		
		private Integer size(){
			
			Integer length = 0; 
			for( List<ProjectTask__c> ptList : this.bList )
				length =+ ptList.size();
				
			return length;
		}
		
	}
}