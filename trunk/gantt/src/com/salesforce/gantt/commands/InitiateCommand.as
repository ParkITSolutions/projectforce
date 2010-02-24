package com.salesforce.gantt.commands
{
	import com.salesforce.gantt.commands.authentication.LocalLoginCommand;
	import com.salesforce.gantt.commands.authentication.NormalLoginCommand;
	import com.salesforce.gantt.model.Project;
	
	/**
 	* Class responsible for the first data loading from Salesforce,
 	*
 	* @author Rodrigo Birriel
 	*/
	public class InitiateCommand extends CompositeCommand{
		 	
		private var project : Project;
		private var params : Array;
		private var localLogin : Boolean;
		private var username : String;
		private var password : String;
		private var serverUrl : String;
		private var sessionId : String;
		
		/**
		 * Constructor
		 * 
		 * @param project : the actual project
		 * @param username
		 * @param password
		 * @param serverUrl
		 * @param sessionId
		 */
		public function InitiateCommand(project : Project,username : String, password : String, serverUrl : String, sessionId : String)
		{
			super();
			this.project = project;
			this.username = username;
			this.password = password;
			this.serverUrl = serverUrl;
			this.sessionId = sessionId;
			this.localLogin = serverUrl == null;
		}
		
		override public function execute():void{
			if(localLogin){
				addCommand(new LocalLoginCommand(username,password));
			}else{
				addCommand(new NormalLoginCommand(serverUrl,sessionId));
			}
			addCommand(new RetrieveCommand(project));
			super.execute();
		}
	}
}