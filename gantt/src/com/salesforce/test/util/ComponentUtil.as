package com.salesforce.test.util
{
	import flash.utils.describeType;
	
	import mx.controls.Alert;
	import mx.controls.Button;
	import mx.core.Application;
	
	public class ComponentUtil
	{
		
		public static function getAlert():Alert {

			try {

				var root:Object = Application.application.parent;

				for(var i:int = 0; i < root.numChildren; i++) {

					// get the child node of the 

					var child:Object = root.getChildAt(i);

					// get the XML type description of the child node
					var classInfo:XML = describeType(child);

					// return the child if its an alert control

					if(classInfo.@name.toString() == "mx.controls::Alert") {

						return Alert(child);

					}

				}

			}

			catch(e:Error) {}

			return null;

		}
		
		public static function getAlertButtonOK():Button {
			
			var alertForm = getAlert().getChildAt(0);
			
			try {

				for(var i:int = 1; i < alertForm.numChildren; i++) {

					var alertButton:Button = Button(alertForm.getChildAt(i));

					if(alertButton.label.toLowerCase() == "OK".toLowerCase()) {

						return alertButton;

					}

				}

			}

			catch(e:Error) {}

			return null;

		}

	}
}