package com.salesforce.test.cases.chart.edit
{
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
	 *	Test Case : Edit a task making double click, and change the priority.
	 * 
	 *  @author Rodrigo Birriel - August 05, 2009
	*/
	public class TestCaseChartEditTask02 extends BaseTestCase
	{
		private var taskPreviousPriority : String ;
		
		public function TestCaseChartCreateTask2()
		{
		}
		
		public function test2execute() : void{
			var task : UiTask = TaskHelper.instance.createTask();
			taskPreviousPriority = task.priority;
			TaskHelper.instance.addEventListener(Event.COMPLETE,addAsync(step1,10000,null,fault));
		}
		
		//Double click on the task you want to edit.
		private function step1(object : Object) : void{
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
		
		//Fields: - Change the Priority field.
		private function step3() : void{
			TaskEditOverlayHelper.instance.insertTaskPriority(TaskEditOverlayHelper.MEDIUM_PRIORITY);
			step4();
		}
		
		//Click on: - Save button.
		private function step4() : void{
			TaskEditOverlayHelper.save();
			TaskHelper.instance.addEventListener(Event.COMPLETE,addAsync(verify,10000,null,fault));
		}
		
		private function verify(object : Object) : void{
			var taskPriority : String = TaskHelper.instance.task.priority;
			assertTrue(AssertMessage.TASK_PRIORITY_NOT_CHANGED,taskPriority != taskPreviousPriority);
		}
		
		public function fault(object : Object) : void{
			fail(AssertMessage.TASK_NOT_CREATED);
		}
		
	}
}