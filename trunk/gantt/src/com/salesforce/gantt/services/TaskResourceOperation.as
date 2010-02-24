package com.salesforce.gantt.services
{
	import com.salesforce.*;
	import com.salesforce.events.*;
	import com.salesforce.gantt.controller.Components;
	import com.salesforce.gantt.model.Project;
	import com.salesforce.gantt.model.Task;
	import com.salesforce.gantt.model.TaskResource;
	import com.salesforce.gantt.util.CustomSObject;
	import com.salesforce.objects.*;
	import com.salesforce.results.*;
	
	import mx.rpc.IResponder;
	
	public class TaskResourceOperation extends BaseOperation
	{        
		/**
		 * Constructor
		 */	
		public function TaskResourceOperation() : void{
		}
		
		/**
		 * Load the resources of all tasks.
		 */	
		public function loadTasksResources(project : Project, ar : IResponder) : void
		{
			var query : String = "Select " +
								"Id," +
								"ProjectTask__c," +
								"User__c," +
								"PercentDedicated__c " +
								"From ProjectAssignee__c " +
								"WHERE Project__c = '"+ Components.instance.project.id +"'";
			connection.query(query,ar);
		}
		
		/**
		 * Edit a relation between task/resource in the database
		 */		
		public function update (task : Task,taskResources : Array, responder : IResponder) : void
		{
			var update : CustomSObject;
			var upds : Array = new Array(); 
			var ar : AsyncResponder;
			var taskResource : TaskResource;
			if(taskResources.length > 0){
				for(var i : int = 0; i < taskResources.length  ; i++){
					taskResource = taskResources[i];
					update = new CustomSObject('ProjectAssignee__c');
					update.setProperty('PercentDedicated__c',taskResource.dedicated);
					update.setProperty('Id',taskResource.id);
					update.setProperty('User__c',taskResource.resource.id.toString());
					update.setProperty('Project__c',task.project.id);
					upds.push(update);		
				}
				connection.update(upds,responder);
			}
						
		}
		
		/*
		 * Create a new relation between task/resource in the database
		 */		
		public function create(task : Task, taskResources : Array,responder : IResponder) : void
		{
			var create : CustomSObject;
			var taskResource : TaskResource;
			var arraySObject : Array;
			var ar : AsyncResponder; 
			 
			if(taskResources.length>0){
				arraySObject = new Array();
				for(var i : int = 0; i < taskResources.length ; i++){
					create = new CustomSObject('ProjectAssignee__c');
					taskResource = TaskResource(taskResources[i]);
					create.setProperty('User__c',taskResource.resource.user.id.toString());
					create.setProperty('PercentDedicated__c',taskResource.dedicated.toString());
					create.setProperty('ProjectTask__c',task.id.toString());
					create.setProperty('Project__c',task.project.id);
					arraySObject.push(create);
				}
				
			  	connection.create(arraySObject, responder);	
			}	
	  	}		
	  	
	  	/*
		 * Delete the task resources
		 *
		 * @param ids 	an array with task resources ids.
		 */	  	
		public function deleteTaskResource(taskResourceIds : Array,responder : IResponder) : void 
		{
			if(taskResourceIds.length>0){
			  	connection.deleteIds(taskResourceIds,responder);
			}
		}	
	}
}