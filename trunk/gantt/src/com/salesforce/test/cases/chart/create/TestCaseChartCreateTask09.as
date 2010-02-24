package com.salesforce.test.cases.chart.create
{
	import com.salesforce.gantt.controller.Constants;
	import com.salesforce.gantt.model.UiTask;
	import com.salesforce.test.AssertMessage;
	import com.salesforce.test.cases.BaseTestCase;
	import com.salesforce.test.helper.AlertHelper;
	import com.salesforce.test.helper.BarControlHelper;
	import com.salesforce.test.helper.GridHelper;
	import com.salesforce.test.helper.TaskEditOverlayHelper;
	import com.salesforce.test.util.TaskHelper;
	
	import flash.events.Event;
	
	import mx.events.ListEvent;
	
		
	
	/**
	 *	Test Case : Create a sub task.
	 * 
	 *  @author Rodrigo Birriel - August 12, 2009
	*/
	public class TestCaseChartCreateTask09 extends BaseTestCase
	{
		var parent : UiTask;
		
		public function TestCaseChartCreateTask09()
		{
		}
		
		public function test2execute() : void{
			TaskHelper.instance.createTask();
			TaskHelper.instance.addEventListener(Event.COMPLETE,addAsync(step1,10000,null,fault));
		}
		
		//Select the row that contains the task you want to be above the new task.
		private function step1(object : Object) : void{
			
			parent = TaskHelper.instance.task;
			
			listenForEvent(GridHelper.instance,ListEvent.ITEM_CLICK,EVENT_EXPECTED);
			GridHelper.instance.selectRowNewTaskCreated();
			assertEvents(AssertMessage.ROW_NO_SELECTED);
			step2();
		}
		
		//Click on: - “New” button. - Choose “Create sub task” option.
		private function step2() : void{
			listenForEvent(BarControlHelper.instance,ListEvent.CHANGE,EVENT_EXPECTED);
			BarControlHelper.instance.clickInsertTask(BarControlHelper.SUBTASK);
			assertEvents(AssertMessage.ROW_NO_SELECTED);
			assertTrue(AssertMessage.OVERLAY_NO_VISIBLE,TaskEditOverlayHelper.instance.isVisible());
			step3();
		}
		
		//Fill the Task Name field.
		//Fill the Description field.
		private function step3() : void{
			TaskEditOverlayHelper.instance.insertTaskName("task_1");
			TaskEditOverlayHelper.instance.insertTaskDescription("Description_1");
			assertFalse(AssertMessage.TASK_NAME_ERROR_FIELD,TaskEditOverlayHelper.instance.errorTaskName());
			assertFalse(AssertMessage.TASK_DESCRIPTION_ERROR_FIELD,TaskEditOverlayHelper.instance.errorDescription());
			step4();
		}
		
		//Click on: - Save button.
		private function step4() : void{
			TaskEditOverlayHelper.save();
			assertTrue(AssertMessage.ALERT_IS_NOT_POPUP,AlertHelper.isPopUp());
			assertEquals(AssertMessage.ALERT_TEXT_DIFFERENT,AlertHelper.text(),Constants.FIELDS_ARE_REQUIRED);
			assertTrue(AssertMessage.TAB_ASSIGNEES_NOT_VISIBLE,TaskEditOverlayHelper.tabAssignesIsVisible());
			step5();
		}
		
		//Click on: - OK button of the alert message.
		private function step5() : void{
			AlertHelper.closePopUp();
			//assertTrue(AssertMessage.ALERT_IS_NOT_POPUP,AlertHelper.isPopUp());
			step6();
		}
		
		//In the Name column select the task you want to be associated with the task to create.
		private function step6() : void{
			listenForEvent(TaskEditOverlayHelper.instance,ListEvent.CHANGE,EVENT_EXPECTED);
			TaskEditOverlayHelper.instance.selectAssignee();
			assertEvents(AssertMessage.ITEM_NO_SELECTED);
			step7();
		}
		
		private function step7() : void{
			TaskEditOverlayHelper.save();
			TaskHelper.instance.addEventListener(Event.COMPLETE,addAsync(verify,10000,null,fault));
		}
		
		private function verify(object : Object) : void{
			//check if child task is parent of the parent task.
			var child : UiTask = TaskHelper.instance.task;
			var parentAfterIndent : UiTask = TaskHelper.instance.getTaskById(parent.id);
			var areFamily : Boolean = parentAfterIndent.heriarchy.isAncestor(parentAfterIndent,child) &&
							parentAfterIndent.id == child.parent;	
			assertTrue(AssertMessage.TASK_WITHOUT_HIERARCHY,areFamily);
			
			//the parent task and child have the same duration.
			assertEquals(AssertMessage.TASK_DURATION_CHANGED,child.duration,parentAfterIndent.duration);
		}
		
		public function fault(object : Object) : void{
			fail(AssertMessage.TASK_NOT_CREATED);
		}
		
	}
}