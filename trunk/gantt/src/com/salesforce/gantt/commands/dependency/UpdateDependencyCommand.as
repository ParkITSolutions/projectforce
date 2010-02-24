package com.salesforce.gantt.commands.dependency
{
	import com.salesforce.gantt.commands.SimpleCommand;
	import com.salesforce.gantt.controller.Components;
	import com.salesforce.gantt.model.Dependency;
	import com.salesforce.gantt.model.Task;
	import com.salesforce.gantt.util.ErrorHandler;
	
	import flash.events.Event;
	
	import mx.rpc.IResponder;
	
	/**
	 * Command responsible for updating a dependency
	 * 
	 * @author Rodrigo Birriel
	 */
	public class UpdateDependencyCommand extends SimpleCommand
	{
		
		/** The Task with the Dependency to update **/
		private var child : Task;
		/** The Dependency to update **/		
		private var oldDependencies : Array;
		/** The updated Dependency **/		
		private var newDependencies : Array;
		
		/**
		 * Constructor
		 * 
		 * child is the Task with the Dependency to update
		 * oldDependency is the Dependency to update
		 * newDependency is the updated Dependency
		 */
		 
		public function UpdateDependencyCommand(child : Task, newDependencies : Array, oldDependencies : Array) : void
		{
			this.child = child;
			this.oldDependencies = oldDependencies;
			this.newDependencies = newDependencies;
		}

		/**
        * Executes the command of updating a dependency to the task
        */
        
        override public function execute() : void
        {
        	Components.instance.salesforceService.dependencyOperation.update(child,newDependencies,this);	
		}
		
		/**
        * Undoes the command of updating a dependency to the task
        */
        
		override public function undo (responder : IResponder) : void
		{
			var oldDependency : Dependency;
			for(var i : int = 0; oldDependencies.length; i++){
				oldDependency = Dependency(oldDependencies.shift());
				child.updateDependency(oldDependency);
				// push the object agains for not losing the dependencies
        		oldDependencies.push(oldDependency);
			}
			
			Components.instance.tasks.allTasks.setItemAt(child, child.position - 1);
			Components.instance.salesforceService.dependencyOperation.update(child,oldDependencies,this);
		}
		
		override protected function actionCallBack(response : Object) : void{
			for each(var dependency : Dependency in newDependencies){
    			child.updateDependency(dependency);
			}
    		Components.instance.tasks.allTasks.setItemAt(child, child.position - 1);
		}
	}
}