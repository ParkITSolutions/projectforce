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
	 *	Test Case : Edit a task with Edit button, and change the name and the description.
	 * 
	 *  @author Rodrigo Birriel - August 04, 2009
	*/
	public class TestCaseChartEditTask01 extends BaseTestCase
	{
		private var taskPreviousName : String ;
		private var taskPreviousDescription : String
		public function TestCaseChartCreateTask1()
		{
		}
		
		public function test2execute() : void{
			var task : UiTask = TaskHelper.instance.createTask();
			taskPreviousName = task.name;
			taskPreviousDescription = task.description;
			TaskHelper.instance.addEventListener(Event.COMPLETE,addAsync(step1,10000,null,fault));
		}
		
		//Select the row that contains the task you want to be above the new task.
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
		
		//Fill the Task Name field.
		//Fill the Description field.
		private function step3() : void{
			TaskEditOverlayHelper.instance.insertTaskName("task_edited");
			TaskEditOverlayHelper.instance.insertTaskDescription("Description_edited");
			assertFalse(AssertMessage.TASK_NAME_ERROR_FIELD,TaskEditOverlayHelper.instance.errorTaskName());
			assertFalse(AssertMessage.TASK_DESCRIPTION_ERROR_FIELD,TaskEditOverlayHelper.instance.errorDescription());
			step4();
		}
		
		//Click on: - Save button.
		private function step4() : void{
			TaskEditOverlayHelper.save();
			TaskHelper.instance.addEventListener(Event.COMPLETE,addAsync(verify,10000,null,fault));
		}
		
		private function verify(object : Object) : void{
			//assertTrue(TaskHelper.instance.task!=null);
			var taskName : String = TaskHelper.instance.task.name;
			var taskDescription : String = TaskHelper.instance.task.description;
			assertTrue(AssertMessage.TASK_NAME_NOT_CHANGED,taskName != taskPreviousName);
			assertTrue(AssertMessage.TASK_DESCRIPTION_NOT_CHANGED, taskDescription != taskPreviousDescription);
		}
		
		public function fault(object : Object) : void{
			fail(AssertMessage.TASK_NOT_CREATED);
		}
		
	}
}