package com.salesforce.test.cases.chart.undochanges
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
	
	import mx.events.ListEvent;
	
	/**
	 *	Test Case : Undo the update of a milestone.
	 * 
	 *  @author Rodrigo Birriel - August 07, 2009
	*/
	
	public class TestCaseChartUndoChanges04 extends BaseTestCase
	{
		private var taskCreated : UiTask;
		
		public function TestCaseChartUndoChanges04() 
		{
		}
		
		public function test2Execute(): void{
			//FIXME
			//moved from setUp because of not supportting addAsyn method in this
			//print error : TypeError: Error #1006: value is not a function.
			TaskHelper.instance.createTask(true);
			TaskHelper.instance.addEventListener(Event.COMPLETE,addAsync(step1,10000,null,faultCreated));
			//to here
		}

		//Update a task.
		private function step1(object : Object) : void{
			
			taskCreated = TaskHelper.instance.task;
			
			listenForEvent(GridHelper.instance,ListEvent.ITEM_CLICK,EVENT_EXPECTED);
			GridHelper.instance.selectRowNewTaskCreated();
			assertEvents(AssertMessage.ROW_NO_SELECTED);
			
			//Edit the selected task
			BarControlHelper.instance.clickEdit();
			
			//Modify the start date
			TaskEditOverlayHelper.instance.selectStartDate("-1");
			
			//Save the task
			TaskEditOverlayHelper.save();
			
			TaskHelper.instance.addEventListener(Event.COMPLETE,addAsync(step2,10000,null,faultUndo));
			
		}
		
		//Click on: - Undo button
		private function step2(object :Object) : void{
			BarControlHelper.instance.clickUndo();
			TaskHelper.instance.addEventListener(Event.COMPLETE,addAsync(verify,10000,null,faultUndo));
		}
		
		private function verify(object : Object) : void{
			var taskAfterUndo : UiTask = TaskHelper.instance.getTaskById(taskCreated.id);
			var equalsDates : Boolean = Calendar.equals(taskCreated.startDate,taskAfterUndo.startDate);
			assertTrue(AssertMessage.DATES_NOT_EQUALS,equalsDates);
		}
		
		private function faultCreated() : void{
			fail(AssertMessage.TASK_NOT_CREATED);
		}
		
		private function faultUndo() : void{
			fail(AssertMessage.TASK_NOT_UPDATED);
		}

	}
}