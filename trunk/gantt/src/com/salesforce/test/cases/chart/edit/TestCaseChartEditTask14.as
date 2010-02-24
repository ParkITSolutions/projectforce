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
	 *	Test Case : Cancel the edition of a task.
	 * 
	 *  @author Rodrigo Birriel - August 05, 2009
	*/
	public class TestCaseChartEditTask14 extends BaseTestCase
	{
		
		private var taskPreviousName : String;
		private var taskPreviousDescription : String;
		private var taskPreviousCompleted : int;
		
		public function TestCaseChartCreateTask12()
		{
		}
		
		public function test2execute() : void{
			var task : UiTask = TaskHelper.instance.createTask();
			TaskHelper.instance.addEventListener(Event.COMPLETE,addAsync(step1,10000,null,fault));
		}
		
		//Click on the milestone you want to edit
		private function step1(object : Object) : void{
			
			taskPreviousName = TaskHelper.instance.task.name;
			taskPreviousDescription = TaskHelper.instance.task.description;
			taskPreviousCompleted = TaskHelper.instance.task.completed;
			
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
		
		//Fields:
		//- Change the Task Name field.
		//- Change the Description field.
		//- Change the percentage field.
		private function step3() : void{
			TaskEditOverlayHelper.instance.insertTaskName("name_changed");
			TaskEditOverlayHelper.instance.insertTaskDescription("description_changed");
			TaskEditOverlayHelper.instance.insertTaskCompleted("5 %");
			assertTrue(AssertMessage.TASK_DURATION_FIELD_DISABLED,TaskEditOverlayHelper.instance.enabledTaskDuration);
			assertTrue(AssertMessage.TASK_DUE_DATE_FIELD_DISABLED,TaskEditOverlayHelper.instance.enabledTaskDueDate);
			step4();
		}
		
		//Click on: - Cancel button.
		private function step4() : void{
			TaskEditOverlayHelper.cancel();
			assertFalse(AssertMessage.OVERLAY_VISIBLE,TaskEditOverlayHelper.instance.isVisible())
			verify();
		}
		
		private function verify() : void{
			var taskName : String = TaskHelper.instance.task.name;
			var taskDescription : String = TaskHelper.instance.task.description;
			var taskCompleted : int = TaskHelper.instance.task.completed
			assertEquals(AssertMessage.TASK_NAME_CHANGED,taskName,taskPreviousName);
			assertEquals(AssertMessage.TASK_DESCRIPTION_CHANGED,taskDescription,taskPreviousDescription);
			assertEquals(AssertMessage.TASK_COMPLETED_CHANGED,taskCompleted,taskPreviousCompleted);
		}
		
		public function fault() : void{
			fail(AssertMessage.TASK_NOT_CREATED);
		}
		
	}
}