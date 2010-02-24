package com.salesforce.gantt.commands.task
{
	import com.salesforce.Util;
	import com.salesforce.gantt.commands.SimpleCommand;
	import com.salesforce.gantt.controller.Components;
	import com.salesforce.gantt.model.Calendar;
	import com.salesforce.gantt.model.Heriarchy;
	import com.salesforce.gantt.model.Project;
	import com.salesforce.gantt.model.SyncInfo;
	import com.salesforce.gantt.model.UiTask;
	import com.salesforce.gantt.model.User;
	import com.salesforce.gantt.util.CustomSObject;
	import com.salesforce.results.QueryResult;
	
	import mx.collections.ArrayCollection;

	/**
	 * Class responsible to encapsultate the read information 
	 * about all tasks of the project.
	 * 
	 * @author Rodrigo Birriel
	 */ 
	public class ReadTasksCommand extends SimpleCommand{
	
		private var project : Project;
		private var firstLoad : Boolean
		
		public function ReadTasksCommand(project : Project){
			super();
			this.project = project;
		}
		
		override public function execute():void{
			Components.instance.salesforceService.taskOperation.load(project,this,true);
		}
			
		override protected function actionCallBack(response : Object):void{
			var queryResult : QueryResult = response as QueryResult;
			var taskCreated : int = 0;
	    	var taskDeleted : int = 0;
	    	var taskUpdated : int = 0;
	    	var record : CustomSObject;
	    	if(queryResult.size > 0)
	    	{
	    		var usersIds : Array = new Array();
	    		//var tasksTemp : ArrayCollection = new ArrayCollection();
		    	for (var i : int = 0; i < queryResult.records.length; i++) 
	            {
					record = queryResult.records[i];
					var name : String = record.getProperty('Name');
					var description : String = record.getProperty('Description__c');
	
					var startDateString : String = record.getProperty('StartDate__c');
					
					var endDateString : String = record.getProperty('EndDate__c');
				    //new duration calculation
					var startDate : Date = new Date(Util.stringToDate(startDateString));
					var endDate : Date;
					
					//check if endDate is null
					if(endDateString == null){
						endDateString = startDateString;
					}
					endDate = new Date(Util.stringToDate(endDateString));
					var durationInDays = Calendar.durationInDays(startDate,endDate);					
					var parentTaskId : String = record.getProperty('ParentTask__c');
					var id : String = record.Id;
					var completed : int = Number(record.getProperty('PercentCompleted__c'));
					var isExpanded : Boolean = record.getProperty('IsExpanded__c');
					var isMilestone : Boolean = record.getProperty('Milestone__c');
					var duration : Number = Number(record.getProperty('DurationUI__c'));
					var taskPosition : String = record.getProperty('TaskPosition__c'); 
					if(record.getProperty('Priority__c') != null)
					{
						var priority : String = record.getProperty('Priority__c');
					}	else {
						var priority : String = 'Normal';
					}
					var task : UiTask = Components.instance.tasks.getTask(id);
					// create a temporal task with the information recovered
					var taskTemp : UiTask = new UiTask(name, startDate,endDate, duration, id, completed, isExpanded, isMilestone, priority, parentTaskId,description,record.valueOf());
					
					// if the task is new, create a new UiTask and add to the tasks collection.
					// otherwise update the task.
					
					// inserts the new tasks
					if(task == null){	
						task = taskTemp;
						task.heriarchy = new Heriarchy(record.getProperty('Indent__c'), null);
						if(taskPosition == null){
							task.position = Components.instance.tasks.length();	
						}else{
							task.position = int(taskPosition) -1;
						}
						task.positionVisible = task.position + 1;
						Components.instance.tasks.addTaskAt(task,task.position);
						taskCreated++;
					}else{
					// updates the tasks
						if(record.LastModifiedDate != task.lastModifiedDate){
							task.update(taskTemp);	
							task.position = int(taskPosition);
							taskUpdated++;
						}
					}
					var createUser : User = new User(record.CreatedById);
						task.createdBy = createUser;
					var lastModifiedUser : User = new User(record.LastModifiedById);
					task.lastModified = lastModifiedUser;
					var lastModifiedDate : String = record.LastModifiedDate;
					task.lastModifiedDate = lastModifiedDate;
					if(description == null){
						task.description = '';
					}else{
						task.description = description;	
					}
					
					if(!existInArray(usersIds, record.CreatedById))
					{
						usersIds.push(record.CreatedById);
						Components.instance.users.users.addItem(createUser);
					}
					if(!existInArray(usersIds, record.LastModifiedById))
					{
						usersIds.push(record.LastModifiedById);
						Components.instance.users.users.addItem(lastModifiedUser);
					}
						
	            }
		          	
	          	//Removes the tasks deleted from the server
	          	taskDeleted = removeTasks(queryResult.records);
		          	
		        SyncInfo.instance.taskCreated = taskCreated;
		        SyncInfo.instance.taskUpdated = taskUpdated;
		        SyncInfo.instance.taskDeleted = taskDeleted;
			        
			}
	    	else
	    	{
	    		// remove all the tasks from the gantt
	    		var idsLocal : Array = Components.instance.tasks.getIds();
				Components.instance.tasks.deleteTasks(idsLocal);
	
				taskDeleted = idsLocal.length;
	    	}
		    	
	    	Components.instance.tasks.checkParent();
		    Components.instance.tasks.setParent();
		    Components.instance.tasks.refreshDates();
		}
	
		private function existInArray(array : Array, item : String) : Boolean{
			var exist : Boolean = false;
			for(var i : int = 0; i <= array.length; i++)
			{
		 		if(array[i] == item)
		 		{
		 			exist = true;
		 		}
		 	}
		 	return exist;
		}
		
		private function removeTasks(idsFromServer : ArrayCollection) : int{
			var idsLocal : Array = Components.instance.tasks.getIds();
			var taskId : String;
			var found : Boolean;
			var idsDeletedArray : Array = new Array();
			var numsDeleted : int = 0;
			for(var i : int = 0;i<idsLocal.length;i++){
				taskId = idsLocal[i];
				found = false;
				for(var j : int = 0;!found&&j<idsFromServer.length;j++){
					found = idsFromServer[j].Id == taskId;
				}
				if(!found){
					idsDeletedArray.push(taskId);
				}
			}
			numsDeleted = idsDeletedArray.length;
			Components.instance.tasks.deleteTasks(idsDeletedArray);
			return numsDeleted;
		}
	}
}