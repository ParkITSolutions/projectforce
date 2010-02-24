package com.salesforce.gantt.view.components.form.scomponent
{
	
	import mx.controls.CheckBox;

	/**
	 * Extended class from CheckBox, 
	 * nothing more to say.
	 * 
	 * @author : Rodrigo Birriel
	 */
	public class SCheckBox extends CheckBox implements SComponent
	{
		public function SCheckBox()
		{
			super();
		}
		
		public function get value():Object
		{
			return selected;
		}
		
		public function set value(value : Object) : void{
			selected = value;
		}
		
		public function set customField(value : Object) : void{
		}
		
		public function get customField() : Object{
			return null;
		}
		
	}
}