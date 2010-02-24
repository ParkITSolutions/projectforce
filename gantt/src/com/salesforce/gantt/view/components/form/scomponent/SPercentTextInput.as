package com.salesforce.gantt.view.components.form.scomponent
{
	import com.salesforce.gantt.view.validator.PercentValidator;
	import com.salesforce.results.Field;
	
	import flash.events.Event;
	
	/**
	 * Specific class to parse from input a valid percentage value represented by double
	 * between 0 and 100.
	 * 
	 * @author : Rodrigo Birriel
	 */
	public class SPercentTextInput extends SCustomTextInput
	{
		
		public function SPercentTextInput()
		{
			super();
		}
		
		override protected function parseInput(event : Event = null) : void{
			text = new PercentValidator(text).parse();
		}
		
	}
}