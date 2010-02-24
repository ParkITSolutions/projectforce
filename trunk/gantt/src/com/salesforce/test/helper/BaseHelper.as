package com.salesforce.test.helper
{
	import com.salesforce.test.IdReference;
	
	import flash.events.EventDispatcher;
	
	import net.sourceforge.seleniumflexapi.commands.PropertyCommands;
	import net.sourceforge.seleniumflexapi.commands.WaitForCommands;
	import net.sourceforge.seleniumflexapi.utils.AppTreeParser;
	
	public class BaseHelper extends EventDispatcher
	{
		protected var appTreeParser : AppTreeParser = SeleniumFlexAPI.seleniumFlexAPI.appTreeParser;
		protected var validCommand : Boolean = false;
		
		private var dispatcher : EventDispatcher = new EventDispatcher();
		
		public function BaseHelper()
		{
		}
		
		public function swirlingIsVisible():Boolean{
			return getResult(new PropertyCommands(appTreeParser).getFlexVisible(IdReference.SWIRLING_OVERLAY,null));
		}
		
		protected function getResult(resultString : String) : Boolean{
			return resultString == 'true';
		}
		
		public function waitForElement(id : String, delay : int = 100) : void{
			if(delay > 0){
				new WaitForCommands(appTreeParser).flexWaitForElement(id,delay);	
			}
		}
		
		public function wait(delay : int = 100) : void {
			waitForElement("",delay);
		}
	}
}