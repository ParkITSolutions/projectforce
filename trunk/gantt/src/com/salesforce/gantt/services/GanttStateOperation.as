package com.salesforce.gantt.services
{
	import com.salesforce.*;
	import com.salesforce.events.*;
	import com.salesforce.gantt.controller.Components;
	import com.salesforce.gantt.model.GanttState;
	import com.salesforce.gantt.model.User;
	import com.salesforce.gantt.util.CustomSObject;
	import com.salesforce.gantt.util.ErrorHandler;
	import com.salesforce.objects.*;
	import com.salesforce.results.*;
	
	import mx.rpc.IResponder;
	
	public class GanttStateOperation extends BaseOperation{
		        
		/**
		 * Constructor
		 */
		public function GanttStateOperation() : void{
		}
		
		/**
		 * Load the gantt state from database
		 */	
		public function load() : void{
			var query : String = "Select t.Id, t.date__c, t.scale__c, t.y__c" + 
		    			" From TimelineState__c t" + 
		    			" where t.Project__c  = '"+Components.instance.project.id+"'" + 
		    					" AND t.User__c ='"+Components.instance.resourceLogged.user.id+"'";
		    					
			var ar : AsyncResponder = new AsyncResponder(function (queryResult : QueryResult) : void
			    {
			    	if(queryResult.records!=null && !ErrorHandler.areErrors(queryResult))
			    	{
						var record : CustomSObject = queryResult.records[0];
						var id : String = record.Id;
						var arrayDate : Array = record.getProperty('date__c').split('-');
						var startDate : Date = new Date(arrayDate[0],arrayDate[1]-1,arrayDate[2]);
						var scale : String = record.getProperty('scale__c');
						var y : String = record.getProperty('y__c');
						var user : User = Components.instance.resourceLogged.user;
						
						Components.instance.ganttState = new GanttState(scale,startDate,y,user,id);
			    	}
		        });
			connection.query(query,ar);
		}
		
		/**
		 * Add a new gantt state in the database
		 */	
		public function create(ganttStare : GanttState, ar : IResponder) : void{
			var create : CustomSObject = new CustomSObject('TimelineState__c');
			create.setProperty('y__c',ganttStare.y);
			create.setProperty('scale__c',ganttStare.scale);
			create.setProperty('date__c',ganttStare.startDate);
			create.setProperty('User__c',Components.instance.resourceLogged.user.id);
			create.setProperty('Project__c',Components.instance.project.id);			
		  	connection.create([create],ar);
		}
		
		/**
		 * Edit the gantt statt in the database 
		 */	  	
		public function update(ganttStare : GanttState, ar : IResponder) : void{
			var upd : CustomSObject = new CustomSObject('TimelineState__c');
			upd.setProperty('Id',ganttStare.id);
			upd.setProperty('y__c',ganttStare.y);
			upd.setProperty('scale__c',ganttStare.scale);
			upd.setProperty('date__c',ganttStare.startDate);
			upd.setProperty('User__c',Components.instance.resourceLogged.user.id);
			upd.setProperty('Project__c',Components.instance.project.id);					
			connection.update([upd],ar);
		}
	  
	}
}