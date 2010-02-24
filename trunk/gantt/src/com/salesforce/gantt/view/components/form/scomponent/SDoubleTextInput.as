package com.salesforce.gantt.view.components.form.scomponent
{
	import com.salesforce.gantt.view.validator.NumberValidator;
	import com.salesforce.results.Field;
	
	import flash.events.Event;
	
	/**
	 * Specific class to parse from input a valid double, parsing it.
	 * 
	 * @author : Rodrigo Birriel
	 */ 
	public class SDoubleTextInput extends SCustomTextInput
	{
		public function SDoubleTextInput()
		{
			super();
		}
		
		override protected function parseInput(event : Event = null) : void{
			text = new NumberValidator(text,customField.precision,customField.digits).parse();
		}
		
	}
}