package com.salesforce.gantt.view.components.grid.columns
{
	import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
	import mx.controls.dataGridClasses.DataGridColumn;

	/**
	 * Base class to give common funcionalities to sub classes.
	 * 
	 * @author Rodrigo Birriel
	 */ 
	public class BaseDataGridColumn extends AdvancedDataGridColumn
	{
		public function BaseDataGridColumn(columnName:String = null)
		{
			super(columnName);
		}
	}
}