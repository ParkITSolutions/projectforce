/**
*@author Matias Menafra - Sep 1, 2009
*/
public class ParentTask {
	//Map of tasks to update
	public static Map<Id,ProjectTask__c> updates = new Map<Id,ProjectTask__c>();
	//Map of task nfor updating Indent value
	public Map<Id,ProjectTask__c> indentUpdateTasks = new Map<Id,ProjectTask__c>();
	//value to check if task can be a valid Parent Task
	public Boolean validParentTask = true;
	
	/**
	* Class constructor
	*/
	public ParentTask (){
		//Does nothing
	}
	
	/**
	* Method to get the parent task of a given task
	* @param ProjectTask task
	* @return ProjectTask
	*/
	public ProjectTask__c getParentTask(ProjectTask__c task){
		
		ProjectTask__c parentTask = BigListOfTasks.getById(task.ParentTask__c);	
		return parentTask;
	}
	
	/**
	* Method used to validate if choosen Parent Task is valid when inserting a new task
	* @param ProjectTask task
	* @return Boolean
	*/
	public Boolean validateParentTaskInsert(ProjectTask__c task){
		
		if( task.ParentTask__c != null ){
			ProjectTask__c parentTsk = this.getParentTask(task);
			if(parentTsk.Milestone__c == true){
				return false;
			}
			else{
				return true;
			}
		}
		else{
			return true;
		}
	}
	
	/**
	* Method used to validate if choosen Parent Task is valid when updating a task
	* @param ProjectTask__c tempPTOld
	* @param ProjectTask__c tempPTNew
	* @return void
	*/
	public void parentTaskUpdate(ProjectTask__c tempPTOld, ProjectTask__c tempPTNew){
		
		if( tempPTNew.ParentTask__c != null && tempPTOld.ParentTask__c == tempPTNew.ParentTask__c){ 
			if(ProjectUtil.getFlagValidationParentTask()){
				ParentTask.updateParentTasks(tempPTNew.id);
			}
		}
		
		if(ProjectUtil.getParentTaskUpdateIndent()){
			tempPTNew.Indent__c = this.setTaskIndent(tempPTNew);
		}
		
	}
	
	/**
	* Method used to calculate the correct Indent value for a given Task
	* @param ProjectTask task
	* @return Double
	*/
	public Double setTaskIndent(ProjectTask__c task){
		
		if(task.ParentTask__c != null){
			ProjectTask__c parentTask = this.getParentTask(task);		
			return ParentTask.Indent__c + 1.0;
		}
		else
			return	0.0;		
	}
	
	/**
	* Method updates all child tasks Indent Value
	* @param ProjectTask task
	* @return Void
	*/
	public void updateAllChildrensIndent(ProjectTask__c task){
		//Gets all child task by Parent Id
		List<ProjectTask__c> children = BigListOfTasks.getByParentId(task.Id);
		
		//Recalcute all Indent values for child tasks
		for(ProjectTask__c tsk : children){
			ProjectTask__c aux = new ProjectTask__c(); 
			aux = tsk;
			aux.Indent__c = this.setTaskIndent(aux);
			this.indentUpdateTasks.put(aux.Id,aux);
			BigListOfTasks.setById(aux);
		}
		
		//checks to see if there are child tasks
		if(children.size() != 0 ){
			//for each child task calls method recursivly
			for(ProjectTask__c childs : children){
				//Method is called recursivly to update all his children
				this.updateAllChildrensIndent(childs);
			}
		}
	}
	
	/**
	* Recursive method which checks for cyclic redundancy within Parent Tasks
	* @param ProjectTask task
	* @param String parent task Id
	* @return void
	*/
	public void checkParentTaskRedundancy(ProjectTask__c task, String parentId){
		//Gets all child task by Parent Id
		List<ProjectTask__c> children = BigListOfTasks.getByParentId(task.Id);
		
		//Checks each child if its an invalid parent task
		for(ProjectTask__c tsk : children){
			//Parent Tasks cannot be descendents
			if(tsk.Id == parentId){
				//Invalid parent sets value to false
				this.validParentTask = this.validParentTask && false;
			}
		}
		//checks to see if there are child tasks
		if(children.size() != 0 ){
			//for each child task calls method recursivly
			for(ProjectTask__c child : children){
				this.checkParentTaskRedundancy(child, parentId);
			}
		}
	}
	
	/**
	* Method that checks if a task has any child tasks
	* @param ProjectTask__c task
	* @return Boolean
	*/
	public Boolean taskHasChildren(ProjectTask__c task){
		//Gets all child task by Parent Id
		List<ProjectTask__c> children = BigListOfTasks.getByParentId(task.Id);
		if(children.size() > 0){
			return true;
		}
		else{
			return false;		
		}
	}
	
	/**
	* Method which gets all child tasks from a given task
	* but excludes itself from the returning list
	* @param ProjectTask__c task
	* @param ProjectTask__c task
	* @return List<ProjectTask__c>
	*/
	public static List<ProjectTask__c> getTaskChildren(ProjectTask__c task, ProjectTask__c hijo){
		
		//Gets all child task by Parent Id
		List<ProjectTask__c> children = BigListOfTasks.getByParentId(task.Id);
		//checks how many child task there are
		if(children.size() != 0){
			Boolean found = false;
			//checks all children to find if it's it self
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
			//Only one child 
			children.add(hijo);
		}
		
		return children;
	}
	
	/**
	* Method called in the future which then calls checkparent to update
	* the whole tree structure of tasks
	* @param String taskId
	*/
	@future
	public static void updateParentTasks(String taskId){
		
		//SOQL query to retrieve a task object to get projectId
		ProjectTask__c t = [Select Id, Project__c from ProjectTask__c where Id =: taskId limit 1];
		//Initializes BigList with the ProjectID
		BigListOfTasks bigList = new BigListOfTasks(t.Project__c);
		
		ProjectTask__c task = BigListOfTasks.getbyId((Id)taskId);
		checkParentTask(task);
	}
	
	/**
	* Recursive method used for checking and updating all parent nodes
	* @param ProjectTask__c task
	* @return Void
	*/
	public static void checkParentTask(ProjectTask__c task){ 
		
		//checks if task has a parent task assigned
		if(task.ParentTask__c != null){
			ProjectTask__c parentTask = BigListOfTasks.getbyId(task.ParentTask__c);
			//aux task for storing values before updating parent task
			ProjectTask__c auxTask    = new ProjectTask__c();	
			auxTask.StartDate__c      = null;
			auxTask.EndDate__c 		  = null;
			Double percentage		  = 0.0;
			
			//gets all child tasks for given parent 
			List<ProjectTask__c> children = getTaskChildren(parentTask, task);
			//Recalculates neccesary information for updating Parent Node
			for(ProjectTask__c nTask : children){
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
				
				
			}//ends For loop
			
			//updating parent task information
			parentTask.StartDate__c = auxTask.StartDate__c;
			parentTask.EndDate__c   = auxTask.EndDate__c;
			
			if(percentage != 0.0){
				parentTask.PercentCompleted__c = Math.floor( percentage / children.size() );
			}
			else{
				parentTask.PercentCompleted__c = 0.0;
			}
			
			//inserts modified parent in update list
			updates.put(parentTask.Id, parentTask);
			
			//calls recursivly method with parent
			checkParentTask(parentTask);
		}
		else{
			//the end of the parent task hierarchy is found send to update all parent nodes
			ProjectUtil.setFlagValidationParentTask(false);
				update updates.values();
			ProjectUtil.setFlagValidationParentTask(true);
		}
	}
	
	/**
	* Method called in the future for updating all parent nodes from a whole list of task Ids
	* method not recursive
	* @param List<String> taskIds
	* @return Void
	*/
	@future
	public static void batchUpdateParentTask(List<String> taskIds){
		
		String id = taskIds.get(0);
		ProjectTask__c t = [Select Id, Project__c from ProjectTask__c where Id =: id limit 1];
		BigListOfTasks bigList = new BigListOfTasks(t.Project__c);
		
		List<ProjectTask__c> tasks = new List<ProjectTask__c>();
		for(String taskId : taskIds){
			ProjectTask__c tsk = BigListOfTasks.getbyId(String.valueOf(taskId));
			tasks.add(tsk); 
		}
		
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