package com.salesforce.test.helper
{
	import mx.controls.Button;
	
	import net.sourceforge.seleniumflexapi.commands.AlertCommands;
	import net.sourceforge.seleniumflexapi.utils.AppTreeParser;
	
	public class AlertHelper
	{
		private static var appTreeParser : AppTreeParser = SeleniumFlexAPI.seleniumFlexAPI.appTreeParser;
		private static var alertButtonOk : Button;
		public function AlertHelper()
		{
		}
		
		public static function isPopUp() : Boolean{
			return	new Boolean(new AlertCommands(appTreeParser).getFlexAlertPresent(null,null));
		}
		
		public static function text() : String {
			return new AlertCommands(appTreeParser).getFlexAlertText(null,null);
		}
		
		//TODO to implement
		public static function closePopUp() : void{
			//alertButtonOk = ComponentUtil.getAlertButtonOK();
			//alertButtonOk.setFocus();
			//alertButtonOk.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			//alertButtonOk.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN,false,false,0,Keyboard.ENTER));
			//alertButtonOk.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
		
		//TODO to implement
		public static function validMessage() : Boolean{
			return true;		
		} 
		
	}
}