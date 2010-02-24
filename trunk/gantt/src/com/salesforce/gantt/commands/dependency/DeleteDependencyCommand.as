package com.salesforce.gantt.commands.dependency
{
	import com.salesforce.gantt.commands.SimpleCommand;
	import com.salesforce.gantt.controller.Components;
	import com.salesforce.gantt.model.Dependency;
	import com.salesforce.gantt.model.UiTask;
	import com.salesforce.gantt.util.ErrorHandler;
	
	import flash.events.Event;
	
	public class DeleteDependencyCommand extends SimpleCommand
	{
		
		/** The Task the dependency will be deleted from **/
		private var child : UiTask;
		/** The Dependency that will get deleted from the Task **/
		private var dependencies : Array;

		/**
		 * Constructor
		 * 
		 * child is the Task that will have the dependency deleted from
		 * dependency is the Dependency that will get deleted to the Task 	 
		 */

		public function DeleteDependencyCommand(child : UiTask, dependencies : Array, hasUndoCommand : Boolean = true) : void
		{
			this.child = child;
			this.dependencies = dependencies;
			if(hasUndoCommand){
				this.undoCommand = new CreateDependencyCommand(child.clone(),dependencies,false);	
			}
		}

        /**
        * Executes the command of deleting a dependency from the task
        */
        
        override public function execute() : void
        {
        	var dependency : Dependency;
        	var ids : Array = new Array();
        	for each(var dependency : Dependency in dependencies){
        		ids.push(dependency.id);
        	}
			Components.instance.salesforceService.dependencyOperation.deleteDependencies(ids,child,this);
		}
		
		override protected function actionCallBack(response : Object) : void
	  	{
	  		var dependency : Dependency;
	  		if(response.length){
	  			for(var i:int =0;i<response.length;i++){
	  				dependency = new Dependency();
	  				dependency.id = response[i].id;
	  				child.removeDependency(dependency);
	  			}
	  			Components.instance.tasks.allTasks.setItemAt(child,child.position-1);
	  			/* if(loadTask){
	  				Components.instance.salesforceService.taskOperation.loadUserTask(task);		
	  			} */
	  		};
		}
	}
}