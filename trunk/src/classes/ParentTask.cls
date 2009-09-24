/**
*@author: Matias Menafra - Sep 1, 2009
*/
public class ParentTask {
	
	public static Map<Id,ProjectTask__c> updates = new Map<Id,ProjectTask__c>();
	public Map<Id,ProjectTask__c> indentUpdateTasks = new Map<Id,ProjectTask__c>();
	public Boolean validParentTask = true;
	
	/**
	* Class constructor
	*/
	public ParentTask (){
	}
	
	public ProjectTask__c getParentTask(ProjectTask__c task){
		ProjectTask__c parentTask = BigListOfTasks.getById(task.ParentTask__c);	
		System.debug(parentTask);							
		return parentTask;
	}
	
	public Double setTaskIndent(ProjectTask__c task){
		
		if(task.ParentTask__c != null){
			ProjectTask__c parentTask = BigListOfTasks.getById(task.ParentTask__c);		
			return ParentTask.Indent__c + 1.0;
		}
		else
			return	0.0;		
	}
	
	public void updateAllChildrensIndent(ProjectTask__c task){
		System.debug('---------------DENTRO Tarea para el update children indent : ' + task.Id); 
		List<ProjectTask__c> children = BigListOfTasks.getByParentId(task.Id);
		System.debug('Tamano de children size: '+children.size()); 
		for(ProjectTask__c tsk : children){
			ProjectTask__c aux = new ProjectTask__c(); 
			aux = tsk;
			aux.Indent__c = this.setTaskIndent(aux);
			this.indentUpdateTasks.put(aux.Id,aux);
			BigListOfTasks.setById(aux);
				System.debug('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
				System.debug('++++++++++++++++++++++++ task id :'+ aux.Id);
				System.debug('++++++++++++++++++++++++ task StartDate :'+ aux.StartDate__c);
				System.debug('++++++++++++++++++++++++ task EndDate :'+ aux.EndDate__c);
				System.debug('++++++++++++++++++++++++ task Parent :'+ aux.ParentTask__c);
				System.debug('++++++++++++++++++++++++ task Percentage :'+ aux.Indent__c);
				System.debug('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
		}
		
		if(children.size() != 0 ){
			for(ProjectTask__c childs : children){
				this.updateAllChildrensIndent(childs);
			}
		}
	}
	
	
	public void checkParentTaskRedundancy(ProjectTask__c task, String parentId){
		List<ProjectTask__c> children = BigListOfTasks.getByParentId(task.Id);
		for(ProjectTask__c tsk : children){
			if(tsk.Id == parentId && tsk.Milestone__c == false){
				this.validParentTask = this.validParentTask && false;
			}
		}
		
		if(children.size() != 0 ){
			for(ProjectTask__c child : children){
				this.checkParentTaskRedundancy(child, parentId);
			}
		}
	}
	
	public Boolean taskHasChildren(ProjectTask__c task){
		List<ProjectTask__c> children = BigListOfTasks.getByParentId(task.Id);
		if(children.size() > 0){
			return true;
		}
		else{
			return false;		
		}
	}
	
	public static List<ProjectTask__c> getTaskChildren(ProjectTask__c task, ProjectTask__c hijo){
		
		List<ProjectTask__c> children = BigListOfTasks.getByParentId(task.Id);
		if(children.size() != 0){
			Boolean found = false;
			for(ProjectTask__c ntask : children){
				if(ntask.Id == hijo.Id){
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
	
	/**
	* Method called in the future which then calls checkparent to update
	* the whole tree sturcture of tasks
	* @param String taskId
	*/
	@future
	public static void updateParentTasks(String taskId){
		ProjectTask__c t = [Select Id, Project__c from ProjectTask__c where Id =: taskId];
		BigListOfTasks bigList = new BigListOfTasks(t.Project__c);
		
		ProjectTask__c aux = new ProjectTask__c();
		aux.ParentTask__c = taskId;
		ProjectTask__c task = BigListOfTasks.getbyId(aux.ParentTask__c);
		checkParentTask(task);
	}
	
	public static void checkParentTask(ProjectTask__c task){ 
		
		if(task.ParentTask__c != null){
			System.debug('-------------------------------->>>> Recursion '+ task.Id + ' Parent Id: ' + task.ParentTask__c);
			ProjectTask__c parentTask = BigListOfTasks.getbyId(task.ParentTask__c);
			ProjectTask__c auxTask    = new ProjectTask__c();	
			auxTask.StartDate__c      = null;
			auxTask.EndDate__c 		  = null;
			Double percentage		  = 0.0;
			
			List<ProjectTask__c> children = getTaskChildren(parentTask, task);
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
					if(task.Id != nTask.Id){
						auxTask.StartDate__c = nTask.StartDate__c;
					}
					else{
						auxTask.StartDate__c = task.StartDate__c;
					}
					
				}
				if(!nTask.Milestone__c){
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
						if(task.Id != nTask.Id){
							auxTask.EndDate__c = nTask.EndDate__c;
						}
						else{
							auxTask.EndDate__c = task.EndDate__c;
						}
						
					}
				}
				else{
					if(auxTask.EndDate__c != null){
						if(task.Id != nTask.Id){
							if(nTask.StartDate__c >= auxTask.EndDate__c){
								auxTask.EndDate__c = nTask.StartDate__c;
							}
						}
						else{
							if(task.StartDate__c >= auxTask.EndDate__c){
								auxTask.EndDate__c = task.StartDate__c;
							}
						}
					}
					else{
						if(task.Id != nTask.Id){
							auxTask.EndDate__c = nTask.StartDate__c;
						}
						else{
							auxTask.EndDate__c = task.StartDate__c;
						}
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
				parentTask.PercentCompleted__c = Math.floor(percentage / children.size());
			}
			else{
				parentTask.PercentCompleted__c = 0.0;
			}
			

			ProjectUtil.setFlagValidationParentTask(false);
			updates.put(parentTask.Id, parentTask);
			ProjectUtil.setFlagValidationParentTask(true);
			
			checkParentTask(parentTask);
		}
		else{
			for(ProjectTask__c t : updates.values()){
				System.debug('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
				System.debug('++++++++++++++++++++++++ task id :'+ t.Id);
				System.debug('++++++++++++++++++++++++ task StartDate :'+ t.StartDate__c);
				System.debug('++++++++++++++++++++++++ task EndDate :'+ t.EndDate__c);
				System.debug('++++++++++++++++++++++++ task Parent :'+ t.ParentTask__c);
				System.debug('++++++++++++++++++++++++ task Percentage :'+ t.PercentCompleted__c);
				System.debug('++++++++++++++++++++++++ task Duration :'+ t.DurationUI__c);
				System.debug('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
			}
			ProjectUtil.setFlagValidationParentTask(false);
			update updates.values();
			ProjectUtil.setFlagValidationParentTask(true);
		}
	}
	
	//New method for testing parent updates wiithout using recursion
	@future
	public static void newUpdateParentTask(List<String> taskIds){
		String id = taskIds.get(0);
		ProjectTask__c t = [Select Id, Project__c from ProjectTask__c where Id =: id];
		BigListOfTasks bigList = new BigListOfTasks(t.Project__c);
		
		List<ProjectTask__c> tasks = new List<ProjectTask__c>();
		for(String taskId : taskIds){
			ProjectTask__c tsk = BigListOfTasks.getbyId(String.valueOf(taskId));
			tasks.add(tsk); 
		}
		
		/*
		List<ProjectTask__c> parentTasks = new List<ProjectTask__c>();
		for(ProjectTask__c tsk : tasks){
			if(tsk.ParentTask__c != null){
				ProjectTask__c parent = BigListOfTasks.getbyId(tsk.ParentTask__c);
				parentTasks.add(parent);
			}
		}*/
		
		for(ProjectTask__c task : tasks){
			ProjectTask__c parentTask = BigListOfTasks.getbyId(task.ParentTask__c);
			ProjectTask__c auxTask    = new ProjectTask__c();	
			auxTask.StartDate__c      = null;
			auxTask.EndDate__c 		  = null;
			Double percentage		  = 0.0;
			
			List<ProjectTask__c> children = getTaskChildren(parentTask, task);
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
					if(task.Id != nTask.Id){
						auxTask.StartDate__c = nTask.StartDate__c;
					}
					else{
						auxTask.StartDate__c = task.StartDate__c;
					}
					
				}
				if(!nTask.Milestone__c){
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
						if(task.Id != nTask.Id){
							auxTask.EndDate__c = nTask.EndDate__c;
						}
						else{
							auxTask.EndDate__c = task.EndDate__c;
						}
						
					}
				}
				else{
					if(auxTask.EndDate__c != null){
						if(task.Id != nTask.Id){
							if(nTask.StartDate__c >= auxTask.EndDate__c){
								auxTask.EndDate__c = nTask.StartDate__c;
							}
						}
						else{
							if(task.StartDate__c >= auxTask.EndDate__c){
								auxTask.EndDate__c = task.StartDate__c;
							}
						}
					}
					else{
						if(task.Id != nTask.Id){
							auxTask.EndDate__c = nTask.StartDate__c;
						}
						else{
							auxTask.EndDate__c = task.StartDate__c;
						}
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
				parentTask.PercentCompleted__c = Math.floor(percentage / children.size());
			}
			else{
				parentTask.PercentCompleted__c = 0.0;
			}
			
			updates.put(parentTask.Id, parentTask);
		}
		
		ProjectUtil.setFlagValidationParentTask(false);
		update updates.values();
		ProjectUtil.setFlagValidationParentTask(true);
	}
}