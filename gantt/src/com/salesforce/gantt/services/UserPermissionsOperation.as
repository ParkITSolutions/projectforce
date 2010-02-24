package com.salesforce.gantt.services
{
	import com.salesforce.*;
	import com.salesforce.events.*;
	import com.salesforce.gantt.model.User;
	import com.salesforce.objects.*;
	import com.salesforce.results.*;
	
	import mx.rpc.IResponder;
	
	/**
	 * Class responsible to manage the queries to user table.
	 * 
	 */ 
	public class UserPermissionsOperation extends BaseOperation
	{
	
		public function UserPermissionsOperation() : void{
		}
		
		/**
		 * Query to check if a user is an admin.
		 * 
		 * @param user the user to query for his permissions.
		 * @param iresponder the responder which receive the callback's function.
		 */ 
		public function isAdmin(user : User, ar : IResponder) : void{	
			var queryModifyAllData : String = "Select Profile.PermissionsModifyAllData From User where id ='"+user.id+"' limit 1"; 	
			connection.query(queryModifyAllData,ar);					
		}
	}
}