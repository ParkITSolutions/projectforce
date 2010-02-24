package com.salesforce.gantt.commands.taskResource
{
	import com.salesforce.gantt.commands.SimpleCommand;
	import com.salesforce.gantt.controller.Components;
	import com.salesforce.gantt.model.Task;
	import com.salesforce.gantt.model.TaskResource;
	import com.salesforce.gantt.util.ErrorHandler;
	
	import flash.events.Event;
	
	import mx.rpc.IResponder;
	
	public class DeleteTaskResourceCommand extends SimpleCommand
	{
		/** The Task the Resource will be deleted from **/
		private var task : Task;
		/** The Resources that will get deleted from the Task **/
		private var taskResources : Array;

		/**
		 * Constructor
		 * 
		 * task is the Task that will have the Resources deleted from
		 * resources are the Resources that will get deleted from this Task 	 
		 */
		
		public function DeleteTaskResourceCommand(task : Task, taskResources : Array) : void
		{
			super();
			this.task = task;
			this.taskResources = taskResources;
		}
        
        /**
        * Executes the command of deleting the Resources from the task
        */
        
        override public function execute() : void
        {
        	var arrayIds : Array = new Array();
        	var taskResource : TaskResource;
        	for each(var taskResource : TaskResource in taskResources){
        		arrayIds.push(taskResource.id);
        	}
			Components.instance.salesforceService.taskResourceOperation.deleteTaskResource(arrayIds,this);
		}
		
		/**
        * Undoes the command of deleting Resources from the Task
        */
		
		override public function undo (responder : IResponder) : void
		{
    		var addTaskResourceCommand : CreateTaskResourceCommand = new CreateTaskResourceCommand(task,taskResources);
			addTaskResourceCommand.addEventListener(SimpleCommand.COMPLETE,responder.result);
			addTaskResourceCommand.execute();
		}
		
		override protected function actionCallBack(response : Object) : void
	  	{
  			for each(var taskResource : TaskResource in taskResources){
    			task.removeTaskResource(taskResource.id);
    		}	
    		Components.instance.tasks.allTasks.setItemAt(task, task.position-1);
		}
	}
}