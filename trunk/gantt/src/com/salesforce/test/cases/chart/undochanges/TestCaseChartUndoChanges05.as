package com.salesforce.test.cases.chart.undochanges
{
	import com.salesforce.gantt.model.UiTask;
	import com.salesforce.test.AssertMessage;
	import com.salesforce.test.cases.BaseTestCase;
	import com.salesforce.test.helper.BarControlHelper;
	import com.salesforce.test.helper.GridHelper;
	import com.salesforce.test.util.TaskHelper;
	
	import flash.events.Event;
	
	import mx.events.ListEvent;
	
	/**
	 *	Test Case : Undo the deletion of a task.
	 * 
	 *  @author Rodrigo Birriel - August 07, 2009
	*/
	
	public class TestCaseChartUndoChanges05 extends BaseTestCase
	{
		private var taskCreated : UiTask;
		
		public function TestCaseChartUndoChanges05() 
		{
		}
		
		public function test2Execute(): void{
			//FIXME
			//moved from setUp because of not supportting addAsyn method in this
			//print error : TypeError: Error #1006: value is not a function.
			TaskHelper.instance.createTask();
			TaskHelper.instance.addEventListener(Event.COMPLETE,addAsync(step1,10000,null,faultCreated));
			//to here
		}

		//Delete a task.
		private function step1(object : Object) : void{
			
			taskCreated = TaskHelper.instance.task;
			
			listenForEvent(GridHelper.instance,ListEvent.ITEM_CLICK,EVENT_EXPECTED);
			GridHelper.instance.selectRowNewTaskCreated();
			assertEvents(AssertMessage.ROW_NO_SELECTED);
			
			//Click delete
			BarControlHelper.instance.clickDelete();
			
			//Confirms delete
			BarControlHelper.instance.confirmDelete();
			
			TaskHelper.instance.addEventListener(Event.COMPLETE,addAsync(step2,10000,null,faultUndo));
			
		}
		
		//Click on: - Undo button
		private function step2(object :Object) : void{
			BarControlHelper.instance.clickUndo();
			TaskHelper.instance.addEventListener(Event.COMPLETE,addAsync(verify,10000,null,faultUndo));
		}
		
		private function verify(object : Object) : void{
			var taskAfterUndo : UiTask = TaskHelper.instance.getTaskById(taskCreated.id);
			var taskEquals : Boolean = TaskHelper.instance.equals(taskCreated,taskAfterUndo);
			assertTrue(AssertMessage.TASKS_NOT_EQUALS,taskEquals);
		}
		
		private function faultCreated() : void{
			fail(AssertMessage.TASK_NOT_CREATED);
		}
		
		private function faultUndo() : void{
			fail(AssertMessage.TASK_NOT_UPDATED);
		}

	}
}