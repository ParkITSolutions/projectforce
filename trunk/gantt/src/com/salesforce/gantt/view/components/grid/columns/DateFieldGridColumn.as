package com.salesforce.gantt.view.components.grid.columns
{
	import mx.controls.DateField;
	import mx.core.ClassFactory;
	
	/**
	 * Class responsible to render a calendar as item editor.
	 * 
	 * @author Rodrigo Birriel
	 */
	public class DateFieldGridColumn extends BaseDataGridColumn
	{
		public function DateFieldGridColumn(columnName:String = null)
		{
			super(columnName);
			rendererIsEditor = false;
			itemEditor = new ClassFactory(DateField);
		}
		
	}
}