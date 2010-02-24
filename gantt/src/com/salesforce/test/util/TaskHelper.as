package com.salesforce.test.util
{
	import com.salesforce.gantt.controller.Components;
	import com.salesforce.gantt.controller.Constants;
	import com.salesforce.gantt.model.Calendar;
	import com.salesforce.gantt.model.Dependency;
	import com.salesforce.gantt.model.Task;
	import com.salesforce.gantt.model.TaskResource;
	import com.salesforce.gantt.model.UiTask;
	import com.salesforce.gantt.services.DependencyOperation;
	import com.salesforce.gantt.services.TaskOperation;
	import com.salesforce.gantt.services.TaskResourceOperation;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.core.Application;
	
	public class TaskHelper extends EventDispatcher
	{
		private static const ADD_DEPENDENCY : String = "add dependency";
		private static const ADD_TASK : String	= "add task";
		private static const ADD_RESOURCE : String = "add resource";
		private static var newdate : Date = new Date();
		private static var id : int = 1;
		private static var _instance : TaskHelper;
		private var operation : String;
		private var taskOperation : TaskOperation;
		private var dependencyOperation : DependencyOperation;
		private var taskResourceOperation : TaskResourceOperation;
		private var main = Application.application.mainView;
		
		public var task : UiTask ;
		
		function TaskHelper(){
			taskOperation = Components.instance.salesforceService.taskOperation;
			dependencyOperation = Components.instance.salesforceService.dependencyOperation;
			taskResourceOperation = Components.instance.salesforceService.taskResourceOperation;
			//taskOperation.addEventListener(Constants.LOADING_END,endLoading);
			//taskResourceOperation.addEventListener(Constants.TASK_SELECT,endLoading);
			//dependencyOperation.addEventListener(Constants.LOADING_END,endLoading);
			//taskOperation.addEventListener(Constants.TASK_CREATED_UPDATED,endLoading);
		}
		
		public static function get instance() : TaskHelper{
			if(!_instance){
				_instance = new TaskHelper()
			}
			return _instance;
		}
		
		public function getTaskByPos(position : int) : UiTask{
			return Components.instance.tasks.getTaskIndex(position);
		}
		
		public function getTaskById(id : String) : UiTask{
			return Components.instance.tasks.getTask(id);
		}
		
		public function newTask(isMilestone:Boolean,duration : int) : UiTask{
			var durationInHour : Number = duration;
			if(Components.instance.project.durationInHours){
				durationInHour = duration * Components.instance.project.hoursPerDay; 
			}
			var name : String = 'task_'+id;
			var description : String = 'description_'+id;
			var startDate : Date = newdate;
			var dueDate : Date = Calendar.add(newdate,duration-1);
			var task : UiTask = new UiTask(name,startDate,dueDate,durationInHour); 
			task.position = Components.instance.tasks.length();
			task.description = description;
			if(isMilestone) task.isMilestone = true;
			id++;
			return task;
		}
		
		public function createTask(isMilestone:Boolean = false,duration : int = 1,subtask : Boolean = false) : UiTask{
			operation = ADD_TASK;
			loading();
			task = newTask(isMilestone,duration);
			if(subtask){
				Components.instance.controller.addTask(task, Constants.ACTION_ADD_CHILD);
			}else{
				Components.instance.controller.addTask(task, Constants.ACTION_ADD_WRITING);	
			}
			return task;	
		}
		
		public function createDependency(dependency : Dependency,taskDependency : UiTask) : void{
			operation = ADD_DEPENDENCY;
			task = taskDependency;
			loading();
			Components.instance.controller.addDependency([dependency],taskDependency);
		}
		
		public function createTaskResource(taskToAddResource : UiTask ,taskResource : TaskResource = null) : void{
			operation = ADD_RESOURCE;
			task = taskToAddResource;
			loading();
			if(taskResource==null){
				taskResource = Components.instance.getUserTaskResource();
			}
			Components.instance.tasks.select(taskToAddResource.id);
			//Components.instance.controller.addTaskResource([taskResource]);
		}
		
		
		public function deleteTask(allTasks : Boolean = false) : void{
			loading();
			
			if(allTasks){
				var tasks : ArrayCollection = Components.instance.tasks.allTasks;
				//Components.instance.salesforceService.taskOperation.deleteTasks(tasks,null);
			}else{
				//update the task with the id assigned from the server
				task = Components.instance.tasks.getTaskIndex(task.position);
				Components.instance.controller.deleteTask(task);	
			}
			
		}
		
		public function equals(task1 : UiTask, task2 : UiTask) : Boolean{
			var equals : Boolean = Calendar.equals(task1.startDate,task2.startDate) &&
								   Calendar.equals(task1.endDate,task2.endDate) &&
								   task1.duration == task2.duration &&
								   task1.completed == task2.completed;
			return equals;	
		}
		
		/**
		 * Checks if exists a task in the server or in the local copy.
		 */
		public function existTask(object : Object) : Boolean{
			var existTask : Boolean = Components.instance.tasks.getTask(task.id) != null;
			return existTask;
		}
		
		private function endLoading(event : Event) : void{
			try{
				if(!operation || operation == ADD_TASK){
					task = Components.instance.tasks.getTaskIndex(Components.instance.tasks.length()-1);	
				}else if(operation == ADD_DEPENDENCY || operation == ADD_RESOURCE ){
					task = Components.instance.tasks.getTask(task.id);
				}
			}catch(error : RangeError){
				task = null;
			}
			loading(false);
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function loading(visible : Boolean = true) : void{
			Application.application.mainView.visibilityLoadingProgress(visible);
		}
	}
	
}