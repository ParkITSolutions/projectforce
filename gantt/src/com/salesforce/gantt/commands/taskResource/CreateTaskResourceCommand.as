package com.salesforce.gantt.commands.taskResource
{
	import com.salesforce.gantt.commands.SimpleCommand;
	import com.salesforce.gantt.controller.Components;
	import com.salesforce.gantt.model.Task;
	import com.salesforce.gantt.util.ErrorHandler;
	
	import flash.events.Event;
	
	import mx.rpc.IResponder;

	/**
	 * @author Rodrigo Birriel
	 */
	public class CreateTaskResourceCommand extends SimpleCommand{
		/** The Task the Resource will be added to **/
		private var task : Task;
		/** The Resources that will get added to the Task **/
		private var resources : Array;
		
		/**
		 * Constructor
		 * 
		 * task is the Task that will have the Resources added to
		 * resources are the Resources that will get added to the Task 	 
		 */
		public function CreateTaskResourceCommand(task : Task, resources : Array) : void{
			this.task = task;
			this.resources = resources;
		}
        
        /**
        * Executes the command of adding the Resources to the task
        */
        override public function execute() : void{
	    	Components.instance.salesforceService.taskResourceOperation.create(task, resources,this);
		}
		
		/**
        * Undoes the command of adding Resources to the Task
        */
		override public function undo (responder : IResponder) : void{
			var deleteTaskResourceCommand : DeleteTaskResourceCommand = new DeleteTaskResourceCommand(task,resources);
			deleteTaskResourceCommand.addEventListener(SimpleCommand.COMPLETE,responder.result);
			deleteTaskResourceCommand.execute();
		}
		
		override protected function actionCallBack(response : Object) : void{
  			for(var i : int = 0; i<response.length; i++){
  				resources[i].id	= response[i].id;
  				task.taskResources.addItem(resources[i]);
  				trace('Success adding the resource');
				trace('Id : '+  response[i].id);
			}
	 	}
	}
}