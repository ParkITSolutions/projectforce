package com.salesforce.gantt.view.components.form
{
	import com.salesforce.gantt.controller.SMetadataController;
	import com.salesforce.gantt.view.components.form.scomponent.SCheckBox;
	import com.salesforce.gantt.view.components.form.scomponent.SComboBox;
	import com.salesforce.gantt.view.components.form.scomponent.SComponent;
	import com.salesforce.gantt.view.components.form.scomponent.SDateField;
	import com.salesforce.gantt.view.components.form.scomponent.SDoubleTextInput;
	import com.salesforce.gantt.view.components.form.scomponent.SLabel;
	import com.salesforce.gantt.view.components.form.scomponent.SPercentTextInput;
	import com.salesforce.gantt.view.components.form.scomponent.SReference;
	import com.salesforce.gantt.view.components.form.scomponent.STextArea;
	import com.salesforce.gantt.view.components.form.scomponent.STextInput;
	import com.salesforce.results.DescribeLayoutComponent;
	import com.salesforce.results.Field;
	
	/**
	 * Class responsible for returning a specific custom component depending on metadata type
	 * 
	 * @author : Rodrigo Birriel
	 */
	public class SComponentFactory
	{
		
		/**
		 * Build a custom component depending on its type
		 * 
		 * @param sobjectName				the SObject type name
		 * @param describeLayoutComponent	the layout component descriptor
		 * @param value 					the value to set to the component
		 * @return 							the custom component
		 */ 
		public static function buildComponent(sobjectName : String, describeLayoutComponent : DescribeLayoutComponent, value : Object, editable: Boolean) : SComponent{
			var component : SComponent = null;
			var customField : Field = SMetadataController.instance.getFieldValue(sobjectName,describeLayoutComponent.value);
			if(describeLayoutComponent.type == SMetadataController.FIELD){	
				if(!editable){
					component = new SLabel();
				}else{
					switch(customField.type){
						case SMetadataController.BOOLEAN:
								component = new SCheckBox();
							break;
						case SMetadataController.CURRENCY:
								component = new STextInput();
								component.customField = customField;
							break;
						case SMetadataController.DATE:	
								component = new SDateField();
							break;
						// TODO create a custom component for this type//
						case SMetadataController.DATETIME:
								component = new SDateField();
							break;
						case SMetadataController.DOUBLE:
								component = new SDoubleTextInput();
								component.customField = customField;
							break;
						case SMetadataController.EMAIL:
								component = new STextInput();
								component.customField = customField;
							break;
						case SMetadataController.PERCENT:
								component = new SPercentTextInput();
								component.customField = customField;
							break;
						case SMetadataController.PHONE:
								component = new STextInput();
								component.customField = customField;
							break;
						case SMetadataController.PICKLIST:
								var sComboBox : SComboBox = new SComboBox()
								component = sComboBox;
								sComboBox.dataProvider = SMetadataController.instance.getPickList(customField.name);
							break;
						case SMetadataController.REFERENCE:
								component = new SReference();
							break;
						case SMetadataController.STRING:
								component = new STextInput();
								component.customField = customField;
							break;
						case SMetadataController.TEXTAREA:
								component = new STextArea();
								component.customField = customField;
							break;		
						case SMetadataController.URL:
								component = new STextInput();
								component.customField = customField;
							break;
						default :
								component = new SLabel();
					}	
				}
				
			}
			component.id = customField.name;
			component.value = value;
			return component;
		}
	}
}