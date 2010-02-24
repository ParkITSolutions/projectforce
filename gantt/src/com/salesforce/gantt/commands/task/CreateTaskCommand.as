package com.salesforce.gantt.commands.task
{
	import com.salesforce.gantt.commands.CompositeCommand;
	import com.salesforce.gantt.commands.dependency.CreateDependencyCommand;
	import com.salesforce.gantt.commands.taskResource.CreateTaskResourceCommand;
	import com.salesforce.gantt.controller.Components;
	import com.salesforce.gantt.model.UiTask;
	import com.salesforce.gantt.view.components.form.event.SResultEvent;
	
	/**
	 * Class responsible to add new task to the project. 
	 * 
	 * @author Rodrigo Birriel
	 */	
	public class CreateTaskCommand extends CompositeCommand
	{
		/** The Task to add to the list and the database **/
		private var task : UiTask;
		private var parentTask : UiTask;
		
		/**
		 * Constructor
		 * task is the Task to add to the list and the database.
		 */
		public function CreateTaskCommand(task : UiTask, hasUndoCommand : Boolean = true) : void
		{
			super();
			this.task = task;
			if(hasUndoCommand){
				var undoDeleteTaskCommand : DeleteTaskCommand = new DeleteTaskCommand(task,false);
				this.undoCommand = undoDeleteTaskCommand;
				// an updateTaskCommand is added to undoCommand parent to keep old data of the future parent.
				if(task.parent){
					parentTask = Components.instance.tasks.getTask(task.parent);
					undoDeleteTaskCommand.addCommand(new UpdateTaskCommand(parentTask.clone()));		
				}
			}
		}
        
        /**
        * Executes the command of adding this Task to the list and to the database
        * 
        */
        override public function execute() : void
        {
        	if(undoCommand){
				Components.instance.salesforceService.taskOperation.create(task,this);
        	}else{
        		Components.instance.salesforceService.taskOperation.undeleteTasks([task.id],this);
        	}
		}
		
		override protected function actionCallBack(response : Object) : void 
  		{
  			// FIXME //
  			Components.instance.controller.dispatchEvent(new SResultEvent(response));
  			/////////
  			if(response is Array){
  				task.id = response[0].id;
  			}
  			//added the new task to the tasks's collection
  			Components.instance.tasks.addTaskAt(task, task.position);
  			
  			//added the task to respective parent if exists.
  			if(parentTask){
  				parentTask.addOrUpdateChildTask(task);
  			}
  			
  			if(response.length > 0){
  				
  				// checks if there are dependencies to save.
				if(task.dependencies.length > 0){
					var dependencies : Array = task.dependencies.toArray();
					task.dependencies.removeAll();
					addCommand(new CreateDependencyCommand(task,dependencies));
				}
				
				var taskResources : Array;
				if(task.taskResources.length > 0){
					taskResources = task.taskResources.toArray();
					task.taskResources.removeAll();
				} 
				// if the task has not an associated resource, assign it the user logged.
				else if(task.taskResources.length == 0){
					//TODO please remove this method 
					taskResources = [Components.instance.getUserTaskResource()];
				}
				addCommand(new CreateTaskResourceCommand(task,taskResources));
				
				addCommand(new ReadTaskCommand(task));
	  			super.execute();
  			}
  		}
	}
}