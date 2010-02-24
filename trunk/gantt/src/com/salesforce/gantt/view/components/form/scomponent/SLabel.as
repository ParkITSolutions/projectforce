package com.salesforce.gantt.view.components.form.scomponent
{
	import com.salesforce.results.Field;
	
	import mx.controls.Label;
	
	/**
	 * Extended class from Label, 
	 * nothing more to say.
	 * 
	 * @author : Rodrigo Birriel
	 */ 
	public class SLabel extends Label implements SComponent
	{
		public function SLabel(){
			super();
			styleName = "sLabel";
		}

		public function get value():Object
		{
			return text;
		}
		
		public function set value(value : Object):void{
				text = value.toString();	
		}
		
		public function set customField(value : Object) : void{
		}
		
		public function get customField() : Object{
			return null;
		}
		
	}
}