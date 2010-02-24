package com.salesforce.gantt.commands.taskResource
{
	import com.salesforce.gantt.commands.SimpleCommand;
	import com.salesforce.gantt.controller.Components;
	import com.salesforce.gantt.model.Project;
	import com.salesforce.gantt.model.Resource;
	import com.salesforce.gantt.model.Task;
	import com.salesforce.gantt.model.TaskResource;
	import com.salesforce.gantt.util.CustomSObject;
	import com.salesforce.results.QueryResult;
	
	import mx.collections.ArrayCollection;

	/**
	 * Class responsible to encapsultate to retrieve the whole information 
	 * about tasks's resources of a specific project.
	 * 
	 * @author Rodrigo Birriel
	 */
	public class ReadTaskResourceCommand extends SimpleCommand
	{
		private var project : Project;
		public function ReadTaskResourceCommand(project : Project)
		{
			super();
			this.project = project;
		}
		
		override public function execute() : void{
			//missing the project parameter
			Components.instance.salesforceService.taskResourceOperation.loadTasksResources(project,this);
		}
		
		override protected function actionCallBack(response : Object) : void{
			var queryResult : QueryResult = response as QueryResult;
			if(queryResult.records!= null){
				// update the taskResource of a task.
				var tasksLength : int = Components.instance.tasks.length();
				var localTask : Task;
				var record : CustomSObject;
				for(var i : int = 0; i < tasksLength; i++){
					localTask = Components.instance.tasks.getTaskIndex(i);
					localTask.setTaskResources(new ArrayCollection());
				}
				for (var i : int = 0; i < queryResult.records.length; i++) 
		    	{ 
		    		record = queryResult.records[i];
		    		var taskResourceId : String = record.getProperty('Id');
		    		var taskId : String = record.getProperty('ProjectTask__c');
		    		var dedicated : int = record.getProperty('PercentDedicated__c');
		    		var resourceId : String = record.getProperty('User__c');
		    		
					var resource : Resource = Components.instance.resources.find(resourceId);
					var taskResource : TaskResource = new TaskResource(taskResourceId, resource, dedicated);
					var task : Task = Components.instance.tasks.getTask(taskId);
					
					if(task){
						task.taskResources.addItem(taskResource);
					}		
		    	}
	  		}
		}
	}
}