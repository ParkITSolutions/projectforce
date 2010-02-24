package com.salesforce.test.cases.tasklist.edit
{
	import com.salesforce.gantt.model.UiTask;
	import com.salesforce.test.helper.GridHelper;
	import com.salesforce.test.AssertMessage;
	import com.salesforce.test.util.TaskHelper;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import flexunit.framework.EventfulTestCase;

	public class TestCaseTaskListEditTask01 extends EventfulTestCase
	{
		
		private var taskCreated : UiTask; 
		public function TestCaseTaskListEditTask01(methodName:String=null)
		{
			super(methodName);
		}
		
		public function test2Execute(): void{
			//FIXME
			//moved from setUp because of not supportting addAsyn method in this
			//print error : TypeError: Error #1006: value is not a function.
			TaskHelper.instance.createTask();
			TaskHelper.instance.addEventListener(Event.COMPLETE,addAsync(step1,10000,null,fault));
			//to here
		}
		
		//Double click on the Task Name cell.
		private  function step1(object : Object) : void{
			taskCreated = TaskHelper.instance.task;
			//listenForEvent(GridHelper.instance,KeyboardEvent.KEY_DOWN,EVENT_EXPECTED);
			listenForEvent(GridHelper.instance,MouseEvent.DOUBLE_CLICK,EVENT_EXPECTED);
			listenForEvent(GridHelper.instance,MouseEvent.CLICK,EVENT_EXPECTED);			
			//GridHelper.instance.editSelectedCell(taskCreated.position-1,4);
			GridHelper.instance.clickCell(taskCreated.position-1,4);
			GridHelper.instance.doubleClickCell(taskCreated.position-1,4);
			assertEvents(AssertMessage.ROW_NO_SELECTED);
			step2();
		}
		
		private function step2() : void{
			
		}
		
		private function step3() : void{
			
		}
		
		public function fault(object : Object = null) : void{
			fail(AssertMessage.TASK_NOT_CREATED);
		}
		
	}
}