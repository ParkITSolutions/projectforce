package com.salesforce.gantt.renderers
{
	import com.salesforce.gantt.model.Calendar;
	import com.salesforce.gantt.model.UI;
	
	import mx.controls.listClasses.IListItemRenderer;
	import mx.core.IDataRenderer;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	[Event(name="dataChange", type="mx.events.FlexEvent")]
	
	public class DatesLineRenderer extends UIComponent implements IDataRenderer, IListItemRenderer
	{
		private var _data : Object = null;
		   	
	    [Bindable("dataChange")]
		public function get data():Object
		{
			return _data;	
		}
		public function set data(value : Object):void
		{
			this._data = value;
			this.invalidateProperties();			
			dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
		}
		override protected function updateDisplayList(width : Number, height : Number) : void
		{
			super.updateDisplayList(width, height);
			graphics.clear();
			
			if ( _data != null )
			{
				var zoom : int = this.parentApplication.mainView.barChart.zoom;
				
				var today : Date = new Date();
				var date : Date = new Date(_data);
				
				var x : int = Calendar.toDay(date) * UI.scale;
				
				// TODO WATCH WHAT HAPPEN
				//var bottom : int = this.parentApplication.mainView.taskList.visibleTask.length * UI.ROW_HEIGHT + 1000;//3000;// - (Calendar.toDay(date) * UI.ROW_HEIGHT);
				var bottom : int = 3000;
				//
				var top : int = 0;//-3000;
				
				//si la fecha es fin de semana
				if(Calendar.isWeekend(date) && zoom != Constants.YEAR)
				{
					if(Calendar.isFirstDayOfTheMonth(date))
					{
						graphics.lineStyle(1, 0x333333, 1);
					}
					else
					{
						graphics.lineStyle(1, 0xC0C0Bf, 1);
					}
					graphics.beginFill(0xF3F3EC, 1);
					
					movePoint(x, top);
					drawPoint(x, top);
					drawPoint(x, bottom);
					drawPoint(x + UI.scale, bottom);
					drawPoint(x + UI.scale, top);
					drawPoint(x, top);
				}
				//si la fecha es hoy
				else if(Calendar.equals(today, date) && zoom != Constants.YEAR)// || equals(tomorrow, date))
				{
					if(Calendar.isFirstDayOfTheMonth(date))
					{
						graphics.lineStyle(1, 0x333333, 1);
					}
					else
					{
						graphics.lineStyle(1, 0x999999, 1);
					}
					graphics.beginFill(0xC0C0Bf, 1);
					
					movePoint(x, top);
					drawPoint(x, top);
					drawPoint(x, bottom);
					drawPoint(x + UI.scale, bottom);
					drawPoint(x + UI.scale, top);
					drawPoint(x, top);
				}
				//si la fecha NO es ni fin de semana ni hoy
				else
				{
					if(Calendar.isFirstDayOfTheMonth(date))
					{
						graphics.lineStyle(1, 0x333333, 1);
					}
					else
					{
						graphics.lineStyle(1, 0xC0C0Bf, 1);
					}
					movePoint(x, top);
					drawVerticalLine(x, top, bottom);
				}
			}
			graphics.endFill();
		}

	    /**
	     * Draw a vertical line
	     */
		private function drawVerticalLine(x : int, top : int, bottom : int) : void 
		{
			drawPoint(x, top);
			drawPoint(x, bottom);
		}
		
		/**
	     * Draw a horizontal line
	     */
		private function drawHorizontalLine(y : int, left : int, right : int) : void 
		{
			drawPoint(left, y);
			drawPoint(right, y);
		}
		
		/**
	    * Assign a point to a graphic to draw the lines.
	    */
	    private function drawPoint(x : int, y : int) : void
	    {
	    	graphics.lineTo(x + UI.MARGIN, y);
	    }
	    
	    /**
	    * Move the cursor to draw into the graphic.
	    */
	    private function movePoint(x : int, y : int) : void
	    {
	    	graphics.moveTo(x + UI.MARGIN, y);
	    }
	}
}