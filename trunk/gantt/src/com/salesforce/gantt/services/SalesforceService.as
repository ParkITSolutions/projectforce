package com.salesforce.gantt.services
{
	import com.salesforce.*;
	import com.salesforce.events.*;
	import com.salesforce.gantt.controller.Components;
	import com.salesforce.gantt.util.ConnectionUtil;
	import com.salesforce.objects.*;
	import com.salesforce.results.*;
	
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.external.*;
	import flash.utils.Timer;
    
    public class SalesforceService extends EventDispatcher
    {  
    	
		public var authenticateOperation : AuthenticateOperation;
		public var ganttStateOperation : GanttStateOperation;
		public var resourceOperation : ResourceOperation;
		public var taskOperation : TaskOperation;
		public var taskResourceOperation : TaskResourceOperation;
		public var dependencyOperation : DependencyOperation;
		public var projectOperation : ProjectOperation;
		public var metadataDescriptorOperation : MetadataDescriptorOperation;
		public var attachmentOperation : AttachmentOperation;
		public var userPermissionsOperation : UserPermissionsOperation;
		public var profileOperation : ProfileOperation;
		
		private var timer : Timer;
    	public var activateCheckRefresh : Boolean = false;
    	public var dateStart : Date;
		/* 
		 * Costructor
		 */
		public function SalesforceService() : void
		{
			var connection : Connection = new GanttConnection();
			ConnectionUtil.instance.connection = connection;
			authenticateOperation = new AuthenticateOperation();
			ganttStateOperation = new GanttStateOperation();
			resourceOperation = new ResourceOperation();
			taskOperation = new TaskOperation();
			taskResourceOperation = new TaskResourceOperation();
			dependencyOperation = new DependencyOperation();
			projectOperation = new ProjectOperation();
			metadataDescriptorOperation = new MetadataDescriptorOperation();
			attachmentOperation = new AttachmentOperation();
			userPermissionsOperation = new UserPermissionsOperation();
			profileOperation = new ProfileOperation();
			initTimer();
		}
		public function initTimer() : void 
	    {
	        // creates a new five-second Timer
	        timer = new Timer(60 * 1000, 1);
	        
	        // designates listeners for the interval and completion events
	        timer.addEventListener(TimerEvent.TIMER, check);
	        timer.addEventListener(TimerEvent.TIMER_COMPLETE, complete);
	        
	        // starts the timer ticking
	        
    		//HAY QUE DESCOMENTAR ESTOPARA PRENDER EL TIMER
	        timer.start();
	    }
	    
	    public function resetTimer(): void{
	    	if(timer.running){
	    		timer.reset();	
	    	}else{
	    		timer.start(); 
	    	}
	    	
	    }
	    
	    public function check(event : TimerEvent) : void
		{
			if(activateCheckRefresh)
			{
				var ids : Array = Components.instance.tasks.getIds();
				checkRefresh(ids);
			}
			//authenticateOperation.checkUpdate(); 
		}
	    public function complete(event : TimerEvent):void
	    {
	    	timer.stop();
			initTimer();
	    }
    	public function checkRefresh(ids : Array) : void
		{
			trace("Checking...");
			
			ganttStateOperation.load();
	
		}
    }
}