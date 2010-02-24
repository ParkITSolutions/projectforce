package com.salesforce.gantt.view.event
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;

	public class ResourceEvent extends Event{
		
		public static const MERGE : String = 'merge';
		
		public var resources : ArrayCollection;
		
		public function ResourceEvent(type:String, resources : ArrayCollection, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.resources = resources;
		}
		
	}
}