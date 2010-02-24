package com.salesforce.test.cases.chart.undochanges
{
	import com.salesforce.gantt.model.UiTask;
	import com.salesforce.test.AssertMessage;
	import com.salesforce.test.cases.BaseTestCase;
	import com.salesforce.test.helper.BarControlHelper;
	import com.salesforce.test.helper.GridHelper;
	import com.salesforce.test.util.TaskHelper;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.events.ListEvent;
	
	/**
	 *	Test Case : Undo the creation of a ParentTask.
	 * 
	 *  @author Rodrigo Birriel - Setember 15, 2009
	*/
	
	public class TestCaseChartUndoChanges07 extends BaseTestCase
	{
		private var taskAbove: UiTask;
		private var taskBelow: UiTask;
		
		public function TestCaseChartUndoChanges07() 
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
		
		private function previous1(object : Object) : void{
			taskAbove = TaskHelper.instance.task;
			TaskHelper.instance.createTask();
			TaskHelper.instance.addEventListener(Event.COMPLETE,addAsync(step1,10000,null,faultCreated));
		}

		//Delete a task.
		private function step1(object : Object) : void{
			listenForEvent(GridHelper.instance,ListEvent.ITEM_CLICK,EVENT_EXPECTED);
			GridHelper.instance.selectRowNewTaskCreated();
			assertEvents(AssertMessage.ROW_NO_SELECTED);
			
			//Click Indent
			listenForEvent(BarControlHelper.instance,MouseEvent.CLICK,EVENT_EXPECTED);
			BarControlHelper.instance.clickIndent();
			assertEvents(AssertMessage.CLICK_NOT_OCCURED);
			
			TaskHelper.instance.addEventListener(Event.COMPLETE,addAsync(step2,10000,null,faultUndo));
			
		}
		
		//Click on: - Undo button
		private function step2(object :Object) : void{
			listenForEvent(BarControlHelper.instance,MouseEvent.CLICK,EVENT_EXPECTED);
			BarControlHelper.instance.clickUndo();
			assertEvents(AssertMessage.CLICK_NOT_OCCURED);
			
			TaskHelper.instance.addEventListener(Event.COMPLETE,addAsync(verify,10000,null,faultUndo));
		}
		
		private function verify(object : Object) : void{
			var taskBelowAfterIndent : UiTask = TaskHelper.instance.task;
			var taskAboveAfterIndent : UiTask = TaskHelper.instance.getTaskById(taskAbove.id);
			var areFamily : Boolean = taskAboveAfterIndent.heriarchy.isAncestor(taskAboveAfterIndent,taskBelowAfterIndent);	
			assertFalse(AssertMessage.TASK_WITH_HIERARCHY,areFamily);
		}
		
		private function faultCreated() : void{
			fail(AssertMessage.TASK_NOT_CREATED);
		}
		
		private function faultUndo() : void{
			fail(AssertMessage.TASK_NOT_UPDATED);
		}

	}
}