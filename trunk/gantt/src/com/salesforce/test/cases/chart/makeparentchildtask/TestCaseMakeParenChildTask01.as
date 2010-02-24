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
	 *	Test Case : Make a task parent of another one that is smaller.
	 * 
	 *  @author Rodrigo Birriel - August 11, 2009
	*/
	
	public class TestCaseMakeParenChildTask01 extends BaseTestCase{
		
		private var taskAbove : UiTask;
		private var taskBelow : UiTask;
		
		public function TestCaseMakeParenChildTask01(methodName:String=null):void{
			super(methodName);
		}
		
		public function test2execute():void{
			TaskHelper.instance.createTask(false,4);
			TaskHelper.instance.addEventListener(Event.COMPLETE, addAsync(previous1, 10000, null, fault));
		}
		
		//task created above
		public function previous1(obj:Object):void{
			taskAbove = TaskHelper.instance.task;
			TaskHelper.instance.createTask(false,2);
			TaskHelper.instance.addEventListener(Event.COMPLETE, addAsync(step1, 10000, null, fault));
		}
		public function step1(obj:Object):void{
			taskBelow = TaskHelper.instance.task;
			listenForEvent(GridHelper.instance, ListEvent.ITEM_CLICK, EVENT_EXPECTED);
			GridHelper.instance.clickRow(taskBelow.position-1);
			assertEvents(AssertMessage.ROW_NO_SELECTED);
			step2();
		}
		
		public function step2():void{
			BarControlHelper.instance.clickOutdent();
			step3();
		}
		
		public function step3():void{
			listenForEvent(GridHelper.instance, ListEvent.ITEM_CLICK, EVENT_EXPECTED);
			GridHelper.instance.clickRow(taskBelow.position);
			assertEvents(AssertMessage.ROW_NO_SELECTED);
			
			step4();
		}
		
		public function step4():void{
			BarControlHelper.instance.clickIndent();
			TaskHelper.instance.addEventListener(Event.COMPLETE, addAsync(verify, 10000, null, fault));
		}
		
		private function verify(object :Object){
			var taskBelowAfterIndent : UiTask = TaskHelper.instance.task;
			var taskAboveAfterIndent : UiTask = TaskHelper.instance.getTaskById(taskAbove.id);
			var areFamily : Boolean = taskAboveAfterIndent.heriarchy.isAncestor(taskAboveAfterIndent,taskBelowAfterIndent);	
			assertTrue(AssertMessage.TASK_WITHOUT_HIERARCHY,areFamily);
			assertTrue(AssertMessage.TASK_DURATION_CHANGED,taskBelowAfterIndent.duration == taskAboveAfterIndent.duration);
		}
		
		public function fault(object : Object):void{
			fail(AssertMessage.TASK_NOT_CREATED);
		}
		
	}
}