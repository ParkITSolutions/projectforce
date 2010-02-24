package com.salesforce.gantt.view.components.grid.columns
{
	import mx.controls.ComboBox;
	import mx.core.ClassFactory;
	
	/**
	 * Class responsible to render the item renderer 
	 * and editor as ComboBox component.
	 * 
	 * @author Rodrigo Birriel
	 */
	public class ComboBoxGridColumn extends BaseDataGridColumn
	{
		public function ComboBoxGridColumn(columnName:String=null)
		{
			super(columnName);
			itemRenderer = new ClassFactory(ComboBox);
		}
		
	}
}