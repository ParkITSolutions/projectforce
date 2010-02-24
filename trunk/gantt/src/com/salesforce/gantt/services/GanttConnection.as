package com.salesforce.gantt.services
{
	import com.salesforce.Connection;
	import com.salesforce.gantt.util.ConnectionConstants;
	import com.salesforce.gantt.util.LoginResponder;
	import com.salesforce.gantt.util.ReconnectionResponder;
	import com.salesforce.gantt.util.SNSUtil;
	import com.salesforce.objects.LoginRequest;
	
	import flash.utils.ByteArray;
	
	import mx.rpc.IResponder;
	
	/**
	 * Class to override all the methods which do a request a salesforce webservice, for each
	 * action overrides the callback function.
	 * 
	 * @author Rodrigo Birriel
	 */ 
	public class GanttConnection extends Connection
	{
		public function GanttConnection()
		{
			super();
		}

		override public function query(queryString : String,callback : IResponder,queryLocal : Boolean= false,passThrough : Object=null) : void{
			var newQuery : String = SNSUtil.addNamespace(queryString);
			callback = new ReconnectionResponder(ConnectionConstants.QUERY,null,callback);
			super.query(newQuery,callback,queryLocal,passThrough);
		}	
		
		override public function queryAll(queryString:String, callback:IResponder):void{
			callback = new ReconnectionResponder(ConnectionConstants.QUERYALL,queryString,callback);
			super.queryAll(queryString,callback);
		} 
		
		override public function login(loginRequest:LoginRequest, encryptionKey:ByteArray=null):void{
			loginRequest.callback = new LoginResponder(ConnectionConstants.LOGIN,loginRequest);
			super.login(loginRequest,encryptionKey);
		}
		
		override public function create(sobjects:Array, callback:IResponder, queryAfterCreate:Boolean=false):void {
			callback = new ReconnectionResponder(ConnectionConstants.CREATE,sobjects,callback);
			super.create(sobjects,callback,queryAfterCreate);
		}
	
		override public function update(sobjects:Array, callback:IResponder):void{
			callback = new ReconnectionResponder(ConnectionConstants.UPDATE,sobjects,callback);
			super.update(sobjects,callback);
		}
		
		override public function deleteIds(ids:Array, callback:IResponder):void{
			callback = new ReconnectionResponder(ConnectionConstants.DELETE,ids,callback);
			super.deleteIds(ids,callback);
		}
		
		override public function undelete(ids:Array, callback:IResponder):void{
			callback = new ReconnectionResponder(ConnectionConstants.UNDELETE,ids,callback);
			super.undelete(ids,callback);
		}
		
		override public function describeSObject(type:String, callback:IResponder):void{
			callback = new ReconnectionResponder(ConnectionConstants.DESCRIBE_SOBJECT,type,callback);
			super.describeSObject(type,callback);
		}
		
		override public function describeLayout(type:String, recordTypes:Array, callback:IResponder):void{
			callback = new ReconnectionResponder(ConnectionConstants.DESCRIBE_LAYOUT,type,callback);
			super.describeLayout(type,null,callback);
		}
		
	}
}