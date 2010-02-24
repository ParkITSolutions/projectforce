package com.salesforce.gantt.view.event
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;

	/**
	 * Custom event to handle the resource.
	 * 
	 * @author Rodrigo Birriel
	 */
	public class UserEvent extends Event
	{
		public static const LOAD_ON_DEMAND : String = "load_on_demand";
		
		public var pattern : String;
		public var filtered : ArrayCollection;
		
		public function UserEvent(type:String, pattern : String, filteredElements : ArrayCollection = null, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.pattern = pattern;
			this.filtered = filteredElements;
		}
		
	}
}