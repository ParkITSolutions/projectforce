package com.salesforce.gantt.util
{
	import com.salesforce.objects.SObject;
	import com.salesforce.results.QueryResult;
	
	import mx.rpc.IResponder;

	/**
	 * A wrapper class to override the fault method
	 * to reconnect ad infinitum.
	 * 
	 * @author: Rodrigo Birriel
	 */
	public class ReconnectionResponder implements IResponder
	{
		protected var _callback : IResponder;
		protected var _context : Object;
		protected var _actionName : String;
		
		public function ReconnectionResponder(actionName : String, context : Object ,callback : IResponder = null){
			_callback = callback;
			_actionName = actionName;
			_context = context;
		}

		/**
		 * Intercept the callback to inject the CustomSObject instead of SObject
		 * to encapsulate the namespace.
		 * 
		 * @param data 	the response from the server
		 */ 
		public function result(data:Object):void{
			data = overrideResult(data);
			return _callback.result(data);
		}
		
		public function fault(info:Object):void{
			ConnectionUtil.instance.setQueryContext(_actionName,_context);
			ConnectionUtil.instance.reconnect(_callback);
		}
		
		/**
		 * Depending on the data type, this object can be modified to inject the
		 * CustomSObject's instances instead of SObject's one.
		 * 
		 * @param data	
		 */ 
		private function overrideResult(data : Object) : Object{
			var queryResult : QueryResult;
			var sObject : SObject;
			if(data is QueryResult){
				queryResult = data as QueryResult;
				if(queryResult.size > 0){
					for(var i:int =0; i< queryResult.size;i++){
						sObject = queryResult.records[i];
						queryResult.records[i] = new CustomSObject(sObject);
					}
				}	
			}
			return data;
		}
		
	}
}