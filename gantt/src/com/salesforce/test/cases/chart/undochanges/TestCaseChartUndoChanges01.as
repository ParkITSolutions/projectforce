package com.salesforce.test.cases.chart.undochanges
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
	 *	Test Case : Undo the deletion of a task.
	 * 
	 *  @author Rodrigo Birriel - August 07, 2009
	*/
	
	public class TestCaseChartUndoChanges01 extends BaseTestCase
	{
		private var taskCreated : UiTask;
		
		public function TestCaseChartUndoChanges01() 
		{
		}
		
		public function test2Execute(): void{
			//FIXME
			//moved from setUp because of not supportting addAsyn method in this
			//print error : TypeError: Error #1006: value is not a function.
			TaskHelper.instance.createTask();
			TaskHelper.instance.addEventListener(Event.COMPLETE,addAsync(step1,10000,null,faultCreated));
			//to here
		}

		//Select the row that contains the task you want to be above the new task.
		private function step1(object : Object) : void{
			
			taskCreated = TaskHelper.instance.task;
			
			listenForEvent(GridHelper.instance,ListEvent.ITEM_CLICK,EVENT_EXPECTED);
			GridHelper.instance.selectRowNewTaskCreated();
			assertEvents(AssertMessage.ROW_NO_SELECTED);
			step2();
		}
		
		//Delete a milestone.
		private function step2() : void{
			listenForEvent(BarControlHelper.instance, MouseEvent.CLICK, EVENT_EXPECTED);
			BarControlHelper.instance.clickDelete();
			assertEvents(AssertMessage.CLICK_NOT_OCCURED);
			assertTrue(AssertMessage.OVERLAY_NO_VISIBLE, BarControlHelper.instance.overlayDeleteIsVisible());
			
			listenForEvent(BarControlHelper.instance, MouseEvent.CLICK, EVENT_EXPECTED);
			BarControlHelper.instance.confirmDelete();
			assertEvents(AssertMessage.CLICK_NOT_OCCURED);
			
			TaskHelper.instance.addEventListener(Event.COMPLETE,addAsync(step3,10000,null,faultUndo));
		}
		
		//Click on: - Undo button
		private function step3(object : Object = null) : void{
			BarControlHelper.instance.clickUndo();
			TaskHelper.instance.addEventListener(Event.COMPLETE,addAsync(verify,10000,null,faultUndo));
		}
		
		private function verify(object : Object) : void{
			var taskAfterUndo : UiTask = TaskHelper.instance.getTaskById(taskCreated.id);
			trace("finished");
			assertNotNull(AssertMessage.TASK_NOT_CREATED,taskAfterUndo);
		}
		
		private function faultCreated() : void{
			fail(AssertMessage.TASK_NOT_CREATED);
		}
		
		private function faultUndo() : void{
			fail(AssertMessage.TASK_NOT_DELETED);
		}

	}
}