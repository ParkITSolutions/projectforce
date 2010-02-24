package com.salesforce.gantt.commands.task
{
	import com.salesforce.gantt.commands.BaseCommand;
	import com.salesforce.gantt.commands.CompositeCommand;
	import com.salesforce.gantt.controller.Components;
	import com.salesforce.gantt.controller.Constants;
	import com.salesforce.gantt.model.Heriarchy;
	import com.salesforce.gantt.model.Task;
	import com.salesforce.gantt.model.UiTask;
	import com.salesforce.gantt.util.CustomArrayUtil;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;

	/**
	 * Container class containing createTaskCommands as children.
	 * 
	 * @author Rodrigo Birriel
	 */
	public class PasteTaskCommand extends CompositeCommand
	{
		var indexPosition : int;
		
		/**
		 * Constructor
		 * @param tasks are a hierarchy of tasks which first ancestor is situated in the first 
		 * 				position.
		 */
		public function PasteTaskCommand(tasks : ArrayCollection,action : String)
		{
			var task : UiTask;
			var parentHierarchy : UiTask = UiTask(tasks.getItemAt(0));
			var selectedTask : UiTask = Components.instance.tasks.selectedTask;
			var indentNew : int;
			var command : BaseCommand;
			indexPosition = 0;
			this.newObject = tasks;
			this.oldObject = CustomArrayUtil.copyArrayCollection(tasks);
			
			//it is only necessary delete the firts ancestor, the rest of the descendent
			//are deleted in cascade.
			parentHierarchy.parent = selectedTask.parent; 
		
			for(var i:int =0;i<tasks.length;i++){
				task = UiTask(tasks.getItemAt(i));
				//update the task position adding the selected task one.
				indentNew = selectedTask.heriarchy.indent + task.heriarchy.indent;
				task.position = selectedTask.position +i;
				task.heriarchy = new Heriarchy(indentNew,task.heriarchy.parent);
				if(action == Constants.ACTION_ADD_COPY)
				{
					this.undoCommand = new DeleteTaskCommand(parentHierarchy,false);
					command = new CreateTaskCommand(task);
					command.success = updateChildren;	
				}else if(action == Constants.ACTION_ADD_CUT){
					command = new UpdateTaskCommand(task);
				}	
				addCommand(command);
			}
			
		}
		
		private function updateChildren(event : Event) : void{
			var tasks : ArrayCollection = newObject as ArrayCollection;
			var taskTemp : Task;
			var taskAdded : Task = Task(tasks.getItemAt(indexPosition));
			var noMoreChildren : Boolean = false;
			var diffIndent : int;
			indexPosition++;
			for(var j:int=indexPosition; !noMoreChildren && j<tasks.length;j++){
				taskTemp = Task(tasks.getItemAt(j));
				diffIndent = taskTemp.heriarchy.indent - taskAdded.heriarchy.indent;
				if(diffIndent == 0){
					noMoreChildren = true;	
				}
				// here we have a lost child.
				else if(diffIndent == 1){
					taskTemp.parent = taskAdded.id;
				}
			}
		}
		
	}
}