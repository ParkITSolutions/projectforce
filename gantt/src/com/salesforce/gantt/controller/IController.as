package com.salesforce.gantt.controller
{
	import com.salesforce.gantt.model.Project;
	import com.salesforce.gantt.model.Task;
	import com.salesforce.gantt.model.UiTask;
	
	import flash.events.IEventDispatcher;
	
	import mx.collections.ArrayCollection;
	
	public interface IController extends IEventDispatcher
	{
		function get action() : String;

	  	/** Indents a task **/
		function indent(task : UiTask) : void;
		/** Outdents a task **/
		function outdent(task : UiTask) : void;
		
		/** Stores a task on the clipboard to cut **/
		function cut() : void;
		/** Stores a task in the clipboard to copy **/
		function copy() : void;
		/** Cuts or copies a task **/
		function paste() : void;

		/** Undoes any commmand invoked **/		
		function undo() : void;
		
		/** Redoes any commmand invoked **/		
		function redo() : void;
		
		/** Checks if possible to invoke undo **/		
		function checkUndo() : Boolean;
		
		/** Checks if possible to invoke redo **/		
		function checkRedo() : Boolean;
		
		/** Checks if possible to invoke copy**/
		function checkCopy(): Boolean;
		
		/** Checks if possible to invoe cut **/		
		function checkCut() : Boolean;
		
		/** Checks if possible to invoe paste **/		
		function checkPaste() : Boolean;
		
		/** Creates a new Task **/
		function addTask(task : Task, action : String) : void;
		/** Updates an existing Task **/
		function updateTask(task : UiTask, saveInHistory : Boolean = true) : void
		/** Deletes an existing Task **/
        function deleteTask(task : Task) : void;
		
		/** Creates a new Dependency **/
		function addDependency(dependencies : Array, task : UiTask) : void;
		/** Updates an existing Dependency **/
		function updateDependency(dependencies : Array, oldDependencies : Array) : void;
		/** Deletes an existing Dependency **/
		function deleteDependency(dependencies : Array , task : UiTask) : void;

		/** Merge the new resources collection with the original one**/
		function mergeResources(resources : ArrayCollection) : void;
		
		function resetPositions() : void;
		
		/** Move a task from its position **/
		function moveTask(taskToMove : UiTask,taskTarget : UiTask) : void;
		
		/**  Check if possife to invoke indent command. **/
		function checkIndent(task : UiTask) : Boolean;
		
		/**  Check if possife to invoke outdent command. **/
		function checkOutdent(task : UiTask) : Boolean;
		
		/** Updates an existing project**/
		function updateProject(project : Project) : void;
		
		function loadUsersOnDemand(pattern : String, collection : ArrayCollection, filteredIds : ArrayCollection) : void;
		
		/** Synchronize the information with the server.*/
		function synchronize(project : Project) : void;
	}
}