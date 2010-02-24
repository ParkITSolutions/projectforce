package com.salesforce.gantt.view.components.grid.columns
{
	import mx.controls.NumericStepper;
	import mx.controls.Text;
	import mx.core.ClassFactory;
	
	/**
	 * Custom class to render a numeric stepper assisted.
	 * 
	 * @author Rodrigo Birriel
	 */
	public class NumericStepperDataGridColumn extends BaseDataGridColumn{
		
		public function NumericStepperDataGridColumn(columnName : String = null)
		{
			super(columnName);
			itemEditor = new ClassFactory(NumericStepper);
			itemRenderer = new ClassFactory(Text);
		}
		
	}
}