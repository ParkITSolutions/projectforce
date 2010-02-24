package com.salesforce.gantt.controller
{
	import com.salesforce.gantt.model.Calendar;
	import com.salesforce.gantt.model.Dependency;
	import com.salesforce.gantt.model.Task;
	import com.salesforce.gantt.model.UiTask;
	
	import mx.collections.ArrayCollection;
	
	public class Tasks implements ITasks
	{
		
		private var _selectedTask : UiTask = null;
		[Bindable]
		public var clipBoardTasks : ArrayCollection = new ArrayCollection();
			
		[Bindable]
		public var allTasks : ArrayCollection = new ArrayCollection();
		
		/**
		 * Constructor
		 */
		public function Tasks()
		{
		}
		
		[Bindable]
		public function get selectedTask() : UiTask{
			if(_selectedTask){
				return _selectedTask.clone();
			}
			return null;
		}
		
		public function set selectedTask(task : UiTask) : void{
			_selectedTask = task;
		}
		
		/**
		 * Copies a task in memory and assigns action='cut' to remember that
		 * when pasting, in addition to create a new task
		 * the original one must be deleted.
		 **/
		public function cut() : void{
			copy();
		}
		
		
		/**
		 * Copies a task in memory
		 **/
		public function copy() : void
		{
			resetAlphaCut();
			clipBoardTasks.removeAll();
			var parentHierarchy : UiTask = UiTask(selectedTask).clone();
			clipBoardTasks.addItem(parentHierarchy);
			var getChildrens : ArrayCollection = selectedTask.heriarchy.getDescendants(selectedTask);
			var descendent : UiTask;
			var newIndent : int;
			for(var i : int = 0; i<getChildrens.length; i++)
			{
				descendent = UiTask(getChildrens.getItemAt(i)).clone();
				descendent.heriarchy.indent = descendent.heriarchy.indent - parentHierarchy.heriarchy.indent;
				clipBoardTasks.addItem(descendent);
			} 
			parentHierarchy.heriarchy.indent = 0;
		}
		
		
		/**
		 * Pastes a task in memory
		 **/
		public function paste() : void
		{	
			resetAlphaCut();
			setParent();
		}
		
		
		/**
		 * Leaves all tasks with default alpha
		 * Called to unmark the cut task.
		 **/
		private function resetAlphaCut() : void
		{
			for(var i : int = 0; i < allTasks.length; i++)
			{
				UiTask(this.allTasks.getItemAt(i)).alphaCut = 0.1;
			}
		}
		
		
        /**
        * Called when the app is loaded, after indenting a task,
        * when tasks are created or edited.
        * 
        * Updates Hierarchies (adding or removing) between tasks
        * Updates next task pointer.
        * Adds or removes images (plus and minus signs)
        */
        public function setParent(findStart : int = 0) : ArrayCollection
        {	
			var task : Task = null;
			var taskNext : Task = null;
			var parentTask : Task = null;
			for(var i : int = 0; i < allTasks.length; i++)
			{
				Task(allTasks.getItemAt(i)).position = i+1;
			}
       		for(i = findStart; i < allTasks.length; i++)
			{
				task = Task(allTasks.getItemAt(i));
				task.heriarchy.parent = null;
				task.heriarchy.next = null;
				//task.parent = null;
				taskNext = null;
				if((i+1)<allTasks.length)
				{
					taskNext = Task(allTasks.getItemAt(i+1));
				}
				task.heriarchy.next = taskNext;
			
				//Asign a parent to the heriarchy
	       		for( var j : int = i; j >= 0; j--)
				{	
					parentTask = Task(allTasks.getItemAt(j));
					if(task.heriarchy.setParent(parentTask))
					{
						var dependency : Dependency = null;
						if(task.isParent(parentTask))
						{
							dependency = Dependency(task.getDependency(parentTask.id,'idParent'));
							if(dependency != null)
							{
								//TODO fixed to not show identity deleted message.
								//Components.instance.controller.deleteDependency([dependency], task);
								task.removeDependency(dependency);
							}
						}
						else if(parentTask.isParent(task))
						{
							dependency = Dependency(parentTask.getDependency(task.id,'idParent'));
							if(dependency != null)
							{
								//TODO fixed to not show identity deleted message.
								//Components.instance.controller.deleteDependency([dependency], taskParent);
								parentTask.removeDependency(dependency);
							}
						}
						
						// set parent to the new attribute of task class
						task.parent = parentTask.id;
						break;
					}
				}
			}
			var modifiedTasks : ArrayCollection = new ArrayCollection();
			for(i = allTasks.length - 1; i >= 0; i--)
			{
				//readjusts start and end dates of parent tasks according to its childrens
				var selectedTask : Task = Task(allTasks.getItemAt(i)); 
				if(selectedTask.heriarchy.hasChildren(selectedTask.id) && setDates(selectedTask)){
					if(!modifiedTasks.contains(selectedTask)){
						modifiedTasks.addItem(selectedTask);
					}
				}
			}
			
			return modifiedTasks;	
			
       	}
       	
		/**
		* Check the integrity of the tasks, moving task to a correct position
		*  when 
		* it has a parent as attribute task.parent but this parent
		* is not present among the tasks. 
		*/ 
		public function checkParent(findStart : int = 0) : void{
			var actualTask : Task;
			var task : Task;
			var parentIndex : int;
			for(var i:int=findStart;i<allTasks.length;i++){
				actualTask = Task(allTasks.getItemAt(i));
				parentIndex = -1;
				for(var j:int=0;j<allTasks.length;j++){
					task = Task(allTasks.getItemAt(j));
					if(actualTask.parent && (actualTask.parent == task.id 
						&& (actualTask.heriarchy.indent != task.heriarchy.indent + 1 || j > i))){
						actualTask.heriarchy.indent = task.heriarchy.indent + 1;
						parentIndex = j;	
					}
				}
				
				if(actualTask.parent && parentIndex!=-1){
					//the parent is below to its child
					if(parentIndex > i){
						allTasks.removeItemAt(i);
						//allTasks.addItem(actualTask);
						if(j>=allTasks.length){
							allTasks.addItem(actualTask);
						}else{
							allTasks.addItemAt(actualTask,j+1);	
						}
						i--;
					}else{
						//check integrity amongs tasks from position i and i+1
						if(parentIndex + 1 < i){
							allTasks.removeItemAt(i);
							allTasks.addItemAt(actualTask,parentIndex+1);
						}
					}
				}
				
			}
			
			var parent : UiTask;
			for each(var grtask : UiTask in allTasks){
				parent = getTask(grtask.parent);
				if(parent){
					parent.addOrUpdateChildTask(grtask);
				}
			}
		}
       	
       	
       	
       	/**
	 	* Updates start and end date for all tasks.
	 	* Called everytime a task's date is edited or created.
	 	*/
       	private function setDates(taskParent : Task) : Boolean
       	{
       		var changedTaskDates : Boolean = false;
       		var sum : int = 0;
       		var startDateTemp : Date = new Date();
			var endDateTemp : Date = new Date();
			var childs : ArrayCollection = taskParent.heriarchy.getDescendants(taskParent);
			for (var i : int = 0; i < childs.length; i++)
			{
				var child : Task = Task(childs.getItemAt(i));
				if(child.startDate.getTime() < startDateTemp.getTime() || i == 0)
				{
					startDateTemp.setTime(child.startDate.getTime());
				}
				if(child.endDate.getTime() > endDateTemp.getTime() || i == 0)
				{
					endDateTemp.setTime(child.endDate.getTime()); 
				}
				sum += child.completed;
			}
			
			taskParent.isMilestone = false;
			taskParent.completed = sum / childs.length;
			
			// if the start date has changed
			if(taskParent.startDate.getTime() - startDateTemp.getTime() != 0){
				taskParent.startDate.setTime(startDateTemp.getTime());
				changedTaskDates = true;	
			}
			
			// if the end date has changed
			if(taskParent.endDate.getTime() - endDateTemp.getTime() != 0){
				taskParent.endDate.setTime(endDateTemp.getTime());
				changedTaskDates = true;	
			}
			
			//update the duration if changedTaskDates is true
			var durationInDays : Number = taskParent.durationInWorkingDays();
			if(changedTaskDates){
				if(taskParent.project.durationInHours){
					taskParent.duration = taskParent.project.convertToHours(durationInDays);
				}else{
					taskParent.duration = durationInDays;
				}
				
			}
			
			allTasks.setItemAt(taskParent, taskParent.position - 1);
			return changedTaskDates;
       	}
       	
       	/**
       	* Returns the first task of allTasks array.
       	*/
       	private function getFirstTask() : Task
       	{
       		if(allTasks.length > 0)
       		{
       			return Task(allTasks.getItemAt(0));
       		}
       		return null;
       	}
       
       
       	/**
		* Returns the task with Id == id.
		* 
		*/
	   	public function getTask(id : String) : UiTask
       	{
       		//var task : Task = null;
			for( var i : int = 0; i < allTasks.length; i++)
			{
				//task = Task(allTasks.getItemAt(i));
				if(allTasks.getItemAt(i).id == id)
				{
					return UiTask(allTasks.getItemAt(i));
				}
			}
			return null
       	}
		
		/**
		 * Returns the tasks which id is in ids array.
		 * @param ids are the ids of the tasks to select.
		 * @return a arrayCollection of the selected tasks.
		 */ 
		public function getTasks(ids : ArrayCollection) : ArrayCollection{
			var selectedTasks : ArrayCollection = new ArrayCollection();
			var task : UiTask;
			var id : String;
			var found : Boolean;
			for(var i:int=0;i<ids.length;i++){
				id = String(ids.getItemAt(i));
				found = false;
				for(var j:int=0;!found&&j<allTasks.length;j++){
					task = UiTask(allTasks.getItemAt(j));
					if(id==task.id){
						task = UiTask(task.clone());
						found = true;
					}
				}
				if(found){
					selectedTasks.addItem(task);	
				}
			}
			return selectedTasks;
		}
       
       	/**
		* Returns the task with Id == id.
		*/
		public function getTaskIndex(index : int) : UiTask
       	{
       		var task : UiTask = UiTask(allTasks.getItemAt(index));
       		return task;
       	}
       
       
       	/**
		* returns the index of a task in the allTasks array.
		*/
       	private  function getPosition(task : Task) : int
       	{
			var taskIterator : Task = null;
			for(var i : int = 0; i < this.allTasks.length; i++)
			{
				taskIterator = Task(this.allTasks.getItemAt(i));
				if(taskIterator.id == task.id)
				{
					return i; 
				}
			}
			return -1;
       	}
       	
       	
	    /**
		 * Called when a task is selected
		 */
	    public function select (id : String) : void
	    {
	    	var task : UiTask = getTask(id);
	    	if(task != null)
	    	{
	    		selectedTask = UiTask(task.clone()); 		
		    }				
	    }
	    
	    public function deSelect(): void{
	    		selectedTask = null;
	    }
	    
	    /**
		 * Returns the list of posible parent task of the given task.
		 */
	    public function possibleParentTasks(taskChild : Task , addDummyTask : Boolean = false) : ArrayCollection{
	    	var parentTasks : ArrayCollection = new ArrayCollection();
			if(addDummyTask){
				var dummyTask : Task = new Task('none');
				parentTasks.addItem(dummyTask);
			}
			for(var i : int = 0; i < allTasks.length ; i++)
	    	{
	    		var task : Task = Task(allTasks.getItemAt(i));
	    		//If task is not parent of taskChild and taskChild is not parent of task
    			if(task.id != taskChild.id && !taskChild.isAncestor(task))
	    		{
	    			parentTasks.addItem(task);
	    		}
	    	}
	    	return parentTasks;
		}
		
		public function possibleTaskDependencies(taskChild : Task) : ArrayCollection{
			var taskDependencies : ArrayCollection = new ArrayCollection();
			
			if(!taskChild.hasChildren()){
				for(var i : int = 0; i < allTasks.length ; i++)
		    	{
		    		var task : Task = Task(allTasks.getItemAt(i));
		    		//filter by not successors and parents.
	    			if(task.id != taskChild.id && !taskChild.isSuccessor(task) && !taskChild.isDescendent(task) && !taskChild.isAncestor(task))
		    		{
		    			taskDependencies.addItem(task);
		    		}
		    	}
			}
	    	return taskDependencies;
		}
		
		/**
		 * Returns the list of tasks to be shown
		 */
		 private var visibleTasks : ArrayCollection = new ArrayCollection();
		 [Bindable]
		 public var countDeleted : int = 0;
		
		public function filterVisibleTask(depth : int = 0) : ArrayCollection
		{
			var hasAdd : Boolean = false;
			var positionVisible : int = 1;

			for(var i : int = 0; i < allTasks.length; i++)
			{	
				var task : UiTask = UiTask(allTasks.getItemAt(i));
				
				task.position = i + 1;
				task.positionVisible = positionVisible;
				hasAdd = false;
				
				if(task.heriarchy.parent != null)
				{
					if(task.isVisible())
					{
						hasAdd = true;
					}
				}
				else
				{
					hasAdd = true;
				}
				if(hasAdd 
					//&& task.heriarchy.indent <= depth 
					)
				{
					if(visibleTasks.length >= positionVisible)
					{
						visibleTasks.setItemAt(task,positionVisible-1);
					}
					else
					{
						visibleTasks.addItem(task);
					}
					positionVisible++;
				}
			}
			var countNotVisible : int = allTasks.length + countDeleted - (positionVisible - 1);
			for(i = countNotVisible-1; i>=0; i--)
			{
				if(visibleTasks.length>=(positionVisible + i))
				{
					visibleTasks.removeItemAt(positionVisible - 1 + i);
				}
			}
			countDeleted = 0;
			
			// TODO
			// temporal patch to remove the tasks not found in the alltasks collection
			//
			var found : Boolean;
			var taskTemp : UiTask;
			for(var j:int=0;j<visibleTasks.length-1;j++){
				task = UiTask(visibleTasks.getItemAt(j));
				found = false;
				for(var k:int=0;!found && k<allTasks.length;k++){
					taskTemp = UiTask(allTasks.getItemAt(k));
					found = task.id == taskTemp.id;
				}
				if(!found){
					visibleTasks.removeItemAt(j);
				}
			}
			return visibleTasks;
		}
		
		/**
		 * Returns all parentTask's child tasks.
		 * 
		 * @param parentTask The task to retreive its childs.
		 * @return ArrayCollection The list of child tasks.
		 */
		public function getTaskDependencyChild(parentTask : Task) : ArrayCollection
		{
			var taskDependenciesChild : ArrayCollection = new ArrayCollection();
			for(var i : int = 0; i < allTasks.length; i++)
			{
				var task : Task = Task(allTasks.getItemAt(i));
				for(var j : int = 0; j < task.dependencies.length; j++)
				{
					var dependency : Dependency = Dependency(task.dependencies.getItemAt(j));
					if(dependency.task.id == parentTask.id)
					{
						taskDependenciesChild.addItem(task);
					}
				}
			}
			return taskDependenciesChild;
		}
		
		
		/**
		 * Assigns createdBy and lastModified user's id to all tasks
		 */
		public function setTaskUsers() : void
		{
			for(var i : int = 0; i < allTasks.length;i++)
			{
				var task : Task = Task(allTasks.getItemAt(i));
				task.createdBy = Components.instance.users.getUser(task.createdBy.id);
				task.lastModified = Components.instance.users.getUser(task.lastModified.id);
			}
		}
		
		
		/**
		 * Returns the task with the lower endDate.
		 * 
		 * @return Task
		 */
		public function firstTask() : Task
		{
			var firstTask : Task = null;
			for(var i : int = 0; i < allTasks.length;i++)
			{
				var task : Task = Task(allTasks.getItemAt(i));
				if(i==0)
				{
					firstTask = task;
				}
				if(task.startDate.getTime() < firstTask.startDate.getTime())
				{
					firstTask = task;
				}
			}
			return firstTask;
		}
		
		
		/**
		 * Calculates and update all start and end dates
		 * Called when a task is created, edited or deleted.
		 */
		public function refreshDates() : void
		{
			var startDateAux : Date = new Date();
			var endDateAux : Date = new Date();
			for(var i : int =0; i < allTasks.length; i++)
			{
				var task : Task = Task(allTasks.getItemAt(i));
				if(task.startDate.getTime()<startDateAux.getTime())
				{
					startDateAux.setTime(task.startDate.getTime());
				}
				if(task.endDate.getTime()>endDateAux.getTime())
				{
					endDateAux.setTime(task.endDate.getTime());
				}
			}
			Calendar.startDate.setTime(Calendar.add(startDateAux, -20).getTime());
			Calendar.endDate.setTime(Calendar.add(endDateAux,20).getTime());
		}
		
		/**
		 * Adds a task to allTasks collection and updates all task' positions.
		 * 
		 * @param task The task to insert
		 * @param index Where to insert the task into the ArrayCollection
		*/
		public function addTaskAt(task : Task, index : int = -1) : void{
			if(index == -1 || index>allTasks.length){
				allTasks.addItem(task)
			}
			else{
				allTasks.addItemAt(task, index);	
			}
			for (var i : int = index; index!= -1 && i < allTasks.length; i++){
				Task(allTasks[i]).position = i +1;				
			}
		}
					
		/**
		 *  Enqueue a child task and its descendent , removing them from its actual position
		 * 
		 * @param parentTask the task which contains children tasks
		 * @param task a child task of parentTask
		 */
		public function moveTaskAtEnd(parentTask : Task,task : Task) : void{
			
			var childrenTask :ArrayCollection = new ArrayCollection(); 
			var positionMaxChild : int = allTasks.length;
			if(parentTask!=null){
				positionMaxChild = parentTask.position;
				childrenTask = parentTask.heriarchy.getDescendants(parentTask);
			}
			var taskChild : Task;
			for(var i : int = 0;i<childrenTask.length;i++){
				taskChild = Task(childrenTask.getItemAt(i));
				if(task.id != taskChild.id && positionMaxChild < taskChild.position){
					positionMaxChild = taskChild.position;
				}
			}	
			
			//if the task is added as last child
			if(positionMaxChild+1>allTasks.length){
					allTasks.addItem(task);
					// get children from the task and move them too
					moveChildren(task);
				}else{
					//if the parentTask is not null and the position + 1 is lower than task position.
					if(parentTask!=null && parentTask.position + 1 < task.position){
						positionMaxChild--;
						task.position++;
					}
					allTasks.addItemAt(task,positionMaxChild+1);
					// get children from the task and move them too
					moveChildren(task);	
				}
					
			allTasks.removeItemAt(task.position - 1);
		}
		
		private function moveChildren(task : Task): void{
			var children : ArrayCollection = task.heriarchy.getDescendants(task);
			
			if(children.length != 0){
				//added the children to the end of task collection
				for(var i : int = 0 ; i<children.length;i++){
					allTasks.addItem(children.getItemAt(i));
				}
				
				var posFirstChild : int = Task(children.getItemAt(0)).position;
				//removed the children from their old positions
				for(var j : int = 0; j<children.length;j++){
					allTasks.removeItemAt(posFirstChild-1);
				}	
			}
			
		}
		
		/**
		 * Update the task in the tasks collection
		 * depending on if it has a new parent
		 */
		public function updateParentTask(newParentTask : Task , task : Task) : void{
			
			var oldParentTask : Task = task.heriarchy.parent;
			var parentChanged : Boolean = false;
			if(newParentTask){
				if(oldParentTask){
					parentChanged = newParentTask.id != oldParentTask.id;
				}else{
					parentChanged = true;
				}
			}else{
				parentChanged = oldParentTask != newParentTask;
			}
			if(parentChanged)
			{
				moveTaskAtEnd(newParentTask,task);
				task.heriarchy.parent = newParentTask;
				if(newParentTask!=null){
					task.parent = newParentTask.id;	
					task.heriarchy.indent = newParentTask.heriarchy.indent + 1;
					for each( var successor : UiTask in newParentTask.successors){
						for each( var dependency : Dependency in successor.dependencies){
							if(dependency.task.id == newParentTask.id){
								successor.removeDependency(dependency);
							}
						}
					}
					for each( var dependency : Dependency in newParentTask.dependencies){
						newParentTask.removeDependency(dependency);
					}
					//FIXME remove the dependencies when a task is a parent /////////////
					//Components.instance.controller.deleteDependency(newParentTask.dependencies.toArray(),newParentTask);
					/////////////////////////////////////////////////////////////////////
				}else{
					task.parent = null;
					task.heriarchy.indent = 0;
				}
				task.updateChildren();
				
				if(oldParentTask){
					oldParentTask.removeChildTask(task);	
				}
				if(newParentTask){
					newParentTask.addOrUpdateChildTask(task);	
				}
			}	
		}
		
		/**
		 *	Given a task return the original ancestor of a hierarchy of tasks 
		 *  otherwise return itself.
		 *  @param task to look for it original ancestor
		 *  @return the original ancestor
		 */
		public function originalAncestor(task : Task) : Task{
			if(task.heriarchy.parent == null){
				return task;
			}else{
				return originalAncestor(task.heriarchy.parent);
			}
		}
		
		/**
		 * Given a selected task return the next task
		 * @return Task
		 */  
		public function nextTask(selectTask : Boolean = false) : UiTask{
			var nextTask : UiTask = null;	
			var nextPosition : int = 0;
			if(allTasks.length > 0){
				if(selectedTask){
					nextPosition = (selectedTask.position % allTasks.length);
				}
				nextTask = UiTask(allTasks.getItemAt(nextPosition));
				if(selectTask){
					selectedTask = nextTask;
				}
			}
			return nextTask;
		}
		
		/**
		 * Given a selected task return the previous task
		 * @return Task
		 */
		public function previousTask(selectTask : Boolean = false) : UiTask{
			var previousTask : UiTask = null;	
			var prevPosition : int = allTasks.length-1;
			if(allTasks.length > 0){
				if(selectedTask && selectedTask.position != 1){
					prevPosition = ((selectedTask.position - 2)% allTasks.length);
				}
				previousTask = UiTask(allTasks.getItemAt(prevPosition));
				if(selectTask){
					selectedTask = previousTask;
				}	
			}
			return previousTask;
		}
		
		public function getIds() : Array{
			var ids : Array = new Array();
			var task : Task;
			for(var i : int=0;i<allTasks.length;i++){
				task = Task(allTasks.getItemAt(i));
				ids.push(task.id);
			}
			return ids;	
		}
		
		public function deleteTasks(ids : Array) : void{
			var id : String;
			var task : Task;
			while(ids.length > 0){
				id = ids.pop();
				for(var i : int=0;i<allTasks.length;i++){
					task = Task(allTasks.getItemAt(i));
					if(task.id == id){
						allTasks.removeItemAt(i);
						break;
					};	
				}
				for(var j : int=0;j<visibleTasks.length;j++){
					task = Task(visibleTasks.getItemAt(j));
					if(task.id == id){
						visibleTasks.removeItemAt(j);
						break;
					}	
				}
			}	
		}
		
		public function length() : int{
			return allTasks.length;
		}
		
		public function move(task : Task,position : int) : void{
			var currentTask : UiTask;
			var found : Boolean = false;
			var index : int = position > 0? position -1 : 0;
			for(var i:int = 0; !found && i<allTasks.length; i++){
				currentTask = UiTask(allTasks.getItemAt(i));
				found = currentTask.id == task.id;
				if(found){
					allTasks.removeItemAt(i);
					allTasks.addItemAt(task,index);	
				}
			}
		}
		
		public function checkMove(taskDraged : Task,taskTarget : Task) : Boolean{
			var validate : Boolean = false;
			if(taskDraged.id!=taskTarget.id && !taskDraged.hasChildren())
			{
				validate = true;
			}
			return validate;
		}
		
		/**
		 * Given a task, check if it is possible to indent it
		 * @param task : task to check for this action to be performed.
		 * @return true if it is valid, otherwise false. 
		 */
		public function checkIndent(task : UiTask) : Boolean{
			var valid : Boolean = false;
			if(task){
				var parentTask : Task = task.heriarchy.parent;
				//if it is not the first task
				valid = task.position != 1;
				if(parentTask){
					//if parent position is not previous of this task.
					valid &&= parentTask.position != task.position -1;
				}	
			}
			
			return valid;
		}
		
		/**
		 * Given a task, check if it is possible to outdent it
		 * @param task : task to check for this action to be performed.
		 * @return true if it is valid, otherwise false. 
		 */
		public function checkOutdent(task : UiTask) : Boolean{
			var valid : Boolean = false;
			if(task){
				var parentTask : Task = task.heriarchy.parent
				valid = task.position != 1 && parentTask;
			}
			return valid;
		}
		
	}
}