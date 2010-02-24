package com.salesforce.gantt.view.components.form.event
{
	import flash.events.Event;

	/**
	 * Custom event for dispatch a event when there are errors
	 * in the task detail form.
	 * 
	 * @author Rodrigo Birriel
	 */  
	public class SResultEvent extends Event
	{
		public static var ERRORS : String = 'error';
		public var result : Object;
		public function SResultEvent(result:Object,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(ERRORS, bubbles, cancelable);
			this.result = result;
		}
	}
}