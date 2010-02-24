package com.salesforce.gantt.view.components.form.scomponent
{
	import com.salesforce.results.Field;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.HBox;
	import mx.controls.DateField;
	import mx.controls.Label;
	import mx.events.CalendarLayoutChangeEvent;
	import mx.formatters.DateFormatter;
	
	/**
	 * Class to represent the DateField component used in Salesforce.
	 * It contains two component a DateField to user choose a date in a calendar and
	 * a link to today's date.
	 * 
	 * @author : Rodrigo Birriel
	 */ 
	public class SDateField extends HBox implements SComponent
	{	
		private var dateField : DateField;
		private var todayLabel : Label;
		
		public function SDateField()
		{
			super();
			var dateFormatter : DateFormatter = new DateFormatter();
			dateFormatter.formatString = "[MM/DD/YYYY]";
			dateField = new DateField();
			todayLabel = new Label();
			todayLabel.text = dateFormatter.format(new Date());
			dateField.styleName = "sDateField";
			todayLabel.styleName = "sDateField";
			todayLabel.addEventListener(MouseEvent.CLICK,refresh);
			dateField.addEventListener(CalendarLayoutChangeEvent.CHANGE,refresh);
			addChild(dateField); 
			addChild(todayLabel);  
		}
		
		/**
		 * This method return a Date depeding on the component id.
		 */	
		public function get value():Object
		{
			return dateField.selectedDate;
		}
		
		/**
		 * This method set a value to this component.
		 */
		public function set value(value : Object):void{
			if(value){
				dateField.selectedDate = value as Date;
			}else{
				dateField.selectedDate = new Date();	
			}
		}
		
		public function set customField(value : Object) : void{
		}
		
		public function get customField() : Object{
			return null;
		}
		
		private function refresh(event : Event) : void{
			var newDate : Date;
			if(event.type == MouseEvent.CLICK){
				newDate = new Date();
			}else if(event as CalendarLayoutChangeEvent && event.type == CalendarLayoutChangeEvent.CHANGE){
				newDate = CalendarLayoutChangeEvent(event).newDate;
			}
			dateField.selectedDate = newDate;
			dispatchEvent(new Event(Event.CHANGE,true));
			
		}
		
	}
}