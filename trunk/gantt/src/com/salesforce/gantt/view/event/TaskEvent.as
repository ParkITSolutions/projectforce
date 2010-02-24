package com.salesforce.gantt.view.event
{
	import com.salesforce.gantt.model.Dependency;
	import com.salesforce.gantt.model.UiTask;
	
	import flash.events.Event;

	/**
	 * Custom event to be dispatched every time a task is successfuly created at TaskOperation
	 * the Event will carry the created task's id.
	 * <i>This class could be extended to be used every time an event should be dispatched relatively to
	 * a specific task's context.</i>
	 * 
	 * @author Laureano Costa
	 * @version 1.0, 03/17/2009
	 * 
	 */
	public class TaskEvent extends Event
	{
		public static const SELECT : String = "select";
		public static const UPDATE : String = "update";
		public static const CREATE : String = "create";
		public static const DELETE : String = "delete";
		public static const NEXT_TASK : String = "nextTask";
		public static const PREVIOUS_TASK : String = "previousTask";
		public static const COPY : String = "copy";
		public static const COPY_AND_PASTE : String = "copyAndPaste";
		public static const CUT : String = "cut";
		public static const CUT_AND_PASTE : String = "cutAndPaste";
		public static const PASTE : String = "paste";
		public static const ADD_DEPENDENCY : String = "addDependency";
		public static const DEL_DEPENDENCY : String = "delDependency";
		
		public var task : UiTask;
		public var dependency : Dependency;
		
		/**
		 * Contructs a TaskCreatedEvent.
		 * 
		 * @param type the type event name.
		 * @param task attached to it.
		 * @param bubbles
		 * @param cancelable
		 * 
		 */
		public function TaskEvent(type:String, task: UiTask = null,dependency : Dependency=null,bubbles : Boolean = true, cancelable : Boolean = false)
		{
			super(type,bubbles,cancelable);
			this.task = task;
			this.dependency = dependency;
		}
		
	}
}