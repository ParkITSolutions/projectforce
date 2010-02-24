package com.salesforce.gantt.view.components.form.scomponent
{
	import com.salesforce.gantt.controller.SMetadataController;
	import com.salesforce.results.Field;
	
	import mx.controls.ComboBox;

	/**
	 * Custom Class for ComboBox used to show the option from picklist used in Salesforce.
	 * 
	 * @author : Rodrigo Birriel
	 */ 
	public class SComboBox extends ComboBox implements SComponent
	{
		public function SComboBox()
		{
			super();
			styleName = "sComboBox";
		}
		
		override public function get value():Object
		{
			return selectedLabel;
		}
		
		public function set value(value : Object):void{
			selectedIndex = _selectedIndex(value);
		}
		
		public function set customField(value : Object) : void{
		}
		
		public function get customField() : Object{
			return null;
		}
		
		private function _selectedIndex(value : Object) : int{
			var index : int = 0;
			var currentItem : Object;
			for(var i:int=0; i<dataProvider.length;i++){
				currentItem = dataProvider[i];
				if(currentItem.label == value){
					index = i;
					break;
				}
			}
			return index
		}
		
	}
}