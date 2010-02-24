package com.salesforce.test.cases.chart.redochanges
{
	import com.salesforce.gantt.model.UiTask;
	import com.salesforce.test.AssertMessage;
	import com.salesforce.test.cases.BaseTestCase;
	import com.salesforce.test.helper.BarControlHelper;
	import com.salesforce.test.helper.GridHelper;
	import com.salesforce.test.util.TaskHelper;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.events.ListEvent;
	
	/**
	 *	Test Case : Redo the creation of a task.
	 * 
	 *  @author Rodrigo Birriel - August 11, 2009
	*/
	
	public class TestCaseChartRedoChanges01 extends BaseTestCase
	{
		private var taskCreated : UiTask;
		
		public function TestCaseChartRedoChanges01() 
		{
		}
		
		public function test2Execute(): void{
			//FIXME
			//moved from setUp because of not supportting addAsyn method in this
			//print error : TypeError: Error #1006: value is not a function.
			TaskHelper.instance.createTask();
			TaskHelper.instance.addEventListener(Event.COMPLETE,addAsync(previous1,10000,null,faultCreated));
			//to here
		}

		//Select the row that contains the task you want to be above the new task.
		private function previous1(object : Object) : void{
			
			taskCreated = TaskHelper.instance.task;
			
			listenForEvent(GridHelper.instance,ListEvent.ITEM_CLICK,EVENT_EXPECTED);
			GridHelper.instance.selectRowNewTaskCreated();
			assertEvents(AssertMessage.ROW_NO_SELECTED);
			previous2();
		}
		
		//Delete a milestone.
		private function previous2() : void{
			listenForEvent(BarControlHelper.instance, MouseEvent.CLICK, EVENT_EXPECTED);
			BarControlHelper.instance.clickDelete();
			assertEvents(AssertMessage.CLICK_NOT_OCCURED);
			assertTrue(AssertMessage.OVERLAY_NO_VISIBLE, BarControlHelper.instance.overlayDeleteIsVisible());
			
			listenForEvent(BarControlHelper.instance, MouseEvent.CLICK, EVENT_EXPECTED);
			BarControlHelper.instance.confirmDelete();
			assertEvents(AssertMessage.CLICK_NOT_OCCURED);
			
			TaskHelper.instance.addEventListener(Event.COMPLETE,addAsync(previous3,10000,null,faultRedo));
		}
		
		//Click on: - Undo button
		private function previous3(object : Object) : void{
			BarControlHelper.instance.clickUndo();
			TaskHelper.instance.addEventListener(Event.COMPLETE,addAsync(step1,10000,null,faultRedo));
		}
		
		// HERE START THE THIS CASE
		private function step1(object : Object) : void{
			BarControlHelper.instance.clickRedo();
			TaskHelper.instance.addEventListener(Event.COMPLETE,addAsync(verify,10000,null,faultRedo));
		}
		
		private function verify(object : Object) : void{
			var taskAfterRedo : UiTask = TaskHelper.instance.getTaskById(taskCreated.id);
			assertNull(AssertMessage.TASK_NOT_CREATED,taskAfterRedo);
		}
		
		private function faultCreated() : void{
			fail(AssertMessage.TASK_NOT_DELETED);
		}
		
		private function faultRedo(object : Object) : void{
			fail(AssertMessage.TASK_NOT_CREATED);
		}

	}
}