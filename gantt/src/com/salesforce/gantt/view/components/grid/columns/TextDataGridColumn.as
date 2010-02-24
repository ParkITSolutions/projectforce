package com.salesforce.gantt.view.components.grid.columns
{
	import com.salesforce.gantt.view.components.grid.columns.renderer.CellData;
	
	import mx.core.ClassFactory;
	
	/**
	 * Class responsible to render the item renderer 
	 * and editor by default.
	 * 
	 * @author Rodrigo Birriel
	 */
	public class TextDataGridColumn extends BaseDataGridColumn
	{
  
		public function TextDataGridColumn(columnName:String = null)
		{
			super(columnName);
			//itemRenderer = new ClassFactory(CellData);
		}
		
	}
}