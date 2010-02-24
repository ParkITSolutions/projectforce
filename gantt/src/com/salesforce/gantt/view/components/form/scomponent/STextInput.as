package com.salesforce.gantt.view.components.form.scomponent
{
	import com.salesforce.results.Field;
	
	import mx.controls.TextInput;
	
	/**
	 * Base class to custom TextInput
	 * 
	 * @author : Rodrigo Birriel
	 */ 
	public class STextInput extends TextInput implements SComponent{
		private var _customField : Field;
		
		public function STextInput(){
			super();
			styleName = "sTextInput";
		}

		public function set customField(value : Object) : void{
			_customField = Field(value);
			maxChars = _customField.length;
			enabled = !_customField.autoNumber;
		}
		
		public function get customField() : Object{
			return _customField;
		}
		
		public function get value():Object{
			return text;
		}
		
		public function set value(value : Object):void{
			if(value){
				text = value.toString();
			}
		}
		
	}
}