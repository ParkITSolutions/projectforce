package com.salesforce.gantt.commands.task
{
	import com.salesforce.gantt.commands.CompositeCommand;
	import com.salesforce.gantt.commands.dependency.CreateDependencyCommand;
	import com.salesforce.gantt.commands.dependency.DeleteDependencyCommand;
	import com.salesforce.gantt.commands.dependency.UpdateDependencyCommand;
	import com.salesforce.gantt.commands.taskResource.CreateTaskResourceCommand;
	import com.salesforce.gantt.commands.taskResource.DeleteTaskResourceCommand;
	import com.salesforce.gantt.commands.taskResource.UpdateTaskResourceCommand;
	import com.salesforce.gantt.controller.Components;
	import com.salesforce.gantt.model.Calendar;
	import com.salesforce.gantt.model.Dependency;
	import com.salesforce.gantt.model.UiTask;
	import com.salesforce.gantt.util.CustomArrayUtil;
	import com.salesforce.gantt.view.components.form.event.SResultEvent;
	import com.salesforce.results.SaveResult;
	
	import mx.collections.ArrayCollection;	
	
	/**
	 * Command responsible for updating a task 
	 * 
	 * @author Rodrigo Birriel
	 */
	public class UpdateTaskCommand extends CompositeCommand
	{
	
		/**
		 * Constructor
		 * @param newTasks is a task collection
		 * 
		 */ 
		 
		public function UpdateTaskCommand(newTask : UiTask ,hasUndoCommand : Boolean = true) : void
		{
			var oldTask : UiTask = UiTask(Components.instance.tasks.getTask(newTask.id));
			this.newObject = newTask.clone();
			this.oldObject = oldTask;
			if(hasUndoCommand){
				var parentTask : UiTask;
				var undoUpdateTaskCommand : UpdateTaskCommand = new UpdateTaskCommand(UiTask(oldObject),false)
				this.undoCommand = undoUpdateTaskCommand;
				if(newTask.parent){
					parentTask = Components.instance.tasks.getTask(newTask.parent).clone();
					undoUpdateTaskCommand.addCommand(new UpdateTaskCommand(parentTask));		
				}
			}
		}
        
		/**
        * Executes the command of updating the tasks
        */
        override public function execute() : void{
        	Components.instance.salesforceService.taskOperation.update(UiTask(newObject),this);
		}
		
		override protected function actionCallBack(response : Object) : void{
			//////FIXME//////
			Components.instance.controller.dispatchEvent(new SResultEvent(response));
			/////////////////
			var record : SaveResult;
			var newParentTask : UiTask;
			var task : UiTask = UiTask(newObject);
			var oldTask : UiTask = UiTask(oldObject);
			var durationOldTask : int = Calendar.workingDays(oldTask.startDate,oldTask.endDate);
			var durationNewTask : int = Calendar.workingDays(task.startDate,task.endDate);
			var moving : Boolean = durationOldTask == durationNewTask;
			record = response[0];
			
			if(record.success && record.id == task.id){
				newParentTask = Components.instance.tasks.getTask(task.parent);
				if(!moving){
					Components.instance.tasks.updateParentTask(newParentTask,task);	
				}else{
					Components.instance.tasks.move(task,task.position);	
				}	
			}
			updateLocalDependencies(task);
			addCommands(task,oldTask);
			
			addCommand(new ReadTaskCommand(task));
			
			super.execute();
		}
		
		/**
		 * When a task is modified, i have to update the tasks which have references to this,
		 * these references are kept in the successors's collection for each task.
		 */
		private function updateLocalDependencies(task : UiTask) : void{
			for each( var successor : UiTask in task.successors){
				Components.instance.tasks.allTasks.setItemAt(successor,successor.position-1);
			}
		}
		
		/** 
		 * Added the subcommands for the dependencies and the task's resources.
		 */
		private function addCommands(newTask : UiTask,originalTask : UiTask) : void{
			
			var elementsUpdated : ArrayCollection;
			var taskResourcesAdded : ArrayCollection;
			var taskResourcesDeleted : ArrayCollection;
			var taskResourcesOriginalUpdated : ArrayCollection;
			var taskResourcesNewUpdated : ArrayCollection;
			
			var dependenciesAdded : ArrayCollection;
			var dependenciesDeleted : ArrayCollection;
			var dependenciesOriginalUpdated : ArrayCollection;
			var dependenciesNewUpdated : ArrayCollection;
			
			var taskResourcesOriginal : ArrayCollection = originalTask.taskResources;
			var dependenciesOriginal : ArrayCollection = originalTask.dependencies;
			var taskResourcesNew : ArrayCollection = newTask.taskResources;
			var dependenciesNew : ArrayCollection = newTask.dependencies;
			
			dependenciesAdded = CustomArrayUtil.extractAdded(dependenciesOriginal,dependenciesNew);
			elementsUpdated = CustomArrayUtil.extractUpdated(dependenciesOriginal,dependenciesNew);
			dependenciesOriginalUpdated = elementsUpdated.getItemAt(0) as ArrayCollection;
			dependenciesNewUpdated	= elementsUpdated.getItemAt(1) as ArrayCollection;
			dependenciesDeleted = CustomArrayUtil.extractDeleted(dependenciesOriginal,dependenciesNew);
			
			taskResourcesAdded = CustomArrayUtil.extractAdded(taskResourcesOriginal,taskResourcesNew);
			elementsUpdated = CustomArrayUtil.extractUpdated(taskResourcesOriginal,taskResourcesNew);
			taskResourcesOriginalUpdated = elementsUpdated.getItemAt(0) as ArrayCollection;
			taskResourcesNewUpdated = elementsUpdated.getItemAt(1) as ArrayCollection;
			taskResourcesDeleted = CustomArrayUtil.extractDeleted(taskResourcesNew,taskResourcesOriginal);
			
			if(taskResourcesAdded.length > 0){
				addCommand(new CreateTaskResourceCommand(newTask,taskResourcesAdded.toArray()));	
			}
			if(taskResourcesOriginalUpdated.length > 0){
				addCommand(new UpdateTaskResourceCommand(newTask,taskResourcesOriginalUpdated.toArray(),taskResourcesNewUpdated.toArray()));
			}
			if(taskResourcesDeleted.length > 0){
				addCommand(new DeleteTaskResourceCommand(newTask,taskResourcesDeleted.toArray()));	
			}
			if(dependenciesAdded.length > 0){
				addCommand(new CreateDependencyCommand(newTask,dependenciesAdded.toArray()));	
			}
			if(dependenciesOriginalUpdated.length > 0){
				addCommand(new UpdateDependencyCommand(newTask,dependenciesNewUpdated.toArray(),dependenciesOriginalUpdated.toArray()));	
			}
			if(dependenciesDeleted.length > 0){
				addCommand(new DeleteDependencyCommand(newTask,dependenciesDeleted.toArray()));	
			}
		}
	}
}