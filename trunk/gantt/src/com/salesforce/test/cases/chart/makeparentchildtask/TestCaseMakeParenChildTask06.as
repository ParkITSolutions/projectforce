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
	 *	Test Case : Take a middle child task out of the parent task.
	 * 
	 *  @author Rodrigo Birriel - August 12, 2009
	*/
	
	public class TestCaseMakeParenChildTask06 extends BaseTestCase{
		
		private var parent : UiTask;
		private var firstChild : UiTask;
		private var secondChild : UiTask;
		
		public function TestCaseMakeParenChildTask06(methodName:String=null):void{
			super(methodName);
		}
		
		//task created above
		public function test2execute():void{
			TaskHelper.instance.createTask(false,2);
			TaskHelper.instance.addEventListener(Event.COMPLETE, addAsync(previous1, 10000, null, fault));
		}
		
		//first sub task created
		public function previous1(obj:Object):void{
			parent = TaskHelper.instance.task;
			TaskHelper.instance.createTask(false,3,true);
			TaskHelper.instance.addEventListener(Event.COMPLETE, addAsync(previous2, 10000, null, fault));
		}
		
		//select parent task
		public function previous2(obj:Object):void{
			firstChild = TaskHelper.instance.task;
			listenForEvent(GridHelper.instance, ListEvent.ITEM_CLICK, EVENT_EXPECTED);
			GridHelper.instance.clickRow(parent.position-1);
			assertEvents(AssertMessage.ROW_NO_SELECTED);
			previous3();
		}
		
		//second sub task created
		public function previous3():void{
			TaskHelper.instance.createTask(false,4,true);
			TaskHelper.instance.addEventListener(Event.COMPLETE, addAsync(previous4, 10000, null, fault));
		}
		
		//select parent task
		public function previous4(obj:Object):void{
			secondChild = TaskHelper.instance.task;
			listenForEvent(GridHelper.instance, ListEvent.ITEM_CLICK, EVENT_EXPECTED);
			GridHelper.instance.clickRow(parent.position-1);
			assertEvents(AssertMessage.ROW_NO_SELECTED);
			previous5();
		}
		
		//third sub task created
		public function previous5():void{
			TaskHelper.instance.createTask(false,5,true);
			TaskHelper.instance.addEventListener(Event.COMPLETE, addAsync(step1, 10000, null, fault));
		}		
		
		//select first child task
		public function step1(obj:Object):void{
			secondChild = TaskHelper.instance.task;
			listenForEvent(GridHelper.instance, ListEvent.ITEM_CLICK, EVENT_EXPECTED);
			GridHelper.instance.clickRow(firstChild.position-1);
			assertEvents(AssertMessage.ROW_NO_SELECTED);
			step2();
		}
		
		//Click on: - The left indentation arrow.
		public function step2():void{
			BarControlHelper.instance.clickOutdent();
			TaskHelper.instance.addEventListener(Event.COMPLETE, addAsync(verify, 10000, null, fault));		
		}
		
		private function verify(object :Object){
			var firstAfterOutdent : UiTask = TaskHelper.instance.getTaskById(firstChild.id);
			var parentAfterOutdent : UiTask = TaskHelper.instance.getTaskById(parent.id);
			var areFamily : Boolean = parentAfterOutdent.heriarchy.isAncestor(parentAfterOutdent,firstAfterOutdent);	
			assertFalse(AssertMessage.TASK_WITHOUT_HIERARCHY,areFamily);
			assertFalse(AssertMessage.TASK_DURATION_CHANGED,firstAfterOutdent.duration == parentAfterOutdent.duration);
		}
		
		public function fault(object : Object):void{
			fail(AssertMessage.TASK_NOT_CREATED);
		}
		
	}
}