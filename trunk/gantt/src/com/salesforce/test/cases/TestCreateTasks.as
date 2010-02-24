package com.salesforce.test.cases
{
	import com.salesforce.gantt.controller.Constants;
	import com.salesforce.gantt.model.Dependency;
	import com.salesforce.gantt.model.UiTask;
	import com.salesforce.gantt.view.event.TaskEvent;
	import com.salesforce.test.AssertMessage;
	import com.salesforce.test.util.TaskHelper;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;

	public class TestCreateTasks extends BaseTestCase
	{
		private var howManyTasks : int;
		private var tasks : ArrayCollection;
		public function TestCreateTasks(numTasks : int = 0)
		{
			super();
			tasks = new ArrayCollection();
			howManyTasks = numTasks;
		}
		
		
		public function testCreateDependency() : void{
			if(tasks.length < 2){
				fail(AssertMessage.INSUFFICIENT_TASKS);
			}
			var taskWithDependecy : UiTask = UiTask(tasks.getItemAt(tasks.length));
			var task : UiTask = UiTask(tasks.getItemAt(tasks.length-1));
			var dependency : Dependency = new Dependency(task);
			TaskHelper.instance.createDependency(dependency,taskWithDependecy);
			TaskHelper.instance.addEventListener(Event.COMPLETE,addAsync(depedencyAdded,10000,null,fault));
		}
		
		
		public function testCreateTask() : void{
			if(howManyTasks>0){
				TaskHelper.instance.createTask();
				TaskHelper.instance.addEventListener(Event.COMPLETE,addAsync(nextTask,10000,null,fault));
			}else{
				//TaskHelper.instance.dispatchEvent(new TaskEvent(Constants.TASK_CREATED));
			}
		}
		
		private function nextTask(object : Object) : void{
			tasks.addItem(TaskHelper.instance.task);
			howManyTasks--;
			testCreateTask();	
		}
		
		private function depedencyAdded(object : Object) : void{
			TaskHelper.instance.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function fault() : void{
			fail(AssertMessage.TASK_NOT_CREATED);
		}
		
	}
}