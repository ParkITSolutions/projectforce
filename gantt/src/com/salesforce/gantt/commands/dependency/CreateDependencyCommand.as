package com.salesforce.gantt.commands.dependency
{
	import com.salesforce.gantt.commands.SimpleCommand;
	import com.salesforce.gantt.controller.Components;
	import com.salesforce.gantt.model.Dependency;
	import com.salesforce.gantt.model.UiTask;
	import com.salesforce.gantt.util.ErrorHandler;
	import com.salesforce.results.SaveResult;
	
	import flash.events.Event;
	
	import mx.rpc.IResponder;
	
	public class CreateDependencyCommand extends SimpleCommand
	{
		/** The Task the dependency will be added to **/
		private var child : UiTask;
		/** The Dependency that will get added to the Task **/
		private var dependencies : Array;
		
		private var move : Boolean = false;
		
		/**
		 * Constructor
		 * 
		 * child is the Task that will have the dependency added to
		 * dependency is the Dependency that will get added to the Task 	 
		 */
		 
		public function CreateDependencyCommand(child : UiTask, dependencies : Array ,hasUndoCommand : Boolean = true) : void
		{
			this.child = child;
			this.dependencies = dependencies;
			if(hasUndoCommand){
				this.undoCommand = new DeleteDependencyCommand(child.clone(),dependencies,false);	
			}
		}
        
        /**
        * Executes the command of adding a dependency to the task
        */
        
        override public function execute() : void
        {
        	var dependency : Dependency;
        	for(var i : int = 0; i < dependencies.length ; i++){
        		dependency = Dependency(dependencies.shift());
        		// push the object again for not losing the dependencies
        		dependencies.push(dependency);
        	}
        	Components.instance.salesforceService.dependencyOperation.create(dependencies, child,this);
		}
		
		override protected function actionCallBack(response : Object) : void 
  	  	{
			var record : SaveResult;
  	  		for each(var dependency : Dependency in dependencies){
  	  			for(var i:int = 0; i<response.length;i++){
  	  				record = response[i];
  	  				if(record.success){
  	  					dependency.id = record.id;
  	  					trace(dependency.id);
  	  					child.addDependency(dependency);
  	  					Components.instance.tasks.allTasks.setItemAt(dependency.task,dependency.task.position -1);		
  	  				}
  	  			}
    		}
    		Components.instance.tasks.allTasks.setItemAt(child,child.position-1);	
		}
	}
}