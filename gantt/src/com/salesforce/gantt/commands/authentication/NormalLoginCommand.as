package com.salesforce.gantt.commands.authentication
{
	import com.salesforce.gantt.commands.SimpleCommand;
	import com.salesforce.gantt.controller.Components;
	
	import flash.events.Event;
	
	/**
	 * Command class responsible to certify the access to the application,
	 * this command is used when the app is deployed.
	 * 
	 * @author Rodrigo Birriel
	 * 
	 */
	public class NormalLoginCommand extends SimpleCommand
	{
		
		private var serverUrl : String;
		private var sessionId : String;
		
		/**
		 * Constructor 
		 * 
		 * @param serverUrl : is the url to connect to Salesforce's web service
		 * @param sessionId : is the session id when a Salesforce's user has been logged
		 * 					  to Salesforce site.
		 * 
		 * @author Rodrigo Birriel
		 */ 
		public function NormalLoginCommand(serverUrl : String, sessionId : String){
			this.serverUrl = serverUrl;
			this.sessionId = sessionId;
		}

		override public function execute(): void{
			Components.instance.salesforceService.authenticateOperation.normalAuthenticate(serverUrl,sessionId,this);
		}
		
		override protected function actionCallBack(response : Object) : void{
			Components.instance.resourceLogged.user.id = response.userId;
			Components.instance.resourceLogged.user.name = response.userInfo.userFullName;
		}
	}
}