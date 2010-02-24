package com.salesforce.gantt.view.components.grid
{
	import com.salesforce.gantt.controller.SMetadataController;
	import com.salesforce.gantt.controller.SOTaskConstants;
	import com.salesforce.gantt.util.CustomArrayUtil;
	import com.salesforce.gantt.view.components.grid.columns.CheckBoxDataGridColumn;
	import com.salesforce.gantt.view.components.grid.columns.DateFieldGridColumn;
	import com.salesforce.gantt.view.components.grid.columns.TextDataGridColumn;
	import com.salesforce.results.Field;
	
	import mx.collections.ArrayCollection;
	import mx.collections.HierarchicalData;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
	
	/**
	 * Class responsible for creating the custom datagrid columns,
	 * creating specific columns's instance depending on the SObject's fields.
	 * 
	 * @author Rodrigo Birriel
	 */
	public class DataGridColumnFactory
	{
		
		/**
		 * Given a SObject type name, build a collection of Custom DataGridColumn
		 * with the fields of the specific descriptor.
		 */ 
		public static function buildDataGridColumns(sOType : String) : Array{
			var columns : ArrayCollection = new ArrayCollection();
			var dataGridColumn : AdvancedDataGridColumn;
			var fields : ArrayCollection = SMetadataController.instance.getFieldsCreatebleAndUpdatable(sOType);
			for each( var field : Field in fields){
				//TODO the datagrid column for the rest of fieldType
				switch(field.type){
					case SMetadataController.BOOLEAN:
							dataGridColumn = new CheckBoxDataGridColumn();
						break;
					case SMetadataController.CURRENCY:
					case SMetadataController.DATE:
							dataGridColumn = new TextDataGridColumn();
						break;
					case SMetadataController.DATETIME:
							dataGridColumn = new DateFieldGridColumn();
						break;
					case SMetadataController.DOUBLE:
					case SMetadataController.PERCENT:
					case SMetadataController.EMAIL:
					case SMetadataController.PHONE:
							dataGridColumn = new TextDataGridColumn();
						break;
					case SMetadataController.PICKLIST:
							dataGridColumn = null;
						break;
						//this
					case SMetadataController.REFERENCE:
							dataGridColumn = null;
						break;
					case SMetadataController.STRING:
					case SMetadataController.TEXTAREA:
					case SMetadataController.URL:
							dataGridColumn = new TextDataGridColumn(); 
						break;
					default :
							dataGridColumn = new TextDataGridColumn();
				}
				if(dataGridColumn){
					dataGridColumn.headerText = field.label;
					dataGridColumn.dataField = field.name;
					dataGridColumn.width = 100;
					columns.addItem(dataGridColumn);
					trace("field.name :"+field.name);
				}
			}
			return columns.toArray();
		}
		
		/**
		 * Given a collection 
		 */
		public static function buildDataProvider(collection : ArrayCollection){
			return CustomArrayUtil.getAttributesArrayCollection(collection,SOTaskConstants.PROPERTIES);
		}
		
		public static function buildHierarchicalData(collection : ArrayCollection, childrenField : String) : HierarchicalData{
			var hierarchicalData : HierarchicalData = new HierarchicalData(collection.toArray());
			hierarchicalData.childrenField = childrenField;
			return hierarchicalData;
		}
	}
}