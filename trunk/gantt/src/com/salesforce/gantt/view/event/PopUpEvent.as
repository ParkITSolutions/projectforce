package com.salesforce.gantt.view.event
{
	import flash.events.Event;
	
	/**
	 * Custom event to handle the popup.
	 * 
	 * @author Rodrigo Birriel
	 */
	public class PopUpEvent extends Event
	{
		public static const DELETE_DIALOG_OPEN : String = "deleteDialogOpen";
		public static const TASK_DETAIL_OPEN :  String = "taskDetailOpen";
		
		public function PopUpEvent(type:String,bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}