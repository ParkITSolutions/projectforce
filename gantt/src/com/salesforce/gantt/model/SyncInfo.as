package com.salesforce.gantt.model
{
	/**
	 *	Class to encapsulate the info in a synchronization action between the server 
	 *  and the local application.
	 * 
	 * @author Rodrigo Birriel
	 */ 
	public class SyncInfo
	{
		private static var _instance : SyncInfo;
		public var taskCreated : int = 0;
		public var taskDeleted : int = 0;
		public var taskUpdated : int = 0;
		public var alreadyShow : Boolean = true;
		
		public function SyncInfo()
		{
		}
		
		public static function get instance() : SyncInfo{
			if(!_instance){
				_instance = new SyncInfo();
			}	
			return _instance;
		}
		
		public function title() : String{
			return "Task results:";
		}
		
		public function toString():String{
			alreadyShow = true;
			var message : String = '';
			if(toShow()){
				message += "created : "+taskCreated+"\n";
				message += "deleted : "+taskDeleted+"\n";
				message += "updated : "+taskUpdated+"\n";	
			}else{
				message += "no changes." 
			}
			
			return message;
		}
		
		private function toShow():Boolean{
			return (taskCreated + taskDeleted + taskUpdated) !=0;
		}

	}
}