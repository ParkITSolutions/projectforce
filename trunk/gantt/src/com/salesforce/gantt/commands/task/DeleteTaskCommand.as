package com.salesforce.gantt.commands.task
{
	import com.salesforce.gantt.commands.CompositeCommand;
	import com.salesforce.gantt.commands.dependency.CreateDependencyCommand;
	import com.salesforce.gantt.controller.Components;
	import com.salesforce.gantt.model.Dependency;
	import com.salesforce.gantt.model.UiTask;
	import com.salesforce.gantt.util.CustomArrayUtil;
	
	import mx.collections.ArrayCollection;
	 
	 /**
	 * @author Rodrigo Birriel
	 */ 
	public class DeleteTaskCommand extends CompositeCommand
	{
		/** The Task to delete from the list and the database **/
		private var task : UiTask;
		private var parentTask : UiTask;


		/**
		 * Constructor
		 * task is the Task to delete from the list and the database 
		 */		
		 
		public function DeleteTaskCommand(task : UiTask, hasUndoCommand : Boolean = true) : void
		{
			this.task = task;
			parentTask = Components.instance.tasks.getTask(task.parent);
			if(hasUndoCommand){
				this.undoCommand = new CreateTaskCommand(task,false);
			}
		}
        
        /**
        * Executes the command of deleting this Task from the list to the database
        * 
        */
        
        override public function execute() : void
        {
	 		Components.instance.salesforceService.taskOperation.deleteTasks(task,this);
		}
		
		override protected function actionCallBack(response : Object) : void{
  			
  			//deletes dependencies
  			var directChildren : ArrayCollection = Components.instance.dependencies.getDirectDependencies(task);
  			for(var i : int = 0; i < directChildren.length; i++)
  			{
  				var childTask : UiTask = UiTask(directChildren.getItemAt(i));
  				var dependency : Dependency = Components.instance.dependencies.getDependency(task, childTask);
  				CompositeCommand(undoCommand).addCommand(new CreateDependencyCommand(childTask,[dependency],false));	
  				childTask.removeDependency(dependency);
  				Components.instance.tasks.allTasks.setItemAt(childTask,childTask.position-1);
  			}
  			var children : ArrayCollection = task.heriarchy.getDescendants(task);
  			for each(var child : UiTask in children){
  				CompositeCommand(undoCommand).addCommand(new CreateTaskCommand(child,false));	
  			}
  			children.addItem(task);
  			var ids : Array = CustomArrayUtil.getAttributesArrayCollection(children,'id').toArray();
  			Components.instance.tasks.deleteTasks(ids);
  			
  			if(parentTask){
  				parentTask.removeChildTask(task);
  			}
  			
  			Components.instance.tasks.setParent();
  			super.execute();
  			
	  	}
	}
}