package com.salesforce.gantt.commands.taskResource
{
	import com.salesforce.gantt.commands.SimpleCommand;
	import com.salesforce.gantt.controller.Components;
	import com.salesforce.gantt.model.Task;
	import com.salesforce.gantt.model.TaskResource;
	import com.salesforce.gantt.util.ErrorHandler;
	import com.salesforce.results.SaveResult;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.IResponder;

	/**
	 * Command responsible for updating resources of a task.
	 * 
	 * @author Rodrigo Birriel
	 */
	public class UpdateTaskResourceCommand extends SimpleCommand
	{
		
		/** The Task with the Resource to update **/
		private var task : Task;
		/** The Resource to update **/				
		private var oldTaskResources : Array;
		/** The updated Resource **/		
		private var newTaskResources : Array;
		

		/**
		 * Constructor
		 * 
		 * task is the Task with the Resource to update
		 * oldTaskResource is the Resource to update
		 * newTaskResource is the updated Resource
		 */

		public function UpdateTaskResourceCommand(task : Task, oldTaskResource : Array, newTaskResources : Array) : void
		{
			this.task = task;
			this.newTaskResources = newTaskResources;
			this.oldTaskResources = oldTaskResources;
		}
        
        /**
        * Executes the command of updating a Resource to the Task
        */
        
        override public function execute() : void
        {
			Components.instance.salesforceService.taskResourceOperation.update(task,newTaskResources,this);
		}
		
		/**
        * Undoes the command of updating a Resource to the Task
        */
        
		override public function undo (responder : IResponder) : void
		{
			var colTaskResources : ArrayCollection = new ArrayCollection(oldTaskResources);
			task.setTaskResources(colTaskResources);
			Components.instance.salesforceService.taskResourceOperation.update(task,oldTaskResources,this);
		}
		
		override protected function actionCallBack(response : Object) : void {
			trace('Success updating the resource');
			var record : SaveResult;
			for each(var taskResource : TaskResource in newTaskResources){
				for(var i:int=0;i<response.length;i++){
					record = response[i];
					if(record.success){
						task.setTaskResource(taskResource.id,taskResource);	
					}
				}								
			}
			Components.instance.tasks.allTasks.setItemAt(task,task.position-1);						
		}
	}
}