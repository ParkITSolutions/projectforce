/**
*@author Matias Menafra - Sep 1, 2009
*/   
public class ParentTask {
  
  //Map of task nfor updating Indent value
  public static Map<Id,ProjectTask__c> indentUpdateTasks = new Map<Id,ProjectTask__c>();
  //value to check if task can be a valid Parent Task
  public Boolean validParentTask = true;
  //List of tasks modified by task links
  public static List<ProjectTask__c> modifiedDependecies = new List<ProjectTask__c>();
  //Map of tasks to update
  public static Map<Id,ProjectTask__c> updates = new Map<Id,ProjectTask__c>();
  
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
  public static ProjectTask__c getParentTask(ProjectTask__c task){
    
    ProjectTask__c parentTask = new ProjectTask__c(); 
    
    if(BigListOfTasks.getById(task.ParentTask__c) != null )
      parentTask = BigListOfTasks.getById(task.ParentTask__c);  
    
    return parentTask;
  }
  
  /**
  * Method used to validate if choosen Parent Task is valid when inserting a new task
  * @param ProjectTask task
  * @return Boolean
  */
  public Boolean validateParentTaskInsert(ProjectTask__c task){
    
    if( task.ParentTask__c != null ){
      ProjectTask__c parentTsk = getParentTask(task);
      if(parentTsk == null ){
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
    ParentTask.mergeTasks();
    
    List<Id> modsIds = new List<Id>();
    List<String> modsStarDate = new List<String>();     
    List<String> modsEndDate = new List<String>();     

    for( ProjectTask__c t : ParentTask.updates.values()){
        modsIds.add( t.id);
        modsStarDate.add( String.valueOf(t.StartDate__c ));
        modsEndDate.add( String.valueOf(t.EndDate__c ));
    }

    if(tempPTNew.ParentTask__c != null && tempPTOld.ParentTask__c == tempPTNew.ParentTask__c){ 
      if(ProjectUtil.getFlagValidationParentTask()){
        //Call to @future method
        System.debug('============== Future call');
        ParentTask.updateParentTasks(tempPTNew.id, modsIds, modsStarDate, modsEndDate );
      }
    }
    else{
      ProjectUtil.setTaskDependenciesFlag( false );
      System.debug('========' +ProjectUtil.getFlagValidationParentTask() );
      if(ProjectUtil.getFlagValidationParentTask()){
      	System.debug('============== Common Update' + ParentTask.updates.values());
        update ParentTask.updates.values();
      }
    }
    
    if(ProjectUtil.getParentTaskUpdateIndent()){
      tempPTNew.Indent__c = setTaskIndent(tempPTNew);
    }
    
  }
  
  /**
  * Method used to calculate the correct Indent value for a given Task
  * @param ProjectTask task
  * @return Double
  */
  public static Double setTaskIndent(ProjectTask__c task){
    
    if(task.ParentTask__c != null){
      ProjectTask__c parentTask = getParentTask(task);
      return ParentTask.Indent__c + 1.0;
    }
    else
      return  0.0;    
  }
  
  /**
  *
  *
  * @return void
  */
  @future 
  public static void callUpdateAllChildrenIndent(String idTsk, String idProject){
    //Reset big list with new taskList
    //SOQL query to retrieve a task object to get projectId
    ProjectTask__c t = [Select Id, Project__c from ProjectTask__c where Id =: idTsk limit 1];
    //Initializes BigList with the ProjectID
    
    BigListOfTasks bigList = new BigListOfTasks(t.Project__c);
    
    ProjectTask__c tskAux = BigListOfTasks.getById((Id)idTsk);  
    //updates all childs Indent Value
    updateAllChildrensIndent(tskAux);
    //sets flags and updates the list of modified tasks
    ProjectUtil.setFlagValidationParentTask( false );
    ProjectUtil.setTaskDependenciesFlag( false );
    ProjectUtil.flags.put('exeParentTaskUpdate', true);
      update indentUpdateTasks.values(); 
    ProjectUtil.setTaskDependenciesFlag( true );
    ProjectUtil.setFlagValidationParentTask( true );
  }
  
  /**
  * Method updates all child tasks Indent Value
  * @param ProjectTask task
  * @return Void
  */
  public static void updateAllChildrensIndent(ProjectTask__c task){
    //Gets all child task by Parent Id
    List<ProjectTask__c> children = BigListOfTasks.getByParentId(task.Id);
    
    //Recalcute all Indent values for child tasks
    for(ProjectTask__c tsk : children){
      ProjectTask__c aux = new ProjectTask__c(); 
      aux = tsk;
      aux.Indent__c = setTaskIndent(aux);
      indentUpdateTasks.put(aux.Id,aux);
      BigListOfTasks.setById(aux);
    }
    
    //checks to see if there are child tasks
    if(children.size() != 0 ){
      //for each child task calls method recursivly
      for(ProjectTask__c childs : children){
        //Method is called recursivly to update all his children
        updateAllChildrensIndent(childs);
      }
    }
  }
  
  /**
  * Recursive method used when mass deleting tasks, for deleting ALL child tasks
  * @param task
  */
  public void getAllChildTasks( ProjectTask__c task ){
    //Gets all child task by Parent Id
    List<ProjectTask__c> children = BigListOfTasks.getByParentId( task.Id );
    
    ProjectUtil.childrenTaskToDelete2.put( task.Id, task );
    //Recalcute all Indent values for child tasks
    for(ProjectTask__c tsk : children){
      ProjectUtil.childrenTaskToDelete2.put( tsk.Id, tsk );
    }
    
    //checks to see if there are child tasks
    if( children.size() != 0 ){
      //for each child task calls method recursivly
      for( ProjectTask__c childs : children ){
        //Method is called recursivly to update all his children
        getAllChildTasks( childs );
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
  * Method which merges changed tasks from task dependecies with task being changes by ParenT task
  * @return void
  */
  private static void mergeTasks(){
    if(ParentTask.modifiedDependecies!= null ){
      //throw new CustomException('#' + ParentTask.modifiedDependecies.size());
      for( ProjectTask__c mDTsk : ParentTask.modifiedDependecies ){  
        //throw new CustomException('#' + mDTsk.name +'::'+mDTsk.startDate__c);
        ParentTask.updates.put( mDTsk.Id,mDTsk );
        BigListOfTasks.setById( mDTsk );
      }
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
    List<ProjectTask__c> children = new List<ProjectTask__c>();
    if(task != null){
      children = BigListOfTasks.getByParentId(task.Id);
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
    }
    
    return children;
  }
  
  /**
  * Method called in the future which then calls checkparent to update
  * the whole tree structure of tasks
  * @param String taskId
  */
  @future
  public static void updateParentTasks(String taskId, List<id> ids, List<String> startDate, List<String> endDate ){ 
     
    //SOQL query to retrieve a task object to get projectId
    ProjectTask__c t = [Select Id, Project__c from ProjectTask__c where Id =: taskId limit 1];
    //Initializes BigList with the ProjectID
    
    BigListOfTasks bigList = new BigListOfTasks(t.Project__c);
    //ParentTask.mergeTasks();
    ProjectTask__c auxTask = new ProjectTask__c();
    Integer c = 0;
    for( Id i : ids ){
      auxTask = BigListOfTasks.getById( i );
      auxTask.StartDate__c = Date.valueOf( startDate[ c ]);
      auxTask.EndDate__c = Date.valueOf( endDate[ c ]);
      BigListOfTasks.setById( auxTask );
      ParentTask.updates.put(auxTask.id, auxTask);
      c++;
    }
    List<ProjectTask__c> aux = ParentTask.updates.values();

    ProjectTask__c task = BigListOfTasks.getbyId((Id)taskId);
    System.debug( '================== After Update Task:' + task );
    checkParentTask( task );
  }
  
  /**
  * Recursive method used for checking and updating all parent nodes
  * @param ProjectTask__c task
  * @return Void
  */
  public static void checkParentTask(ProjectTask__c task){ 
    //checks if task has a parent task assigned
    if(task.ParentTask__c != null){
    	System.debug('==================== Entro al checkparent task :' +task);
      ProjectTask__c parentTask = BigListOfTasks.getbyId( task.ParentTask__c );
      System.debug('===================== Parent Task Encontradas: ' + parentTask );
      
      //aux task for storing values before updating parent task
      ProjectTask__c auxTask    = new ProjectTask__c();  
      auxTask.StartDate__c      = null;
      auxTask.EndDate__c       = null;
      Double percentage      = 0.0;
      
      //gets all child tasks for given parent 
      List<ProjectTask__c> children = getTaskChildren(parentTask, task);
      //Recalculates neccesary information for updating Parent Node
      System.debug('==================== Children size ' + children.size() );
      for(ProjectTask__c nTask : children){
      	System.debug('==================== hidl task iter:' +nTask);
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
        //throw new CustomException('#' + updates.values().size());
        List<ProjectTask__c> aux = updates.values();
        System.debug('====================Size of Final Update : '+updates.size()+'  ' + updates.values());
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
  public static void batchUpdateParentTask( List<String> taskIds ){
    if( taskIds.size() > 0 ){
    	System.debug('============================Batch task Id size:' + taskIds.size());
      	String id = taskIds.get(0);
      	ProjectTask__c t = [Select Id, Project__c from ProjectTask__c where Id =: id limit 1];
      	BigListOfTasks bigList = new BigListOfTasks(t.Project__c);
      
      	List<ProjectTask__c> tasks = new List<ProjectTask__c>();
      	for(String taskId : taskIds){
        	ProjectTask__c tsk = BigListOfTasks.getbyId(String.valueOf(taskId));
        	tasks.add(tsk); 
      	}
      
      System.debug( '================= Total Tasks:' +tasks.size() );
      for( ProjectTask__c task : tasks ){
      	System.debug( '================= task in iteracion:' +task );
        if( task != null ){
          ProjectTask__c parentTask = BigListOfTasks.getbyId( task.ParentTask__c );
          ProjectTask__c auxTask    = new ProjectTask__c();  
          auxTask.StartDate__c      = null;
          auxTask.EndDate__c       	= null;
          Double percentage      	= 0.0;
          
          List<ProjectTask__c> children = getTaskChildren( parentTask, task) ;
          System.debug( '=================== Task Children Size : ' + children.size() + '  ' + children );
          for( ProjectTask__c nTask : children ) {
          	System.debug( '================= Child Task in quest' +nTask);
            if( auxTask.StartDate__c != null ){
              if( task.Id != nTask.Id ){
                if( nTask.StartDate__c <= auxTask.StartDate__c ){
                  auxTask.StartDate__c = nTask.StartDate__c;
                }
              }
              else{
                if( task.StartDate__c <= auxTask.StartDate__c ){
                  auxTask.StartDate__c = task.StartDate__c;
                }
              }
            }
            else{
              if( task.Id != nTask.Id ){
                auxTask.StartDate__c = nTask.StartDate__c;
              }
              else{
                auxTask.StartDate__c = task.StartDate__c;
              }
              
            }
            if( !nTask.Milestone__c ){
              if( auxTask.EndDate__c != null ){
                if( task.Id != nTask.Id ){
                  if( nTask.EndDate__c >= auxTask.EndDate__c ){
                    auxTask.EndDate__c = nTask.EndDate__c;
                  }
                }
                else{
                  if( task.EndDate__c >= auxTask.EndDate__c ){
                    auxTask.EndDate__c = task.EndDate__c;
                  }
                }
              }
              else{
                if( task.Id != nTask.Id ){
                  auxTask.EndDate__c = nTask.EndDate__c;
                }
                else{
                  auxTask.EndDate__c = task.EndDate__c;
                }
                
              }
            }
            else{
              if( auxTask.EndDate__c != null ){
                if( task.Id != nTask.Id ){
                  if( nTask.StartDate__c >= auxTask.EndDate__c ){
                    auxTask.EndDate__c = nTask.StartDate__c;
                  }
                }
                else{
                  if( task.StartDate__c >= auxTask.EndDate__c ){
                    auxTask.EndDate__c = task.StartDate__c;
                  }
                }
              }
              else{
                if( task.Id != nTask.Id ){
                  auxTask.EndDate__c = nTask.StartDate__c;
                }
                else{
                  auxTask.EndDate__c = task.StartDate__c;
                }
              }
            }
            
            if( nTask.PercentCompleted__c == null ){
              nTask.PercentCompleted__c = 0.0;
            }
            if( task.Id != nTask.Id ){
              percentage = percentage + nTask.PercentCompleted__c;
            }
            else{
              if( task.PercentCompleted__c == null ){
                percentage = percentage + 0.0;
              }
              else{
                percentage = percentage + task.PercentCompleted__c;
              }
            }
          }
          System.debug( '=============== Child Parent Task:' + parentTask );
          if( parentTask != null ){
          	System.debug( '=============== Child task has no Parent:');
            parentTask.StartDate__c = auxTask.StartDate__c;
            parentTask.EndDate__c   = auxTask.EndDate__c;
            if( percentage != 0.0 ){
              parentTask.PercentCompleted__c = Math.floor( percentage / children.size() );
            } 
            else{
              parentTask.PercentCompleted__c = 0.0;
            }
            
            updates.put(parentTask.Id, parentTask);
          }
        }
      }
      
      if( updates.size() > 0 ){
      	System.debug('============================Final Batch List size :' + updates.size() );
		System.debug('============================Final Batch:' + updates.values() );
      	//update updates.values();
      	ParentTask.checkParentTask(tasks.get(0));
      }
    }
  }
  
  /**
  * Method called in the future which then calls checkparent to update
  * the whole tree structure of tasks
  * @param String taskId
  */
  @future
  public static void updateParentTasksAfterUpdate( String taskId, List<id> ids, List<String> startDate, List<String> endDate, String parentId ){
  	System.debug( '======================= Entro al Nuevo after Update Method' );
  	//SOQL query to retrieve a task object to get projectId
    ProjectTask__c t = [ Select Id, Project__c from ProjectTask__c where Id =: taskId limit 1 ];
    //Initializes BigList with the ProjectID
    BigListOfTasks bigList = new BigListOfTasks( t.Project__c );
    
    ProjectTask__c auxTask = new ProjectTask__c();
    Integer c = 0;
    
    for( Id i : ids ){
      auxTask = BigListOfTasks.getById( i );
      auxTask.StartDate__c = Date.valueOf( startDate[ c ] );
      auxTask.EndDate__c = Date.valueOf( endDate[ c ] );
      BigListOfTasks.setById( auxTask );
      ParentTask.updates.put( auxTask.id, auxTask );
      c++;
    }
    
    ProjectTask__c task = BigListOfTasks.getbyId( (Id)taskId );
    System.debug( '======================= normal Task: ' + task);
    ProjectTask__c cloneTask = task.clone();
    cloneTask.ParentTask__c = parentId;
    System.debug( '======================= Cloned task :' + cloneTask);
    checkParentTask2( cloneTask );
  }
  
  /**
  * Recursive method used for checking and updating all parent nodes
  * @param ProjectTask__c task
  * @return Void
  */
  public static void checkParentTask2(ProjectTask__c task){ 
    //checks if task has a parent task assigned
    if(task.ParentTask__c != null){
    	System.debug('==================== Entro al checkparent task :' +task);
      ProjectTask__c parentTask = BigListOfTasks.getbyId( task.ParentTask__c );
      System.debug('===================== Parent Task Encontradas: ' + parentTask );
      
      //aux task for storing values before updating parent task
      ProjectTask__c auxTask    = new ProjectTask__c();  
      auxTask.StartDate__c      = null;
      auxTask.EndDate__c       = null;
      Double percentage      = 0.0;
      
      //gets all child tasks for given parent 
      //List<ProjectTask__c> children = getTaskChildren(parentTask, task);
      List<ProjectTask__c> children = BigListOfTasks.getByParentId( parentTask.Id );
      //Recalculates neccesary information for updating Parent Node
      System.debug('==================== Children size ' + children.size() );
      for(ProjectTask__c nTask : children){
      	System.debug('==================== hidl task iter:' +nTask);
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
      checkParentTask2(parentTask);
    }
    else{
      //the end of the parent task hierarchy is found send to update all parent nodes
      ProjectUtil.setFlagValidationParentTask(false);
        //throw new CustomException('#' + updates.values().size());
        List<ProjectTask__c> aux = updates.values();
        System.debug('====================Size of Final Update : '+updates.size()+'  ' + updates.values());
        update updates.values();
      ProjectUtil.setFlagValidationParentTask(true);
    }
  }
}