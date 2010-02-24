package com.salesforce.gantt.commands.authentication
{
	import com.salesforce.gantt.commands.SimpleCommand;
	import com.salesforce.gantt.controller.Components;
	import com.salesforce.gantt.util.ErrorHandler;
	
	import flash.events.Event;

	/**
	 * Command class responsible to certify the access to the application,
	 * using a username and password.
	 * 
	 * @author Rodrigo Birriel
	 */
	public class LocalLoginCommand extends SimpleCommand
	{
		
		private var username : String;
		private var password : String;
		
		/**
		 * Constructor 
		 * @param username : is a valid Salesforce's user.
		 * @param password : is a valid Salesforce's password.
		 * 
		 * @author Rodrigo Birriel
		 */
		public function LocalLoginCommand(username : String, password : String)
		{
			super();
			this.username = username;
			this.password = password;
		}
		
		override public function execute():void{
			Components.instance.salesforceService.authenticateOperation.localAuthenticate(username,password,this);
		}
		
		override protected function actionCallBack(response : Object) : void{
			Components.instance.resourceLogged.user.id = response.userId;
			Components.instance.resourceLogged.user.name = response.userInfo.userFullName;
		}
	}
}