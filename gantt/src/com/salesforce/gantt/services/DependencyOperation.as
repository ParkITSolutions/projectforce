package com.salesforce.gantt.services
{
	import com.salesforce.*;
	import com.salesforce.events.*;
	import com.salesforce.gantt.controller.Components;
	import com.salesforce.gantt.model.Dependency;
	import com.salesforce.gantt.model.Project;
	import com.salesforce.gantt.model.Task;
	import com.salesforce.gantt.util.CustomSObject;
	import com.salesforce.objects.*;
	import com.salesforce.results.*;
	
	import mx.rpc.IResponder;
	
	public class DependencyOperation extends BaseOperation{
		        
		public function DependencyOperation() : void{
		}

		/* 
		 * Loads dependencies from DB into memory
		 * TODO refactor this method
		 */
		public function load(project : Project, ar : IResponder) : void{
			//TODO filter by project id.
			var query : String = "Select Id, Lag_Type__c, Lag_Time__c, Lag_Unit__c, Predecessor__c, Parent__c" + 
			" From ProjectTaskPred__c where Project__c ='"+project.id+"'";	
			connection.query(query,ar);		
		 }
	    /*
		 * Creates a new dependency in the DB
		 */
		public function create(dependencies : Array, task : Task,responder : IResponder = null) : void
		{
			try
			{	
				var sObjectArray : Array = new Array();
				var create : CustomSObject;
				for each(var dependency : Dependency in dependencies){
					create = new CustomSObject('ProjectTaskPred__c');
				   	create.setProperty('Parent__c',dependency.task.id);
				   	create.setProperty('Predecessor__c',task.id);
				   	create.setProperty('Lag_Type__c',dependency.lagType);
				   	create.setProperty('Lag_Time__c',dependency.lagTime);
				   	create.setProperty('Lag_Unit__c',dependency.lagUnits);
				   	create.setProperty('Project__c',Components.instance.project.id);
					sObjectArray.push(create);
				}
			   	
			    connection.create(sObjectArray,responder);
			}
			catch (ex : *)
			{
			}
	  	}
	  	
		/*
		 * Edits a dependency in the DB
		 */	  	
		public function update(task : Task,dependencies : Array, responder : IResponder) : void
		{
			var dependency : Dependency;
			var sObjectArray : Array = new Array();
			var upd : CustomSObject;
			if(dependencies.length > 0){
				for each(var dependency : Dependency in dependencies){
					upd = new CustomSObject('ProjectTaskPred__c');
					if( dependency.task!= null)
					{
						upd.setProperty('Parent__c',dependency.task.id);
					}
					upd.setProperty('Lag_Type__c',dependency.lagType);
					upd.setProperty('Lag_Time__c',dependency.lagTime);
					upd.setProperty('Lag_Unit__c',dependency.lagUnits);
					upd.setProperty('Project__c',task.project.id);
					upd.setProperty('Id',dependency.id);
					
					sObjectArray.push(upd);
				}		
				connection.update(sObjectArray,responder);	
			}
		}
		/*
		 * Deletes dependencies
		 *
		 * @param ids Array containing dependencies ids to delete.
		 */	  	
		public function deleteDependencies(ids : Array,task : Task,responder : IResponder) : void 
		{
			if(ids.length>0){
			  	connection.deleteIds([ids],responder);
			  };
		}	
	}
}
