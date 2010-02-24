package com.salesforce.gantt.commands.authentication
{
	import com.salesforce.gantt.commands.SimpleCommand;
	import com.salesforce.gantt.controller.Components;
	import com.salesforce.gantt.model.Resource;
	import com.salesforce.gantt.model.User;
	import com.salesforce.gantt.util.ErrorHandler;
	import com.salesforce.results.QueryResult;
	
	import flash.events.Event;

	/**
	 * 
	 * @author Rodrigo Birriel
	 */ 
	public class ReadUserCommand extends SimpleCommand{
		private var user : User;
		
		public function ReadUserCommand(user : User){
			super();
			this.user = user;
		}
		
		/**
		 * Checks if the user is an administrator.
		 */
		override public function execute() : void{
			Components.instance.salesforceService.userPermissionsOperation.isAdmin(user,this);
		}
		
		override protected function actionCallBack(response : Object):void{
			var queryResult : QueryResult = response as QueryResult;
			var isAdmin : Boolean;
			var resource : Resource;
			if(queryResult.records.length > 0){
				isAdmin = queryResult.records[0].Profile.PermissionsModifyAllData;
				resource = Components.instance.resources.findByUser(user.id);
				
				//if the member not exists, assign the one logged.
				if(!resource){
					resource = Components.instance.resourceLogged;
				}
				
				resource.profile.canCreate ||= isAdmin;
				resource.profile.canManage ||= isAdmin;
				
				Components.instance.resourceLogged = resource;
				
			}
		}
		
	}
}