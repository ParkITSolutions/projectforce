package com.salesforce.test.cases.chart.redochanges
{
	import com.salesforce.gantt.model.UiTask;
	import com.salesforce.test.AssertMessage;
	import com.salesforce.test.cases.BaseTestCase;
	import com.salesforce.test.helper.BarControlHelper;
	import com.salesforce.test.helper.GridHelper;
	import com.salesforce.test.helper.TaskEditOverlayHelper;
	import com.salesforce.test.util.TaskHelper;
	
	import flash.events.Event;
	
	import mx.events.ListEvent;
	
	/**
	 *	Test Case : Redo the update of a task.
	 * 
	 *  @author Rodrigo Birriel - August 11, 2009
	*/
	
	public class TestCaseChartRedoChanges03 extends BaseTestCase
	{
		private var taskCreated : UiTask;
		private var taskUpdated : UiTask;
		public function TestCaseChartRedoChanges03() 
		{
		}
		
		public function test2Execute(): void{
			//FIXME
			//moved from setUp because of not supportting addAsyn method in this
			//print error : TypeError: Error #1006: value is not a function.
			TaskHelper.instance.createTask();
			TaskHelper.instance.addEventListener(Event.COMPLETE,addAsync(previous1,10000,null,faultCreated));
			//to here
		}

		//Update a task.
		private function previous1(object : Object) : void{
			
			taskCreated = TaskHelper.instance.task;
			
			listenForEvent(GridHelper.instance,ListEvent.ITEM_CLICK,EVENT_EXPECTED);
			GridHelper.instance.selectRowNewTaskCreated();
			assertEvents(AssertMessage.ROW_NO_SELECTED);
			
			//Edit the selected task
			BarControlHelper.instance.clickEdit();
			
			//Modify the completion
			TaskEditOverlayHelper.instance.insertTaskCompleted("5 %");
			
			//Save the task
			TaskEditOverlayHelper.save();
			
			TaskHelper.instance.addEventListener(Event.COMPLETE,addAsync(previous2,10000,null,faultUndo));
			
		}
		
		//Click on: - Undo button
		private function previous2(object :Object) : void{
			taskUpdated = TaskHelper.instance.task;
			BarControlHelper.instance.clickUndo();
			TaskHelper.instance.addEventListener(Event.COMPLETE,addAsync(step1,10000,null,faultUndo));
		}
		
		private function step1(object : Object) : void{
			BarControlHelper.instance.clickRedo();
			TaskHelper.instance.addEventListener(Event.COMPLETE,addAsync(verify,10000,null,faultRedo));
		}
		
		private function verify(object : Object) : void{
			var taskAfterRedo : UiTask = TaskHelper.instance.getTaskById(taskUpdated.id);
			assertEquals(AssertMessage.TASK_COMPLETED_CHANGED,taskUpdated.completed,taskAfterRedo.completed);
		}
		
		private function faultRedo(object : Object) : void{
			fail(AssertMessage.TASK_NOT_UPDATED);
		}
		
		private function faultCreated(object : Object) : void{
			fail(AssertMessage.TASK_NOT_CREATED);
		}
		
		private function faultUndo(object : Object) : void{
			fail(AssertMessage.TASK_NOT_UPDATED);
		}

	}
}