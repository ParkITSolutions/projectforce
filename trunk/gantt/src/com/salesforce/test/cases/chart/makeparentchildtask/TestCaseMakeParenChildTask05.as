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
	 *	Test Case : Take the last child task out of the parent task.
	 * 
	 *  @author Rodrigo Birriel - August 11, 2009
	*/
	
	public class TestCaseMakeParenChildTask05 extends BaseTestCase{
		
		private var parent : UiTask;
		private var firstChild : UiTask;
		private var secondChild : UiTask;
		
		public function TestCaseMakeParenChildTask05(methodName:String=null):void{
			super(methodName);
		}
		
		//task created above
		public function test2execute():void{
			TaskHelper.instance.createTask(false,2);
			TaskHelper.instance.addEventListener(Event.COMPLETE, addAsync(previous1, 10000, null, fault));
		}
		
		//sub task created
		public function previous1(obj:Object):void{
			parent = TaskHelper.instance.task;
			TaskHelper.instance.createTask(false,4,true);
			TaskHelper.instance.addEventListener(Event.COMPLETE, addAsync(previous2, 10000, null, fault));
		}
		
		//select task above
		public function previous2(obj:Object):void{
			firstChild = TaskHelper.instance.task;
			listenForEvent(GridHelper.instance, ListEvent.ITEM_CLICK, EVENT_EXPECTED);
			GridHelper.instance.clickRow(parent.position-1);
			assertEvents(AssertMessage.ROW_NO_SELECTED);
			previous3();
		}
		
		//task created below
		public function previous3():void{
			TaskHelper.instance.createTask(false,4,true);
			TaskHelper.instance.addEventListener(Event.COMPLETE, addAsync(step1, 10000, null, fault));
		}
		
		//select task above
		public function step1(obj:Object):void{
			secondChild = TaskHelper.instance.task;
			listenForEvent(GridHelper.instance, ListEvent.ITEM_CLICK, EVENT_EXPECTED);
			GridHelper.instance.clickRow(secondChild.position-1);
			assertEvents(AssertMessage.ROW_NO_SELECTED);
			step2();
		}
		
		//Click on: - The left indentation arrow.
		public function step2():void{
			BarControlHelper.instance.clickOutdent();
			TaskHelper.instance.addEventListener(Event.COMPLETE, addAsync(verify, 10000, null, fault));		
		}
		
		private function verify(object :Object){
			var secondAfterOutdent : UiTask = TaskHelper.instance.getTaskById(secondChild.id);
			var parentAfterOutdent : UiTask = TaskHelper.instance.getTaskById(parent.id);
			var areFamily : Boolean = parentAfterOutdent.heriarchy.isAncestor(parentAfterOutdent,secondAfterOutdent);	
			assertFalse(AssertMessage.TASK_WITHOUT_HIERARCHY,areFamily);
			assertTrue(AssertMessage.TASK_DURATION_CHANGED,secondAfterOutdent.duration == parentAfterOutdent.duration);
		}
		
		public function fault(object : Object):void{
			fail(AssertMessage.TASK_NOT_CREATED);
		}
		
	}
}