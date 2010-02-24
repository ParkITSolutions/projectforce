package com.salesforce.gantt.util
{
	import com.salesforce.results.LoginResult;
	import com.salesforce.results.QueryResult;
	
	import mx.controls.Alert;
	
	/**
	 * Class responsible for handling error sent from Salesforce with
	 * as3Salesforce.swc api.
	 */ 
	public class ErrorHandler
	{
		
		public static function areErrors(object : Object) : Boolean{	
			var message : String = null;
			if( object is Array){
				message = checkArray(object as Array);
			}else if(object is QueryResult){
				//FIXME used temporaly
				message = null;
				//message = checkQueryResult(object as QueryResult);
			}else if(object is LoginResult){
				message = null;
			}else{
				message = checkArray([object]);
			}
			if(message){
				Alert.show(message);
			}
			return message!= null;
		}

		private static function checkArray(array : Array) : String{
			var error : Boolean = false;
			var message : String = null;
			var record : Object;
			for(var i:int=0; !error && i<array.length; i++){
				record = array[i]; 
				error = !record.success;
				if(error){
					message = record.errors[0].message; 
				}
			}	
			
			return message;
		}
		
		private static function checkQueryResult(queryResult : QueryResult) : String{
			var error : Boolean = false;
			var message : String = null;
			var record : Object;
			for(var i:int=0; !error && i<queryResult.size; i++){
				record = queryResult.records[i]; 
				error = !record.success;
				if(error){
					message = record.errors.message; 
				}
			}	
			
			return message;
		}
	}
}