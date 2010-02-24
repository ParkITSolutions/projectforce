package com.salesforce.gantt.view.components.form
{
	import com.salesforce.gantt.controller.Constants;
	import com.salesforce.gantt.model.IDynamicObject;
	import com.salesforce.gantt.view.components.form.scomponent.SCheckBox;
	import com.salesforce.gantt.view.components.form.scomponent.SComponent;
	import com.salesforce.results.DescribeLayoutComponent;
	import com.salesforce.results.DescribeLayoutItem;
	import com.salesforce.results.DescribeLayoutRow;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	import mx.containers.FormItem;
	import mx.containers.FormItemDirection;
	import mx.controls.Label;
	import mx.core.IDataRenderer;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	/**
	 * Class responsible to renderer a row from the main form,
	 * given the layout descriptor and the model object.
	 * 
	 * @author Rodrigo Birriel
	 */ 
	[Event(name="dataChange", type="mx.events.FlexEvent")]
	public class SFormItem extends FormItem implements IDataRenderer
	{
		private var modelObject : IDynamicObject;
		
		private var layoutDescriptor : DescribeLayoutRow;
	    
	    public static const SFORM_PREFIX : String = 'SFORM_ITEM_';
		
		public var errorLabel : Label;
		
		public function SFormItem(){
			super();
			styleName = "sFormItem";
			errorLabel = new Label();
			errorLabel.styleName = 'sFormItemError';
			errorLabel.text = Constants.FIELD_REQUIRED;
			errorLabel.visible = false;
			direction = FormItemDirection.HORIZONTAL;
		}
		
		[Bindable("dataChange")]
		override public function get data():Object
		{
			return layoutDescriptor;
		}
		
		// data object is an array with a layoutdescriptor and a modelObject
		override public function set data(value : Object):void
		{
			this.layoutDescriptor = DescribeLayoutRow(value[0]);
			this.modelObject = IDynamicObject(value[1]);
			var describeLayoutItem : DescribeLayoutItem = layoutDescriptor.layoutItems[0];
			
			label = describeLayoutItem.label;
			name = SFORM_PREFIX+describeLayoutItem.layoutComponents[0].value;
			required = describeLayoutItem.required;
			addLayoutComponents(describeLayoutItem);
			invalidateProperties();
			dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
		}
		
		public function validate() : Boolean{
			var childComponent : SComponent = SComponent(getChildAt(0));
			var invalid : Boolean = required && childComponent.value == '';
			errorLabel.visible = invalid;
			return !invalid; 
		}
		
		public function displayError(error : com.salesforce.results.Error) : Boolean{
			var isError : Boolean = component.id == error.fields;
			if(isError){
				errorLabel.text = error.message;
			}
			return isError;
		}
		
		
		public function get component() : SComponent{
			return SComponent(getChildAt(0));
		}
		
		public function set component(uicomponent : SComponent) : void{
			addChildAt(uicomponent as DisplayObject,0);
		}
		
		public function addEnableBinding( sFormItem : SFormItem) : void{
			var checkBox : SCheckBox = sFormItem.component as SCheckBox;
			if(checkBox){
				checkBox.addEventListener(Event.CHANGE,function(){component.enabled = !checkBox.selected});	
			}
		}
		
		protected function addLayoutComponents(describeLayoutItem : DescribeLayoutItem) : void{
			var describeLayoutComponent : DescribeLayoutComponent;
			var component : UIComponent;
			var value : Object;
			for(var i:int=0;i<describeLayoutItem.layoutComponents.length;i++){
				describeLayoutComponent = DescribeLayoutComponent(describeLayoutItem.layoutComponents.getItemAt(i));
				//value = parentDocument.selectedTask.properties[describeLayoutComponent.value];
				value = modelObject.property(describeLayoutComponent.value);
				component = UIComponent(SComponentFactory.buildComponent(modelObject.stype, describeLayoutComponent,value,describeLayoutItem.editable));
				addChild(component);	
			}
			if(required){
				addChild(errorLabel);
				component.addEventListener(KeyboardEvent.KEY_DOWN,
					function(){
						// hide the errorLabel label when user type into the component.
						errorLabel.visible = false;
					})	
			}	
		}
		
	}
}