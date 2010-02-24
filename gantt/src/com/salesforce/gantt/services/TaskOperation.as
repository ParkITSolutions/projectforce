package com.salesforce.gantt.services
{
	import com.salesforce.*;
	import com.salesforce.events.*;
	import com.salesforce.gantt.controller.Components;
	import com.salesforce.gantt.controller.SMetadataController;
	import com.salesforce.gantt.model.Project;
	import com.salesforce.gantt.model.Task;
	import com.salesforce.gantt.model.UiTask;
	import com.salesforce.gantt.util.CustomSObject;
	import com.salesforce.objects.*;
	import com.salesforce.results.*;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.rpc.IResponder;
	
	public class TaskOperation extends BaseOperation
	{        
		
		public function TaskOperation() : void{
		}


		/** 
		 * Loads DB Tasks into memory, this takes place when the app is launched.
		 * All tasks begin and end dates are calculated (to generate the "scale space")
		 * Events are triggered to instanciate all main classes including the controler.
		 * Also triggers the display of all controls (grild, bars, smallbars, edition).
		 * 
		 * The mentioned above is done when the tasksNew and tasksUpdated collection are null
		 * 
		 * TODO refactor this method, create an object SObjectFactory
		 */
		 public function load(project : Project,ar : IResponder, firstLoad = false) : void
		{
			
			var fields : Array = SMetadataController.instance.getFieldNames(SMetadataController.TASK_CUSTOM_OBJECT);
			var query : String = "SELECT " + 
				fields.join(",") +
		    		" FROM ProjectTask__c " + 
		    		" WHERE ProjectTask__c.Project__c = '"+ project.id +"'" +
		    		" ORDER BY ProjectTask__c.TaskPosition__c";
	        connection.query(query,ar);
		 }
		 
		 
	     /**
		 * Update the task ,whole dependencies and parent tasks information. 
		 */
	     public function loadUserTask(task : Task, responder : IResponder = null) : void
		 {	
		 	//FIXED O_o execute this code into the TIMER_COMPLETE event with a delay of 1 sec. 
		 	//because the server sometimes didn't finish work (See more: future annotations).			  			
		 	var timer : Timer = new Timer(1000,1);
		 	timer.addEventListener(TimerEvent.TIMER_COMPLETE, function(){
			 	var ids : Array = task.dependentTaskIds();
			 	ids.push(task.id);
			 	var idsJoin : String = ids.join("','");
			 	if(ids.length>0)
			 	{	
		 			var query : String = "SELECT p.Id, p.DurationUI__c, p.StartDate__c, p.EndDate__c, Indent__c,p.LastModifiedById, p.CreatedById, p.LastModifiedDate" +
				    			" FROM ProjectTask__c p" + 
				    			" WHERE p.Project__c  = '"+Components.instance.project.id+"'" +
				    			" AND p.Id IN ('"+idsJoin+"')";
				    connection.query(query,responder);
				 } 
		 	});
		 	timer.start();
		 }
		
	    /**
		 * Creates a new task at the DB
		 */
		public function create(task : Task, responder : IResponder) : void
		{
			var properties : Object = SMetadataController.instance.filterFields(task.properties,task.stype,SMetadataController.CREATETABLE);
			var create : CustomSObject = new CustomSObject(properties);
			create.setProperty('StartDate__c',Util.dateToString(task.startDate));	
			create.setProperty('EndDate__c',Util.dateToString(task.endDate));
			create.setProperty('PercentCompleted__c',task.completed);
			create.setProperty('Project__c',task.project.id);
		  	connection.create([create], responder );
		}
		
			  	
		/**
		 * Edits a task at the DB
		 */	  	
		public function update(task : UiTask,responder : IResponder = null) : void
		{
			var properties : Object = SMetadataController.instance.filterFields(task.properties,task.stype,SMetadataController.UPDATEABLE);
			var upd : CustomSObject = new CustomSObject(properties);
			upd.setProperty('StartDate__c',Util.dateToString(task.startDate));	
			upd.setProperty('EndDate__c',Util.dateToString(task.endDate));	
			//TODO why why ??
			upd.setProperty('PercentCompleted__c',task.completed);
			connection.update([upd],responder);
		}
		
		 
		/**
		 * Deletes several tasks
		 *
		 * @param ids Array with the ids of the tasks to delete. 
		 */	  	
		public function deleteTasks(task : Task,responder : IResponder) : void 
		{
			var ids : Array = [task.id];
		  	connection.deleteIds(ids,responder);
		}	
		
		/**
		 * Undeletes several tasks
		 * 
		 * @param ids Array with ids of the tasks to undelete
		 * 
		 */
		public function undeleteTasks(tasks : Array,responder : IResponder) : void{
			if(tasks.length>0){
				var task : Task;
		  		connection.undelete(tasks,responder);	
			}
		}
	}
}