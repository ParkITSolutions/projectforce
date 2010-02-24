package com.salesforce.gantt.controller
{
	import com.salesforce.gantt.commands.CompositeCommand;
	import com.salesforce.gantt.commands.History;
	import com.salesforce.gantt.commands.RetrieveCommand;
	import com.salesforce.gantt.commands.dependency.CreateDependencyCommand;
	import com.salesforce.gantt.commands.dependency.DeleteDependencyCommand;
	import com.salesforce.gantt.commands.dependency.UpdateDependencyCommand;
	import com.salesforce.gantt.commands.project.UpdateProjectCommand;
	import com.salesforce.gantt.commands.resource.MergeResourcesCommand;
	import com.salesforce.gantt.commands.resource.ReadUserOnDemandCommand;
	import com.salesforce.gantt.commands.task.CreateTaskCommand;
	import com.salesforce.gantt.commands.task.DeleteTaskCommand;
	import com.salesforce.gantt.commands.task.PasteTaskCommand;
	import com.salesforce.gantt.commands.task.ReadTaskCommand;
	import com.salesforce.gantt.commands.task.UpdateTaskCommand;
	import com.salesforce.gantt.model.Heriarchy;
	import com.salesforce.gantt.model.Project;
	import com.salesforce.gantt.model.SyncInfo;
	import com.salesforce.gantt.model.Task;
	import com.salesforce.gantt.model.UiTask;
	import com.salesforce.gantt.util.CustomArrayUtil;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.IResponder;
	
	/**
	 * TODO ;)
	 * Refactor controller to manage the callback when the command finished,
	 * perhaps create a reference in the Gantt.mxml to this class, research.
	 * 
	 */
	
	public class Controller extends EventDispatcher implements IController,IResponder
	{	
		/**
		 * action can be either cut or copy
		 * to know if we need to delete the selected Task or not
		 * If it's cut then we delete the selected Task
		 * If it's copy then we don't delete the selected Task
		 */
		[Bindable]
		public var action : String = '';
		/** stores the history of commands selected by the user **/
		private var history : History;
		
		/**
		 * Constructor
		 */
		public function Controller()
		{						
			history = new History();
		}
		
	  	/**
       	* Indents a task to the right
       	* This method 
       	* 	- assigns or unassigns parents to affected tasks
       	* 	- sets + - images
       	* 	- assigns or unassigns children of affected tasks
       	*/
       	public function indent(task : UiTask) : void
       	{
       		var parentTask : UiTask;
       		var taskAbove : UiTask;
       		
       		taskAbove = Components.instance.tasks.getTaskIndex(task.position-2);
			if(task.parent == taskAbove.parent){
				task.parent = taskAbove.id;	
			}else{
				task.parent = taskAbove.parent;
			}
			updateTask(task.clone());
       	}
       
       	/**
	   	* Outdents a task to the left
	   	* This method 
	   	* 	- assigns or unassigns parents to affected tasks
	   	* 	- sets + - images
	   	* 	- assigns or unassigns children of affected tasks
		*/
		public function outdent(task : UiTask) : void
		{
			var parentTask : UiTask;
			var grandParentTask : UiTask;
			parentTask = Components.instance.tasks.getTask(task.parent);
			task.parent = parentTask.parent;	
			updateTask(task.clone());
		}
       
		/**
		* Stores a task on the clipboard to cut
		**/
		public function cut() : void
		{
			var selectedTask : Task = Components.instance.tasks.selectedTask;
			if(selectedTask){
				action= Constants.ACTION_ADD_CUT;
				Components.instance.tasks.cut();
			}
		}
		
		/**
		 * Stores a task in the clipboard to copy
		 **/
		 
		public function copy() : void
		{
			var selectedTask : Task = Components.instance.tasks.selectedTask;
			if(selectedTask){
				action= Constants.ACTION_ADD_COPY;
				Components.instance.tasks.copy();
			}
		}
		
		/**
		 * Creates a new Task identical to the one on the clipBoard 
		 * that has been either cut or copied
		 * (but may have different hierarchy and parent)
		 * If it was cut then the selected Task is deleted otherwise 
		 * the clipboard Task is left alone
		 * 
		 **/
		 
		public function paste() : void
		{
			if(Components.instance.tasks.clipBoardTasks.length>0)
			{
				var tasks : ArrayCollection = Components.instance.tasks.clipBoardTasks;
				var pasteTaskCommand : PasteTaskCommand = new PasteTaskCommand(CustomArrayUtil.copyArrayCollection(tasks),action);
				pasteTaskCommand.success =
					function(){
						history.addCommand(pasteTaskCommand);
						Components.instance.tasks.setParent(0);
						dispatchEvent(new Event(Constants.LOADING_END));
					}
				pasteTaskCommand.failure =
				function(){
					dispatchEvent(new Event(Constants.SYNCHRONIZING));
				}
				pasteTaskCommand.execute();	
			}
		}
		
		
		/**
		 * Resets tasks' position and updates the DB
		 * Called when a task is created in between, to update all tasks position
		 * */
		public function resetPositions() : void
		{
			var task : UiTask;
			var j : int = 0;
			for(var i : int = 0; i < Components.instance.tasks.allTasks.length; i++)
			{
				task = UiTask(Components.instance.tasks.allTasks.getItemAt(i));
				task.position = i + 1;
				if(UiTask(task).isVisible())
				{
					j++;
					task.positionVisible = j;
				}
				updateTask(task);
			}
		}
		/**
		 * Undo
		 */
		 
		public function undo() : void
		{
			history.undo(this);
		}
       
       	/**
		 * Redo
		 */
		 
		public function redo() : void
		{
			history.redo(this);
		}

		public function checkUndo(): Boolean{
			return history.checkUndo();	
		}
		
		public function checkRedo(): Boolean{
			return history.checkRedo();	
		}
		
		public function checkCopy() : Boolean{
			return Components.instance.tasks.selectedTask != null;
		}
		
		public function checkCut() : Boolean{
			return checkCopy();
		}
		
		public function checkPaste() : Boolean{
			return Components.instance.tasks.clipBoardTasks.length > 0;
		}
		
		/**
		 * Creates a new Task command and executes it
		 */
		 
		public function addTask(task : Task, action : String) : void
		{
			var insertAt : int = task.position;
        	var clonedTask : UiTask = (UiTask(task)).clone();
        	
        	var parentTask = null;
        	var insertAt : int = 0;
        	if(action == Constants.ACTION_ADD_BEFORE || action == Constants.ACTION_ADD_AFTER || action == Constants.ACTION_ADD_CHILD)
        	{
        		parentTask = Task(Components.instance.tasks.selectedTask);
        		insertAt = parentTask.position;
       		}
			if(action == Constants.ACTION_ADD_BEFORE)
	  		{
		  		clonedTask.position = parentTask.position;
		  		clonedTask.heriarchy = new Heriarchy(parentTask.heriarchy.indent, parentTask.heriarchy.parent);
		  		insertAt = clonedTask.position - 1;
		  		clonedTask.parent = parentTask.parent;
		  	}
		  	else if(action == Constants.ACTION_ADD_AFTER)
		  	{
		  		if(parentTask.heriarchy.hasChildren(parentTask.id))
		  		{
		  			if(!UiTask(parentTask).isExpanded)//Is set not to be child of the parentTask clicked
		  			{
		  				var tasksChildren : ArrayCollection = parentTask.heriarchy.getDescendants(parentTask);
		  				clonedTask.position = parentTask.position + tasksChildren.length + 1;
		  				clonedTask.heriarchy = new Heriarchy(0, null, null);
		  			}
		  			else//ends up being child of the parentTask that was clicked with the down arrow cursor
		  			{
		  				clonedTask.position = parentTask.position + 1;
			  			clonedTask.heriarchy = new Heriarchy(parentTask.heriarchy.indent+1, parentTask);
			  		}
			  		clonedTask.parent = parentTask.id;
		  		
		  		}
		  		else
		  		{
		  			//if the parent is not null and task is the last child
		  			//set the 
		  			if(parentTask.heriarchy.parent == null)
		  			{
		  				clonedTask.heriarchy = new Heriarchy(parentTask.heriarchy.indent);
		  			}
		  			//if exist as a last child set the grandparent as parent task
		  			else if(parentTask.heriarchy.isLastChild(parentTask.heriarchy.parent))
		  			{
		  				var granParent : Task = parentTask.heriarchy.parent.heriarchy.parent;
		  				clonedTask.heriarchy = new Heriarchy(parentTask.heriarchy.indent-1,granParent);	
		  				if(granParent != null){
		  					clonedTask.parent = parentTask.heriarchy.parent.heriarchy.parent.id;	
		  				}else{
		  					clonedTask.parent = null;
		  				}
		  			}
		  			else
		  			{
		  				clonedTask.heriarchy = new Heriarchy(parentTask.heriarchy.indent,parentTask.heriarchy.parent);
		  				clonedTask.parent = parentTask.parent;
		  			}
		  			clonedTask.position = parentTask.position + 1;
		  		}
		  		insertAt = clonedTask.position -1;
		  	}
		  	else if(action == Constants.ACTION_ADD_COPY)
		  	{
		  		//clonedTask.position = Components.instance.tasks.selectedTask.position;
		  		//clonedTask.heriarchy = new Heriarchy(Components.instance.tasks.selectedTask.heriarchy.indent, Components.instance.tasks.selectedTask.heriarchy.parent);
		  	}
		  	else if(action == Constants.ACTION_ADD_FIRST)
		  	{
		  		clonedTask.position = 1;
		  		clonedTask.heriarchy = new Heriarchy(0, null, null);
		  		insertAt = clonedTask.position - 1;
		  	}
		  	else if(action == Constants.ACTION_ADD_LAST)
		  	{
		  		clonedTask.position = Components.instance.tasks.allTasks.length + 1;
		  		clonedTask.heriarchy = new Heriarchy(0, null, null);
		  		insertAt = clonedTask.position;
		  	}
		  	else if(action == Constants.ACTION_ADD_WRITING)
		  	{
		  		clonedTask.position = Components.instance.tasks.allTasks.length + 1;
		  		clonedTask.heriarchy = new Heriarchy(0, null, null);
		  		
		  		insertAt = clonedTask.position - 1;
		  	}
	  		else if(action == Constants.ACTION_ADD_CHILD){
	  			clonedTask.position = parentTask.position + 1;
			  	clonedTask.heriarchy = new Heriarchy(parentTask.heriarchy.indent+1, parentTask);
			  	insertAt = clonedTask.position - 1;
			  	clonedTask.parent = parentTask.id;
	  		}
	  	
	  		clonedTask.position = insertAt;
			var addTaskCommand : CreateTaskCommand = new CreateTaskCommand(clonedTask);
			
			addTaskCommand.execute();
			addTaskCommand.success =
				function(){
					history.addCommand(addTaskCommand);
					dispatchEvent(new Event(Constants.TASKS_FILTERS));
					dispatchEvent(new Event(Constants.LOADING_END));
				}
			addTaskCommand.failure =
				function(){
					dispatchEvent(new Event(Constants.SYNCHRONIZING));
				}
		}

		/**
		 * Creates an edit Task command and executes it
		 */

		public function updateTask(task : UiTask, saveInHistory : Boolean = true) : void
		{	
			var updateTaskCommand : UpdateTaskCommand = new UpdateTaskCommand(task);
			updateTaskCommand.execute();
			updateTaskCommand.success =
				function(){
					history.addCommand(updateTaskCommand);
					dispatchEvent(new Event(Constants.TASKS_FILTERS));
					dispatchEvent(new Event(Constants.LOADING_END));		
				}
			updateTaskCommand.failure =
				function(){
					dispatchEvent(new Event(Constants.SYNCHRONIZING));
				}
		}
		
		/**
		 * Creates a delete Task command and executes it
		 */
        public function deleteTask(task : Task) : void
		{
			var tasks : ArrayCollection = new ArrayCollection();
			var clonedTask : Task = (UiTask(task)).clone();				
			
  			var deleteTaskCommand : DeleteTaskCommand = new DeleteTaskCommand(UiTask(task));
			deleteTaskCommand.execute();
			
			deleteTaskCommand.success =
				function(){
					history.addCommand(deleteTaskCommand);
					dispatchEvent(new Event(Constants.TASK_DESELECT));
					dispatchEvent(new Event(Constants.TASKS_FILTERS));
					dispatchEvent(new Event(Constants.LOADING_END));
				}
			deleteTaskCommand.failure =
				function(){
					dispatchEvent(new Event(Constants.SYNCHRONIZING));
				}
		}
	    

		/**
		 * Creates a new Dependency command and executes it
		 * @Deprecated
		 */
       public function addDependency(dependencies : Array, task : UiTask) : void
       {
			var clonedTask : UiTask = task.clone();
			var compositeCommand : CompositeCommand = new CompositeCommand();
			compositeCommand.addCommand(new CreateDependencyCommand(clonedTask, dependencies));
			compositeCommand.addCommand(new ReadTaskCommand(clonedTask));
			compositeCommand.success =
				function(){
					history.addCommand(compositeCommand);
					dispatchEvent(new Event(Constants.LOADING_END));
				};
			compositeCommand.failure =
				function(){
					dispatchEvent(new Event(Constants.SYNCHRONIZING));
				}
			compositeCommand.execute();
       }
		
		
		/**
		 * Creates an update Dependency command and executes it
		 */
		public function updateDependency(newDependencies : Array, oldDependencies : Array) : void
		{
			var clonedTask : Task = (UiTask(Components.instance.tasks.selectedTask)).clone();								
			var updateDependencyCommand : UpdateDependencyCommand = new UpdateDependencyCommand(clonedTask, newDependencies, oldDependencies);
			updateDependencyCommand.success =
				function(){
					history.addCommand(updateDependencyCommand);
					dispatchEvent(new Event(Constants.LOADING_END));
				};
			updateDependencyCommand.failure =
				function(){
					dispatchEvent(new Event(Constants.SYNCHRONIZING));
				}
			updateDependencyCommand.execute();
		}
		
		
		/**
		 * Creates a delete Dependency command and executes it
		 */
		public function deleteDependency(dependencies : Array, task : UiTask) : void
		{
			var clonedTask : UiTask = task.clone();									
			var deleteDependencyCommand : DeleteDependencyCommand = new DeleteDependencyCommand(clonedTask, dependencies);
			deleteDependencyCommand.success = function(){
					history.addCommand(deleteDependencyCommand);
					Components.instance.tasks.setParent(0);
					dispatchEvent(new Event(Constants.LOADING_END));
				};
			deleteDependencyCommand.failure =
				function(){
					dispatchEvent(new Event(Constants.SYNCHRONIZING));
				}
			deleteDependencyCommand.execute();
		}
			
		public function mergeResources(resources : ArrayCollection) : void{
			var originalResources : ArrayCollection = Components.instance.resources.resources;
			var project : Project = Components.instance.project;
			var mergeResourcesCommand : MergeResourcesCommand = new MergeResourcesCommand(resources,originalResources,project);
			mergeResourcesCommand.success = function(){
				history.addCommand(mergeResourcesCommand);
				dispatchEvent(new Event(Constants.LOADING_END));
			}
			mergeResourcesCommand.failure =
				function(){
					dispatchEvent(new Event(Constants.SYNCHRONIZING));
				}
			mergeResourcesCommand.execute();
		}	
			
		public function moveTask(taskToMove : UiTask,taskTarget : UiTask) : void{
			taskToMove.heriarchy = taskTarget.heriarchy.clone();
			taskToMove.parent = taskTarget.parent;
			
 			if(taskToMove.position <= taskTarget.position){
				taskToMove.position = taskTarget.position + taskTarget.heriarchy.getDescendants(taskTarget).length;
			}else{
				taskToMove.position = taskTarget.position;
			 /* }else{
			 	taskToMove.position = taskTarget.position -1; */
			}
			//Components.instance.tasks.move(taskToMove,taskTarget.position-1);
			updateTask(taskToMove);
		}
		
		public function checkIndent (task : UiTask) : Boolean{
			var valid : Boolean = Components.instance.tasks.checkIndent(task);
			return valid;
		}
		
		public function checkOutdent (task : UiTask) : Boolean{
			var valid : Boolean = Components.instance.tasks.checkOutdent(task);
			return valid;
		}
	
		public function updateProject(project : Project) : void{
			var updateProjectCommand : UpdateProjectCommand = new UpdateProjectCommand(project);
			updateProjectCommand.success = function(){
				dispatchEvent(new Event(Constants.LOADING_END));
			}
			updateProjectCommand.failure =
				function(){
					dispatchEvent(new Event(Constants.SYNCHRONIZING));
				}
			updateProjectCommand.execute();
		}
		
		public function loadUsersOnDemand(pattern : String, collection : ArrayCollection,filteredIds : ArrayCollection) : void{
			var readUserOnDemandCommand : ReadUserOnDemandCommand = new ReadUserOnDemandCommand(pattern,collection,filteredIds);
			readUserOnDemandCommand.execute();
		}
		
		public function synchronize(project : Project) : void{
			var retrieveCommand : RetrieveCommand = new RetrieveCommand(project);
			retrieveCommand.success = function(){
				SyncInfo.instance.alreadyShow = false;
				// clean the history.
				history.init();
				dispatchEvent(new Event(Constants.LOADING_END));
			}
			retrieveCommand.execute();	
		}
			
		public function result(response : Object) : void{
			Components.instance.tasks.setParent();
			dispatchEvent(new Event(Constants.TASKS_FILTERS));
			dispatchEvent(new Event(Constants.LOADING_END));
		}
		
		public function fault(response : Object) : void{
			dispatchEvent(new Event(Constants.LOADING_END));
		}
		
	}
}
