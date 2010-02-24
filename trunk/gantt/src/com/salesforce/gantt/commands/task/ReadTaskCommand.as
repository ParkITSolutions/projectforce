package com.salesforce.gantt.commands.task
{
	import com.salesforce.Util;
	import com.salesforce.gantt.commands.SimpleCommand;
	import com.salesforce.gantt.controller.Components;
	import com.salesforce.gantt.model.Task;
	import com.salesforce.gantt.model.UiTask;
	import com.salesforce.gantt.model.User;
	import com.salesforce.gantt.util.CustomSObject;
	import com.salesforce.results.QueryResult;
	
	/**
	 * Class responsible to encapsultate the read information about a task.
	 * 
	 * @author Rodrigo Birriel
	 */ 
	public class ReadTaskCommand extends SimpleCommand
	{
		private var task : UiTask;
		public function ReadTaskCommand(task : UiTask)
		{
			this.task = task;
		}
		
		override public function execute() : void{
			Components.instance.salesforceService.taskOperation.loadUserTask(task,this);
		}
		
		override protected function actionCallBack(response : Object) : void
	    {
	    	var queryResult : QueryResult = QueryResult(response);
	    	if(queryResult.size > 0)
	    	{
	    		var record : CustomSObject;
	    		var createUser : User;
	    		var lastModifiedUser : User;
	    		var taskTemp : Task;
	    		for(var i:int=0;i<queryResult.size;i++){
	    			record = queryResult.records[i];
					createUser = Components.instance.users.getUser(record.CreatedById);
					lastModifiedUser = Components.instance.users.getUser(record.LastModifiedById);
					if(task.id == record.Id){
						taskTemp = task;
					}else{
						taskTemp = Components.instance.tasks.getTask(record.Id);	
					}
					taskTemp.lastModifiedDate = record.LastModifiedDate;
					/**
					 * TODO encapsulate the key to access to a value of the record array 
					 */ 
					taskTemp.startDate = Util.stringToDate(record.getProperty('StartDate__c'));
					if(taskTemp.isMilestone){
						taskTemp.endDate = Util.stringToDate(record.getProperty('StartDate__c'))
					}else{
						taskTemp.endDate = Util.stringToDate(record.getProperty('EndDate__c'));	
					}
					taskTemp.heriarchy.indent = record.getProperty('Indent__c');
					taskTemp.duration = record.getProperty('DurationUI__c');
					taskTemp.createdBy = createUser;
					taskTemp.lastModified = lastModifiedUser;
					//TODO refact this//
					Components.instance.tasks.allTasks.setItemAt(taskTemp,taskTemp.position>0?taskTemp.position-1:0);
					//*****************//
					Components.instance.tasks.setParent();
	    		}
	    		Components.instance.tasks.selectedTask = task;
	    	}
	    }
	}
}