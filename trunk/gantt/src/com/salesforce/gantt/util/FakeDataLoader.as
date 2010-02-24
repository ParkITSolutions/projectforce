package com.salesforce.gantt.util
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	
	public class FakeDataLoader extends EventDispatcher
	{
		private var url : String = 'data/customInfo.xml';
		private var xmlResult : XML = new XML();
		private var urlLoader : URLLoader;
		private var urlRequest : URLRequest;
		
		public function FakeDataLoader()
		{
			urlRequest = new URLRequest(url);
			urlLoader = new URLLoader();
			urlRequest.contentType = "xml";	
			urlLoader.addEventListener(Event.COMPLETE,retrieve);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR,error);
		}
		
		public function username() : String{
			return xmlResult.user.name;
		}
		
		public function password() : String{
			return xmlResult.user.password;
		}
		
		public function projectId() : String{
			return xmlResult.project.id;
		}
		
		public function load() : void{
			urlLoader.load(urlRequest);
		}

		private function retrieve(event : Event):void{
			
			try{
				xmlResult = new XML(event.currentTarget.data);	
			}catch(error : Error){
			}
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function error(event : Event):void{
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
	}
}