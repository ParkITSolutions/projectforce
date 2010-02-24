package com.salesforce.test.cases.tasklist.create
{
	import com.salesforce.gantt.model.UiTask;
	import com.salesforce.test.AssertMessage;
	import com.salesforce.test.helper.AlertHelper;
	import com.salesforce.test.helper.BarControlHelper;
	import com.salesforce.test.helper.GridHelper;
	import com.salesforce.test.helper.TaskEditOverlayHelper;
	import com.salesforce.test.util.TaskHelper;
	
	import flash.events.Event;
	
	import flexunit.framework.EventfulTestCase;
	
	import mx.events.ListEvent;

	public class TestCaseTaskListCreateTask03 extends EventfulTestCase
	{
		
		var taskCreated : UiTask;
		public function TestCaseTaskListCreateTask03(methodName:String=null)
		{
			super(methodName);
			
		}
		
		override public function setUp():void{
		}
		
		public function test2execute():void{
			//FIXME
			//moved from setUp because of not supportting addAsyn method in this
			//print error : TypeError: Error #1006: value is not a function.
			TaskHelper.instance.createTask();
			TaskHelper.instance.addEventListener(Event.COMPLETE,addAsync(step1,10000,null,fault));
			//to here
			
		}
		
		//Select the row that contains the task you want to be below the new task.
		public  function step1(object : Object) : void{
			
			taskCreated = TaskHelper.instance.task;
			
			listenForEvent(GridHelper.instance,ListEvent.ITEM_CLICK,EVENT_EXPECTED);
			var rowTask : int = GridHelper.instance.getRowTaskCreated();
			GridHelper.instance.clickRow(rowTask);
			assertEvents(AssertMessage.ROW_NO_SELECTED);
			step2();
		}
		
		//Click on: - “New” button. - Choose “Insert Task Above” option.
		public function step2() : void{
			listenForEvent(BarControlHelper.instance,ListEvent.CHANGE,EVENT_EXPECTED);
			BarControlHelper.instance.clickInsertTask(BarControlHelper.ABOVE);
			assertEvents(AssertMessage.ROW_NO_SELECTED);
			assertTrue(AssertMessage.OVERLAY_NO_VISIBLE,TaskEditOverlayHelper.instance.isVisible());
			step3();
		}
		
		//Fields: - Fill Start Date field with a correct date stamp.
		public function step3() : void{
			TaskEditOverlayHelper.instance.selectStartDate("-1");
			step4();
		}
		
		//Fields: - Fill End Date field with a correct date stamp.
		public function step4() : void{
			TaskEditOverlayHelper.instance.selectEndDate("+1");
			step6();
		}
		
		//Change the duration for a positive number.
		public function step6() : void{
			TaskEditOverlayHelper.instance.insertTaskDuration(10);
			assertTrue(AssertMessage.INVALID_DURATION,TaskEditOverlayHelper.validDuration());
			step7();
		}
		
		//“Save” button.
		public function step7() : void{
			TaskEditOverlayHelper.save();
			assertTrue(AssertMessage.TASK_NAME_ERROR,TaskEditOverlayHelper.instance.errorTaskName());
			assertTrue(AssertMessage.TASK_DESCRIPTION_ERROR,TaskEditOverlayHelper.instance.errorDescription());	
			step8();
		}
		
		
		public function step8() : void{
			AlertHelper.closePopUp();
			//assertFalse(AssertMessage.ALERT_IS_NOT_POPUP,AlertHelper.isPopUp());
			//assertTrue(AssertMessage.TAB_ASSIGNEE_VISIBLE,TaskEditOverlayHelper.tabAssignesIsVisible());
			step9();
		}
		
		//Fill the Task Name field.
		//Fill the Description field. 
		//Choose “Low” option in Priority field.
		public function step9() : void{
			TaskEditOverlayHelper.instance.insertTaskName("task");
			TaskEditOverlayHelper.instance.insertTaskDescription("description");
			TaskEditOverlayHelper.instance.insertTaskPriority(TaskEditOverlayHelper.LOW_PRIORITY);
			assertFalse(AssertMessage.TASK_NAME_ERROR_FIELD,TaskEditOverlayHelper.instance.errorTaskName());
			assertFalse(AssertMessage.TASK_DESCRIPTION_ERROR_FIELD,TaskEditOverlayHelper.instance.errorDescription());
			step10();
		}
		
		//Save button.
		public function step10() : void{
			TaskEditOverlayHelper.save();
			assertTrue(AssertMessage.ALERT_IS_POPUP,AlertHelper.isPopUp());
			assertTrue(AssertMessage.ALERT_REQUIRED_FIELDS,AlertHelper.validMessage());
			step11();
		}
		
		//OK button of the alert message.
		public function step11() : void{
			AlertHelper.closePopUp();
			//assertFalse(AssertMessage.ALERT_IS_NOT_POPUP,AlertHelper.isPopUp());
			//assertTrue(AssertMessage.TAB_ASSIGNEE_VISIBLE,TaskEditOverlayHelper.tabAssignesIsVisible());
			step12();
		}
		
		//In the Assegnees picklist choose an assegnee
		public function step12() : void{
			listenForEvent(TaskEditOverlayHelper.instance,ListEvent.CHANGE,EVENT_EXPECTED);
			TaskEditOverlayHelper.instance.selectAssignee();
			assertEvents(AssertMessage.ITEM_NO_SELECTED);
			step13();
		}
		
		//Save button.
		public function step13() : void{
			TaskEditOverlayHelper.save();
			TaskHelper.instance.addEventListener(Event.COMPLETE,addAsync(verify,10000,null,fault));
		}
		
		public function verify(object : Object) : void{
			var taskCreatedAbove : UiTask = TaskHelper.instance.task;
			
			//The task is created above the selected task in step 1.
			assertTrue(taskCreated.position == taskCreatedAbove.position+1);	
		}
		
		public function fault(object : Object = null) : void{
			fail(AssertMessage.TASK_NOT_CREATED);
		}
		
	}
}