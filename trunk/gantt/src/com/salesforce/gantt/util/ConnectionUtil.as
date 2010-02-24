package com.salesforce.gantt.util
{
	import com.salesforce.Connection;
	import com.salesforce.gantt.controller.Constants;
	import com.salesforce.objects.LoginRequest;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.rpc.IResponder;
	
	/**
	 * Generic class responsable for reconnecting to salesforce
	 * 
	 * @author Rodrigo Birriel.
	 */ 
	
	public class ConnectionUtil extends EventDispatcher
	{
		public static const QUERYALL : String = 'queryAll';
		public static const QUERY : String = 'query';
		public static const CREATE : String = 'create';
		public static const DELETE : String = 'delete';
		public static const UPDATE : String = 'update';
		public static const UPSERT : String = 'upsert';
		public static const LOGIN : String = 'login';
		public static const DESCRIBE_SOBJECT : String = 'describeObject';
		public static const DESCRIBE_LAYOUT : String = 'describeLayout';
		public static const UNDELETE : String = 'undelete';
		
		// five seconds
		public static const DELAY : int = 5 * 1000;
		
		public var connection : Connection;
		private var type : String;
		private var context : Object;
		private var responder : IResponder;
		private var times : int = 0;
		
		private  var timer : Timer;
		
		private static var _instance : ConnectionUtil;
		
		public static function get instance() : ConnectionUtil
        {
			if(_instance == null)
        	{
        		_instance = new ConnectionUtil();
        	}
            return _instance;
        }
		public function setQueryContext(typeQuery : String, context : Object) :void
		{	
			_instance.type = typeQuery;
			_instance.context = context;
			_instance.timer = new Timer(DELAY,1);
			_instance.timer.addEventListener(TimerEvent.TIMER_COMPLETE,dispatchFunction);	
		}

		public function reconnect(resp : IResponder = null) : void{
			dispatchEvent(new Event(Constants.RECONNECTION));
			if(!_instance.timer.running){
				_instance.responder = resp;
				_instance.timer.start();	
			}	
		}
		
		public function dispatchFunction(event : Event = null) : void {
			_instance.timer.reset();
			trace('trying to connect : '+ times++);
			if(type == QUERY){
				connection.query(String(_instance.context),_instance.responder);
			}else if(type == QUERYALL){
				connection.queryAll(String(_instance.context),_instance.responder);
			}else if(type == LOGIN){
				connection.login(LoginRequest(_instance.context));
			}else if(type == CREATE){
				connection.create(_instance.context as Array,_instance.responder);
			}else if(type == UPDATE){
				connection.update(_instance.context as Array,_instance.responder);
			}else if(type == DELETE){
				connection.deleteIds(_instance.context as Array,_instance.responder);
			}else if(type == UNDELETE){
				connection.undelete(_instance.context as Array,_instance.responder);
			}else if(type == DESCRIBE_SOBJECT){
				connection.describeSObject(String(_instance.context),_instance.responder);
			}else if(type == DESCRIBE_LAYOUT){
				connection.describeLayout(String(_instance.context),null,_instance.responder);
			}
		}
	}
}