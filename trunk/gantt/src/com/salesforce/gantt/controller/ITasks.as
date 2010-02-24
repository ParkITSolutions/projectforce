package com.salesforce.gantt.controller
{
	import com.salesforce.gantt.model.Task;
	import com.salesforce.gantt.model.UiTask;
	
	import mx.collections.ArrayCollection;
	
	[Bindable]
	public interface ITasks
	{
		function set allTasks(tasks : ArrayCollection) : void;
		function get allTasks() : ArrayCollection;
		function set selectedTask(tasks : UiTask) : void;
		function get selectedTask() : UiTask;
		function get clipBoardTasks() : ArrayCollection;
		function set clipBoardTasks(task : ArrayCollection) : void;
		function get countDeleted() : int;
		function set countDeleted(count : int) : void;

		
		function setParent(findStart : int = 0) : ArrayCollection;
		function checkParent(findStart : int = 0) : void;
		function getTaskIndex(index : int) : UiTask;
		function getTask(id : String) : UiTask;
		function getTasks(ids : ArrayCollection) : ArrayCollection;
		function select (id : String) : void;

		function cut() : void;
		function copy() : void;
		function paste() : void;
		
		function possibleParentTasks(taskChild : Task,addDummyTask : Boolean = false) : ArrayCollection;
		function possibleTaskDependencies(taskChild : Task) : ArrayCollection;
		function filterVisibleTask(depth : int = 0) : ArrayCollection;
		function getTaskDependencyChild(parentTask : Task) : ArrayCollection;
		function setTaskUsers() : void;
		function firstTask() : Task;
		function refreshDates() : void;
		function addTaskAt(task : Task,  index : int = -1) : void;
		function moveTaskAtEnd(parentTask : Task, taskChild : Task) : void;
		function deSelect(): void;
		function updateParentTask(newParentTask : Task , task : Task) : void;
		function originalAncestor(task : Task) : Task;
		function previousTask(selectTask : Boolean = false) : UiTask;
		function nextTask(selectTask : Boolean = false) : UiTask;

		function getIds() : Array;
		function deleteTasks(ids : Array) : void;
		function length() : int;
		function move(task : Task,position : int) : void;
		function checkMove(taskDraged : Task,taskTarget : Task) : Boolean;
		function checkIndent(task : UiTask) : Boolean;
		function checkOutdent(task : UiTask) : Boolean;
	}
}