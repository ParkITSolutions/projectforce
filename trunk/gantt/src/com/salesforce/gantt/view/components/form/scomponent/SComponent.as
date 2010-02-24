package com.salesforce.gantt.view.components.form.scomponent
{
	import mx.core.IUIComponent;
	
	/**
	 * Interface implemented for custom components.
	 * 
	 * @author : Rodrigo Birriel
	 */ 
	public interface SComponent extends IUIComponent
	{
		function get id() : String;
		function set id(value : String) : void;
		function get value() : Object;
		function set value(value : Object) : void;
		function set customField(value : Object) : void;
		function get customField() : Object;
		function toString() : String;
	}
}