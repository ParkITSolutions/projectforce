package com.salesforce.test.cases.chart.edit
{
	import com.salesforce.gantt.model.Calendar;
	import com.salesforce.gantt.model.UiTask;
	import com.salesforce.test.AssertMessage;
	import com.salesforce.test.cases.BaseTestCase;
	import com.salesforce.test.helper.BarControlHelper;
	import com.salesforce.test.helper.GridHelper;
	import com.salesforce.test.helper.TaskEditOverlayHelper;
	import com.salesforce.test.util.TaskHelper;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.events.ListEvent;
	
		
	
	/**
	 *	Test Case : Edit a task with Edit button, and change the Start Date.
	 * 
	 *  @author Rodrigo Birriel - August 12, 2009
	*/
	public class TestCaseChartEditTask04 extends BaseTestCase
	{
		private var taskCreated : UiTask;
		
		public function TestCaseChartCreateTask3()
		{
		}
		
		public function test2execute() : void{
			var task : UiTask = TaskHelper.instance.createTask(false,4);
			TaskHelper.instance.addEventListener(Event.COMPLETE,addAsync(step1,10000,null,fault));
		}
		
		//Double click on the task you want to edit.
		private function step1(object : Object) : void{
			taskCreated = TaskHelper.instance.task;
			listenForEvent(GridHelper.instance,ListEvent.ITEM_CLICK,EVENT_EXPECTED);
			GridHelper.instance.selectRowNewTaskCreated();
			assertEvents(AssertMessage.ROW_NO_SELECTED);
			step2();
		}
		
		//Click on: - “Edit” button.
		private function step2() : void{
			listenForEvent(BarControlHelper.instance,MouseEvent.CLICK,EVENT_EXPECTED);
			BarControlHelper.instance.clickEdit();
			assertEvents(AssertMessage.CLICK_NOT_OCCURED);
			assertTrue(AssertMessage.OVERLAY_NO_VISIBLE,TaskEditOverlayHelper.instance.isVisible());
			step3();
		}
		
		//Edit a task with Edit button, and change the Start Date.
		private function step3() : void{
			TaskEditOverlayHelper.instance.selectStartDate("+1");
			step4();
		}
		
		//Click on: - Save button.
		private function step4() : void{
			TaskEditOverlayHelper.save();
			TaskHelper.instance.addEventListener(Event.COMPLETE,addAsync(verify,10000,null,fault));
		}
		
		private function verify(object : Object) : void{
			var taskAfterSave : UiTask = TaskHelper.instance.task;
			assertTrue(AssertMessage.TASK_DURATION_NOT_CHANGED,taskCreated.duration != taskAfterSave.duration);
			
			var startDateExpected : Date = Calendar.nextWorkDate(taskCreated.startDate,1);
			var verifyStartDate : Boolean = Calendar.equals(startDateExpected,taskAfterSave.startDate);
			var verifyDueDate : Boolean = Calendar.equals(taskCreated.endDate,taskAfterSave.endDate);
			var verifyDuration : Boolean = taskAfterSave.duration == taskCreated.duration;
			assertTrue(AssertMessage.DATES_NOT_EQUALS,verifyDueDate);
			assertTrue(AssertMessage.DATES_NOT_EQUALS,verifyStartDate);
			assertFalse(AssertMessage.TASK_DURATION_CHANGED,verifyDuration);
		}
		
		public function fault(object : Object) : void{
			fail(AssertMessage.TASK_NOT_CREATED);
		}
		
	}
}