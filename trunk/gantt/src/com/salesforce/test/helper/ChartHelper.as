package com.salesforce.test.helper
{
	import com.salesforce.test.IdReference;
	
	import flash.events.MouseEvent;
	
	import net.sourceforge.seleniumflexapi.commands.ClickCommands;
	import net.sourceforge.seleniumflexapi.commands.PropertyCommands;
	
	public class ChartHelper extends BaseHelper
	{
		private static var _instance : ChartHelper;
		
		function ChartHelper()
		{
		}
		
		public static function get instance() : ChartHelper{
			if(_instance == null){
				_instance = new ChartHelper();
			}
			return _instance;
		}
		
		public function selectRowTaskCreated() : void{
			GridHelper.instance.selectRowNewTaskCreated();
		}
		
		public function clickToggleViewNavigator() : void{
			validCommand = new Boolean(new ClickCommands(appTreeParser).flexClick(IdReference.NAVIGATOR_TAB,null));
			if(validCommand){
				dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
		}
		
		public function barChartOverviewIsVisible():Boolean{
			return Boolean(new PropertyCommands(appTreeParser).getFlexVisible(IdReference.NAVIGATOR_OVERVIEW, null));
		}
		
		
	}
}