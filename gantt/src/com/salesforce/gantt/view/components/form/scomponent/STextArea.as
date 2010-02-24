package com.salesforce.gantt.view.components.form.scomponent
{
	import com.salesforce.results.Field;
	
	import mx.controls.TextArea;

	/**
	 * Extended class from TextArea, 
	 * nothing more to say.
	 * 
	 * @author : Rodrigo Birriel
	 */
	public class STextArea extends TextArea implements SComponent{
		
		private var _customField : Field;
		
		public function STextArea(){
			super();
			styleName = "sTextArea";
		}
		
		public function set customField(value : Object) : void{
			_customField = Field(value);
			maxChars = _customField.length;
		}
		
		public function get customField() : Object{
			return _customField;
		}
		
		public function get value():Object{
			return text;
		}

		public function set value(value : Object):void{
			if(value){
				text = String(value);	
			}
		}
	}
}