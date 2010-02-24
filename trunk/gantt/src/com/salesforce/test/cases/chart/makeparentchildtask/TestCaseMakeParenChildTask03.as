package com.salesforce.test.cases.chart.makeparentchildtask
{
	
	import com.salesforce.gantt.model.UiTask;
	import com.salesforce.test.AssertMessage;
	import com.salesforce.test.cases.BaseTestCase;
	import com.salesforce.test.helper.BarControlHelper;
	import com.salesforce.test.helper.GridHelper;
	import com.salesforce.test.util.TaskHelper;
	
	import flash.events.Event;
	
	import mx.events.ListEvent;
	
	/**
	 *	Test Case : Make a task parent of multiple tasks.
	 * 
	 *  @author Rodrigo Birriel - August 11, 2009
	*/
	
	public class TestCaseMakeParenChildTask03 extends BaseTestCase{
		
		private var taskTop : UiTask;
		private var taskMiddle : UiTask;

		
		public function TestCaseMakeParenChildTask03(methodName:String=null):void{
			super(methodName);
		}
		
		//create first task
		public function test2execute():void{
			TaskHelper.instance.createTask(false,2);
			TaskHelper.instance.addEventListener(Event.COMPLETE, addAsync(previous1, 10000, null, fault));
		}
		
		//task created above
		private function previous1(obj:Object):void{
			taskTop = TaskHelper.instance.task;
			TaskHelper.instance.createTask(false,4);
			TaskHelper.instance.addEventListener(Event.COMPLETE, addAsync(previous2, 10000, null, fault));
		}
		
		//select task below
		private function previous2(object :Object):void{
			taskMiddle = TaskHelper.instance.task;
			listenForEvent(GridHelper.instance, ListEvent.ITEM_CLICK, EVENT_EXPECTED);
			GridHelper.instance.clickRow(taskMiddle.position-1);
			assertEvents(AssertMessage.ROW_NO_SELECTED);
			previous3();
		}
		
		//click indent
		private function previous3():void{
			BarControlHelper.instance.clickIndent();
			TaskHelper.instance.addEventListener(Event.COMPLETE, addAsync(previous4, 10000, null, fault));
		}
		
		private function previous4(object :Object):void{
			TaskHelper.instance.createTask(false,5);
			TaskHelper.instance.addEventListener(Event.COMPLETE, addAsync(step1, 10000, null, fault));
		}
		
		//select the bottom task
		private function step1(object : Object):void{
			var taskBottom : UiTask = TaskHelper.instance.task;
			listenForEvent(GridHelper.instance, ListEvent.ITEM_CLICK, EVENT_EXPECTED);
			GridHelper.instance.clickRow(taskBottom.position-1);
			assertEvents(AssertMessage.ROW_NO_SELECTED);
			step2();
		}
		
		//click indent bottom task
		private function step2():void{
			BarControlHelper.instance.clickIndent();
			TaskHelper.instance.addEventListener(Event.COMPLETE, addAsync(verify, 10000, null, fault));
		}
		
		private function verify(object :Object){
			var taskBottomAfterIndent : UiTask = TaskHelper.instance.task;
			var taskTopAfterIndent : UiTask = TaskHelper.instance.getTaskById(taskTop.id);
			var taskMiddleAfterIndent : UiTask = TaskHelper.instance.getTaskById(taskMiddle.id);
			var areFamily : Boolean = taskTopAfterIndent.heriarchy.isAncestor(taskTopAfterIndent,taskMiddleAfterIndent) &&
									  taskTopAfterIndent.heriarchy.isAncestor(taskTopAfterIndent,taskBottomAfterIndent);	
			assertTrue(AssertMessage.TASK_WITHOUT_HIERARCHY,areFamily);
			assertTrue(AssertMessage.TASK_DURATION_CHANGED,taskBottomAfterIndent.duration == taskMiddleAfterIndent.duration);
			assertTrue(AssertMessage.TASK_DURATION_CHANGED,taskBottomAfterIndent.duration == taskBottomAfterIndent.duration);
		}
		
		public function fault(object : Object):void{
			fail(AssertMessage.TASK_NOT_CREATED);
		}
		
	}
}