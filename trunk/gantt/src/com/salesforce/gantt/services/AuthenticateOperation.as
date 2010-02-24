package com.salesforce.gantt.services
{
	import com.salesforce.*;
	import com.salesforce.events.*;
	import com.salesforce.objects.*;
	import com.salesforce.results.*;
	
	import mx.controls.Alert;
	import mx.rpc.IResponder;
	import mx.utils.ObjectUtil;
	
	public class AuthenticateOperation extends BaseOperation{        
		
		/*
		 * Constructor
		 */
		public function AuthenticateOperation() : void{
		}
		
		/**
		 * method used for testing
		 */
		public function localAuthenticate(username : String, password : String, ar : IResponder) : void{
			var loginRequest : LoginRequest = new LoginRequest();
			loginRequest.username = username;
			loginRequest.password = password;
			loginRequest.callback = ar
			this.connection.login(loginRequest);
		}
		
		/**
		 * methos used for normal authentication with server
		 * @param serverUrl :
		 */ 
		public function normalAuthenticate(serverUrl : String, sessionId : String, ar : IResponder) : void{
			var loginRequest : LoginRequest = new LoginRequest();
			loginRequest.server_url = serverUrl;
			loginRequest.session_id = sessionId;
			loginRequest.callback = ar
			this.connection.login(loginRequest);
		}

	}
}