package com.salesforce.gantt.util
{
	import com.salesforce.objects.LoginRequest;
	
	/**
	 * Specialized class to override the LoginRequest.fault
	 * 
	 * @author Rodrigo Birriel
	 */
	public class LoginResponder extends ReconnectionResponder
	{
		public function LoginResponder(actionName:String, context:Object)
		{
			super(actionName, context, LoginRequest(context).callback);
		}
		
		override public function fault(info:Object):void{
			ConnectionUtil.instance.setQueryContext(_actionName,_context);
			ConnectionUtil.instance.reconnect(LoginRequest(_context).callback);
		}
		
	}
}