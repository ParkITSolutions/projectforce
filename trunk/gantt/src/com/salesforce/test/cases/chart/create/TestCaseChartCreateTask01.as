package com.salesforce.test.cases.chart.create
{
	import com.salesforce.test.AssertMessage;
	import com.salesforce.test.cases.BaseTestCase;
	import com.salesforce.test.helper.BarControlHelper;
	import com.salesforce.test.helper.GridHelper;
	import com.salesforce.test.helper.TaskEditOverlayHelper;
	import com.salesforce.test.util.TaskHelper;
	
	import flash.events.Event;
	
	import mx.events.ListEvent;
	
		
	
	/**
	 *	Test Case : 
	 * 
	 *  @author Rodrigo Birriel - July 31, 2009
	*/
	public class TestCaseChartCreateTask01 extends BaseTestCase
	{
		public function TestCaseChartCreateTask01()
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
		
		//Click on the calendar icon.
		//Select a Due Date different than today's date.
		//NOT IMPLEMENTED
		private function step3() : void{
			TaskEditOverlayHelper.instance.selectStartDate("-1");
			step4();
		}
		
		//Click on the calendar icon.
		//Select a Due Date different than today's date.
		private function step4() : void{
			TaskEditOverlayHelper.instance.selectEndDate("+1");	
			step5();
		}
		
		//Fill the Task Name field.
		//Fill the Description field.
		private function step5() : void{
			TaskEditOverlayHelper.instance.insertTaskName("task_1");
			TaskEditOverlayHelper.instance.insertTaskDescription("Description_1");
			assertFalse(AssertMessage.TASK_NAME_ERROR_FIELD,TaskEditOverlayHelper.instance.errorTaskName());
			assertFalse(AssertMessage.TASK_DESCRIPTION_ERROR_FIELD,TaskEditOverlayHelper.instance.errorDescription());
			step6();
		}
		
		//Go to Task Links tab
		private function step6() : void{
			TaskEditOverlayHelper.instance.clickDependecyTab();
			assertTrue(AssertMessage.TAB_DEPENDENCY_NOT_VISIBLE,TaskEditOverlayHelper.tabDependencyIsVisible());
			step7();
		}
		
		//Click on : - Add New Dependecy link.
		//TODO to include in testcase
		private function step7() : void{
			TaskEditOverlayHelper.instance.addDependency();
			step8();
		}
		
		private function step8() : void{
			TaskEditOverlayHelper.instance.selectDependencyName();
			step9();
		}
		
		private function step9() : void{
			TaskEditOverlayHelper.instance.selectDependencyLag();
			step10();
		}
		
		private function step10() : void{
			TaskEditOverlayHelper.instance.selectDependencyType();
			TaskEditOverlayHelper.instance.selectDependencyUnit();
			step11();
		}
		
		// Go to Task Links tab
		private function step11() : void{
			TaskEditOverlayHelper.instance.clickAssigneesTab();
			assertTrue(AssertMessage.TAB_ASSIGNEES_NOT_VISIBLE,TaskEditOverlayHelper.tabAssignesIsVisible());
			step12();
		}
		
		// Click on : - Add New Task Link link.
		private function step12() : void{
			TaskEditOverlayHelper.instance.addAssignee();
			step13();
		}
		
		//In the Name column select the task you want to be associated with the task to create.
		private function step13() : void{
			listenForEvent(TaskEditOverlayHelper.instance,ListEvent.CHANGE,EVENT_EXPECTED);
			TaskEditOverlayHelper.instance.selectAssignee();
			assertEvents(AssertMessage.ROW_NO_SELECTED);
			step14();
		}
		
		private function step14() : void{
			TaskEditOverlayHelper.save();
			TaskHelper.instance.addEventListener(Event.COMPLETE,addAsync(verify,5000,null,fault));
		}
		
		private function verify(object : Object) : void{
			assertTrue(TaskHelper.instance.task!=null);
		}
		
		public function fault(object : Object) : void{
			fail(AssertMessage.TASK_NOT_CREATED);
		}
		
	}
}