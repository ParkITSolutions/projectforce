package com.salesforce.gantt.view.components.form.scomponent
{
	import com.salesforce.results.Field;
	
	import flash.events.Event;

	/**
	 * Custom class extended of STextInput to add a listener on event change.
	 * 
	 * @author : Rodrigo Birriel
	 */ 
	public class SCustomTextInput extends STextInput{
		
		public function SCustomTextInput(){
			super();
			addEventListener(Event.CHANGE,parseInput);
		}
		
		protected function parseInput(event : Event = null) : void{
		}
		
	}
}