package com.salesforce.gantt.commands.dependency
{
	import com.salesforce.gantt.commands.SimpleCommand;
	import com.salesforce.gantt.controller.Components;
	import com.salesforce.gantt.model.Dependency;
	import com.salesforce.gantt.model.Project;
	import com.salesforce.gantt.model.Task;
	import com.salesforce.gantt.util.CustomSObject;
	import com.salesforce.results.QueryResult;

	/**
	 * Class responsible to encapsultate the read information about a tasks's dependencies.
	 * 
	 * @author Rodrigo Birriel
	 */	
	public class ReadDependencyCommand extends SimpleCommand
	{
		private var project : Project;
		
		public function ReadDependencyCommand(project : Project)
		{
			super();
			this.project = project;
		}
		
		override public function execute():void {
			Components.instance.salesforceService.dependencyOperation.load(project,this);
		}
		
		override protected function actionCallBack(response : Object):void{
			var queryResult : QueryResult = response as QueryResult;
			var record : CustomSObject;
		    if(queryResult.records){
	    		for (var i : int = 0; i < queryResult.records.length; i++){
	            	record = queryResult.records[i];
					var lagType : int		= record.getProperty('Lag_Type__c');
					var lagTime : int		= record.getProperty('Lag_Time__c');
					var lagUnits : int 		= record.getProperty('Lag_Unit__c');
					var id : String			= record.Id;
					var parentId : String	= record.getProperty('Parent__c');
					var childId : String	= record.getProperty('Predecessor__c');
					
					var parent : Task = Components.instance.tasks.getTask(parentId);
					var child : Task = Components.instance.tasks.getTask(childId);				
					
					if(parent!= null)
					{						
						var dependency : Dependency = new Dependency(parent, lagType, lagTime, lagUnits, id);
						if (child != null && child.getDependency(id) == null)
						{
							child.addDependency(dependency);
							Components.instance.tasks.allTasks.setItemAt(child,child.position-1);
						}
					}
	            }
		    }
		}
	}
}