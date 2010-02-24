package com.salesforce.test.cases.chart.makeparentchildtask
{
	
	import com.salesforce.gantt.model.Calendar;
	import com.salesforce.gantt.model.UiTask;
	import com.salesforce.test.AssertMessage;
	import com.salesforce.test.cases.BaseTestCase;
	import com.salesforce.test.helper.BarControlHelper;
	import com.salesforce.test.helper.GridHelper;
	import com.salesforce.test.util.TaskHelper;
	
	import flash.events.Event;
	
	import mx.events.ListEvent;
	
	/**
	 *	Test Case : Make a task parent of another parent tasks.
	 * 
	 *  @author Rodrigo Birriel - August 11, 2009
	*/
	
	public class TestCaseMakeParenChildTask07 extends BaseTestCase{
		
		private var firstParent : UiTask;
		private var firstChild : UiTask;
		private var secondParent : UiTask;
		private var secondChild : UiTask;
		
		public function TestCaseMakeParenChildTask07(methodName:String=null):void{
			super(methodName);
		}
		
		//task created above
		public function test2execute():void{
			TaskHelper.instance.createTask(false,2);
			TaskHelper.instance.addEventListener(Event.COMPLETE, addAsync(previous1, 10000, null, fault));
		}
		
		//sub task created
		public function previous1(obj:Object):void{
			firstParent = TaskHelper.instance.task;
			TaskHelper.instance.createTask(false,4,true);
			TaskHelper.instance.addEventListener(Event.COMPLETE, addAsync(previous2, 10000, null, fault));
		}
		
		//task created above
		public function previous2(obj:Object):void{
			firstChild = TaskHelper.instance.task;
			TaskHelper.instance.createTask(false,6);
			TaskHelper.instance.addEventListener(Event.COMPLETE, addAsync(previous3, 10000, null, fault));
		}
		
		//sub task created
		public function previous3():void{
			secondParent = TaskHelper.instance.task;
			TaskHelper.instance.createTask(false,6,true);
			TaskHelper.instance.addEventListener(Event.COMPLETE, addAsync(step1, 10000, null, fault));
		}
		
		//Click on: - The third task.
		public function step1(object : Object):void{
			secondChild = TaskHelper.instance.task;
			listenForEvent(GridHelper.instance, ListEvent.ITEM_CLICK, EVENT_EXPECTED);
			GridHelper.instance.clickRow(secondParent.position-1);
			assertEvents(AssertMessage.ROW_NO_SELECTED);
			step2();
		}
		
		//Click on: - The right indentation arrow.
		public function step2():void{
			BarControlHelper.instance.clickIndent();
			TaskHelper.instance.addEventListener(Event.COMPLETE, addAsync(verify, 10000, null, fault));
		}
		
		private function verify(object :Object){
			
			//check if firstParent is parent of the third task.
			var thirdParentAfterIndent : UiTask = TaskHelper.instance.task;
			var firstParentAfterIndent : UiTask = TaskHelper.instance.getTaskById(firstParent.id);
			var firstChildAfterIndent : UiTask = TaskHelper.instance.getTaskById(firstChild.id);
			var areFamily : Boolean = firstParentAfterIndent.heriarchy.isAncestor(firstParentAfterIndent,thirdParentAfterIndent);	
			assertTrue(AssertMessage.TASK_WITHOUT_HIERARCHY,areFamily);
			
			//the end date of the first task is equals to the third one.
			var datesEquals : Boolean = Calendar.equals(secondChild.endDate,firstChildAfterIndent.endDate);
			assertTrue(AssertMessage.DATES_NOT_EQUALS,datesEquals);
		}
		
		public function fault(object : Object):void{
			fail(AssertMessage.TASK_NOT_CREATED);
		}
		
	}
}