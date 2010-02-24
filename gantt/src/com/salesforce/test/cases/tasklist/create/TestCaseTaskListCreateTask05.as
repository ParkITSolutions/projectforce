 	package com.salesforce.test.cases.tasklist.create
{
	import com.salesforce.gantt.model.UiTask;
	import com.salesforce.test.AssertMessage;
	import com.salesforce.test.helper.BarControlHelper;
	import com.salesforce.test.helper.GridHelper;
	import com.salesforce.test.helper.TaskEditOverlayHelper;
	import com.salesforce.test.util.TaskHelper;
	
	import flash.events.Event;
	
	import flexunit.framework.EventfulTestCase;
	
	import mx.events.ListEvent;
	
	public class TestCaseTaskListCreateTask05 extends EventfulTestCase
	{
		
		var previousTaskCreated : UiTask;
		public function TestCaseTaskListCreateTask05(methodName:String=null)
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
			previousTaskCreated = TaskHelper.instance.task;
			listenForEvent(GridHelper.instance,ListEvent.ITEM_CLICK,EVENT_EXPECTED);
			var rowTask : int = GridHelper.instance.getRowTaskCreated();
			GridHelper.instance.clickRow(rowTask);
			assertEvents(AssertMessage.ROW_NO_SELECTED);
			step2();
		}
		
		//Click on: - “New” button. - Choose “Insert Task Below” option.
		public function step2() : void{
			BarControlHelper.instance.clickInsertTask(BarControlHelper.BELOW);
			assertTrue(AssertMessage.OVERLAY_NO_VISIBLE,TaskEditOverlayHelper.instance.isVisible());
			step3();
		}
		
		//Fill the Task Name field.
		//Fill the Description field. 
		//Choose “Low” option in Priority field.
		public function step3() : void{
			TaskEditOverlayHelper.instance.insertTaskName("task");
			TaskEditOverlayHelper.instance.insertTaskDescription("description");
			assertFalse(AssertMessage.TASK_NAME_ERROR_FIELD,TaskEditOverlayHelper.instance.errorTaskName());
			assertFalse(AssertMessage.TASK_DESCRIPTION_ERROR_FIELD,TaskEditOverlayHelper.instance.errorDescription());
			step4();
		}
		
		//Save button.
		public function step4() : void{
			TaskEditOverlayHelper.save();
			//assertTrue(AssertMessage.ALERT_IS_POPUP,AlertHelper.isPopUp());
			//assertTrue(AssertMessage.ALERT_REQUIRED_FIELDS,AlertHelper.validMessage());
			step5();
		}
		
		//In the Assegnees picklist choose an assegnee
		public function step5() : void{
			listenForEvent(TaskEditOverlayHelper.instance,Event.CHANGE,EVENT_EXPECTED);
			TaskEditOverlayHelper.instance.selectAssignee();
			assertEvents(AssertMessage.ITEM_NO_SELECTED);
			step6();
		}
		
		//Save button.
		public function step6() : void{
			TaskEditOverlayHelper.cancel();
			verify();
		}
		
		public function verify() : void{
			var task : UiTask =	TaskHelper.instance.task;
			assertTrue(AssertMessage.TASK_CREATED,task.id == previousTaskCreated.id);	
		}
		
		public function fault(object : Object = null) : void{
			fail(AssertMessage.TASK_NOT_CREATED);
		}

	}
}