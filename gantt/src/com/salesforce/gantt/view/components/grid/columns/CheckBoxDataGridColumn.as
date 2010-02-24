package com.salesforce.gantt.view.components.grid.columns
{
	import mx.controls.CheckBox;
	import mx.core.ClassFactory;
	
	/**
	 * Class responsible to render the item renderer 
	 * and editor as CheckBox component.
	 * 
	 * @author Rodrigo Birriel
	 */
	public class CheckBoxDataGridColumn extends BaseDataGridColumn
	{
		public function CheckBoxDataGridColumn(columnName:String = null)
		{
			super(columnName);
			itemRenderer = new ClassFactory(CheckBox);
		}
		
	}
}