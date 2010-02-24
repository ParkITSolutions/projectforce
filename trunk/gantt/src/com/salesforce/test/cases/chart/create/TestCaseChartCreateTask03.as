package com.salesforce.test.cases.chart.create
{
	import com.salesforce.gantt.controller.Constants;
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
	 *	Test Case : Create a milestone below  another task.
	 * 
	 *  @author Rodrigo Birriel - August 06, 2009
	*/
	public class TestCaseChartCreateTask03 extends BaseTestCase
	{
		public function TestCaseChartCreateTask03()
		{
			super();
		}
		
		public function test2execute() : void{
			TaskHelper.instance.createTask();
			TaskHelper.instance.addEventListener(Event.COMPLETE,addAsync(step1,10000,null,fault));
		}
			
		//Select the row that contains the task you want to be above the new task.
		private function step1(object : Object) : void{
			listenForEvent(GridHelper.instance,ListEvent.ITEM_CLICK,EVENT_EXPECTED);
			GridHelper.instance.selectRowNewTaskCreated();
			assertEvents(AssertMessage.ROW_NO_SELECTED);
			step2();
		}
		
		//Click on: - “New” button. - Choose “Insert Task Below” option.
		private function step2() : void{
			listenForEvent(BarControlHelper.instance,ListEvent.CHANGE,EVENT_EXPECTED);
			BarControlHelper.instance.clickInsertTask(BarControlHelper.ABOVE);
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
		
		//Fields: - Checkout Is Milestone? Field.
		private function step4() : void{
			TaskEditOverlayHelper.instance.convertToMilestone();
			var enabledTaskDuration : Boolean = TaskEditOverlayHelper.instance.enabledTaskDuration();
			var enabledTaskDueDate : Boolean = TaskEditOverlayHelper.instance.enabledTaskDueDate();
			assertFalse(AssertMessage.TASK_DURATION_FIELD_DISABLED,enabledTaskDuration);
			assertFalse(AssertMessage.TASK_DUE_DATE_FIELD_DISABLED,enabledTaskDueDate);
			step5();
		}
		
		//Uncheck the field Is Milestone? Field .
		private function step5() : void{
			TaskEditOverlayHelper.instance.convertToMilestone(false);
			var enabledTaskDuration : Boolean = TaskEditOverlayHelper.instance.enabledTaskDuration();
			var enabledTaskDueDate : Boolean = TaskEditOverlayHelper.instance.enabledTaskDueDate();
			assertTrue(AssertMessage.TASK_DURATION_FIELD_DISABLED,enabledTaskDuration);
			assertTrue(AssertMessage.TASK_DUE_DATE_FIELD_DISABLED,enabledTaskDueDate);
			step6();
		}
		
		//Fields: - Checkout Is Milestone? Field.
		private function step6() : void{
			TaskEditOverlayHelper.instance.convertToMilestone();
			var enabledTaskDuration : Boolean = TaskEditOverlayHelper.instance.enabledTaskDuration();
			var enabledTaskDueDate : Boolean = TaskEditOverlayHelper.instance.enabledTaskDueDate();
			assertFalse(AssertMessage.TASK_DURATION_FIELD_DISABLED,enabledTaskDuration);
			assertFalse(AssertMessage.TASK_DUE_DATE_FIELD_DISABLED,enabledTaskDueDate);
			step7();
		}
		
		//Click on: - Save button.
		private function step7() : void{
			TaskEditOverlayHelper.save();
			assertTrue(AssertMessage.ALERT_IS_NOT_POPUP,AlertHelper.isPopUp());
			assertEquals(AssertMessage.ALERT_TEXT_DIFFERENT,AlertHelper.text(),Constants.FIELDS_ARE_REQUIRED);
			step8();
		}
		
		//Click on: - OK button of the alert message.
		private function step8() : void{
			AlertHelper.closePopUp();
			assertTrue(AssertMessage.TAB_ASSIGNEES_NOT_VISIBLE,TaskEditOverlayHelper.tabAssignesIsVisible());
			step9();
		}
		
		//In the Assegnees picklist choose an assegnee.
		private function step9() : void{
			listenForEvent(TaskEditOverlayHelper.instance,ListEvent.CHANGE,EVENT_EXPECTED);
			TaskEditOverlayHelper.instance.selectAssignee();
			assertEvents(AssertMessage.ITEM_NO_SELECTED);
			step10();
		}
		
		//Click on: - Save button.
		private function step10() : void{
			TaskEditOverlayHelper.save();
			TaskHelper.instance.addEventListener(Event.COMPLETE,addAsync(verify,5000,null,fault));
		}
		
		private function verify(object : Object) : void{
			assertEquals(AssertMessage.TASK_NOT_CREATED,TaskHelper.instance.task.id,'');
			assertTrue(AssertMessage.TASK_IS_NOT_MILESTONE,TaskHelper.instance.task.isMilestone);
		}
		
		public function fault(object : Object) : void{
			fail(AssertMessage.TASK_NOT_CREATED);
		}
		
	}
}