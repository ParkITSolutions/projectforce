package com.salesforce.test.cases.chart.redochanges
{
	import com.salesforce.gantt.model.UiTask;
	import com.salesforce.test.AssertMessage;
	import com.salesforce.test.cases.BaseTestCase;
	import com.salesforce.test.helper.BarControlHelper;
	import com.salesforce.test.helper.TaskEditOverlayHelper;
	import com.salesforce.test.util.TaskHelper;
	
	import flash.events.Event;
	
	import mx.events.ListEvent;
	
	/**
	 *	Test Case : Undo the creation of a milestone.
	 * 
	 *  @author Rodrigo Birriel - August 11, 2009
	*/
	
	public class TestCaseChartRedoChanges02 extends BaseTestCase
	{
		private var taskCreated : UiTask;
		
		public function TestCaseChartRedoChanges02() 
		{
		}
		
		public function test2Execute(): void{
			previous1();
		}

		//Create a milestone.
		private function previous1() : void{
			
			//Click on: - “New” button. - Choose “Insert Task Above” option.
			listenForEvent(BarControlHelper.instance,ListEvent.CHANGE,EVENT_EXPECTED);
			BarControlHelper.instance.clickInsertTask(BarControlHelper.ABOVE);
			assertEvents(AssertMessage.ROW_NO_SELECTED);
			assertTrue(AssertMessage.OVERLAY_NO_VISIBLE,TaskEditOverlayHelper.instance.isVisible());
		
			//Fill the Task Name field.
			//Fill the Description field.
			TaskEditOverlayHelper.instance.insertTaskName("task_1");
			TaskEditOverlayHelper.instance.insertTaskDescription("Description_1");
			assertFalse(AssertMessage.TASK_NAME_ERROR_FIELD,TaskEditOverlayHelper.instance.errorTaskName());
			assertFalse(AssertMessage.TASK_DESCRIPTION_ERROR_FIELD,TaskEditOverlayHelper.instance.errorDescription());
			
			//Fields: - Checkout Is Milestone? Field.
			TaskEditOverlayHelper.instance.convertToMilestone();
			
			//Click Assignee Tab
			TaskEditOverlayHelper.instance.clickAssigneesTab();
			
			//Add Assigne
			TaskEditOverlayHelper.instance.addAssignee();
			 
			//Select Assignee
			TaskEditOverlayHelper.instance.selectAssignee();
			
			//Click on: - Save button.
			TaskEditOverlayHelper.save();
			
			TaskHelper.instance.addEventListener(Event.COMPLETE,addAsync(previous2,10000,null,faultCreated));
		}
		
		//Click on: - Undo button
		private function previous2(object : Object) : void{
			taskCreated = TaskHelper.instance.task;
			BarControlHelper.instance.clickUndo();
			TaskHelper.instance.addEventListener(Event.COMPLETE,addAsync(step1,10000,null,faultUndo));
		}
		
		private function step1(object : Object) : void{
			BarControlHelper.instance.clickRedo();
			TaskHelper.instance.addEventListener(Event.COMPLETE,addAsync(verify,10000,null,faultRedo));	
		}
		
		private function verify(object : Object) : void{
			var taskAfterRedo : UiTask = TaskHelper.instance.getTaskById(taskCreated.id);
			assertNotNull(AssertMessage.TASK_NOT_CREATED,taskAfterRedo);
		}
		
		private function faultUndo(object : Object) : void{
			fail(AssertMessage.TASK_NOT_DELETED);
		}
		
		private function faultCreated(object :Object) : void{
			fail(AssertMessage.TASK_NOT_CREATED);
		}
		
		private function faultRedo(object : Object) : void{
			fail(AssertMessage.TASK_NOT_CREATED);
		}

	}
}