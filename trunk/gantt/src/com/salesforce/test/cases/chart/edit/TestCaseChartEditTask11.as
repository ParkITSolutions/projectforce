package com.salesforce.test.cases.chart.edit
{
	import com.salesforce.gantt.model.UiTask;
	import com.salesforce.test.AssertMessage;
	import com.salesforce.test.cases.BaseTestCase;
	import com.salesforce.test.helper.BarControlHelper;
	import com.salesforce.test.helper.GridHelper;
	import com.salesforce.test.helper.TaskEditOverlayHelper;
	import com.salesforce.test.util.TaskHelper;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.events.ListEvent;
	
		
	
	/**
	 *	Test Case : Edit a task with Edit button, and delete assignees .
	 * 
	 *  @author Rodrigo Birriel - August 12, 2009
	*/
	public class TestCaseChartEditTask11 extends BaseTestCase
	{
		private var task : UiTask;
		private var taskWithResource : UiTask;
		
		public function TestCaseChartCreateTask11()
		{
		}
		
		public function test2execute() : void{
			previous1()
		}
		
		private function previous1() : void{
			TaskHelper.instance.createTask();
			TaskHelper.instance.addEventListener(Event.COMPLETE,addAsync(previous2,20000));
		}
		
		private function previous2(object : Object) : void{
			taskWithResource = TaskHelper.instance.task;
			TaskHelper.instance.createTaskResource(taskWithResource);
			TaskHelper.instance.addEventListener(Event.COMPLETE,addAsync(step1,10000));
		}
		
		private function step1(object : Object) : void{
			listenForEvent(GridHelper.instance,ListEvent.ITEM_CLICK,EVENT_EXPECTED);
			GridHelper.instance.selectRowNewTaskCreated();
			assertEvents(AssertMessage.ROW_NO_SELECTED);
			step2();
		}
		
		//Click on: - “Edit” button.
		private function step2() : void{
			listenForEvent(BarControlHelper.instance,MouseEvent.CLICK,EVENT_EXPECTED);
			BarControlHelper.instance.clickEdit();
			assertEvents(AssertMessage.CLICK_NOT_OCCURED);
			assertTrue(AssertMessage.OVERLAY_NO_VISIBLE,TaskEditOverlayHelper.instance.isVisible());
			step3();
		}
		
		//Fields: - Go to the Task Links tab.
		private function step3() : void{
			TaskEditOverlayHelper.instance.clickDependecyTab();
			step4();
		}
		
		//Click on the red icon next to the assignee you want to delete.
		private function step4() : void{
			TaskEditOverlayHelper.instance.clickDeleteAssignee();
			step5();
		}
		
		//Click on: - Save button.
		private function step5() : void{
			TaskEditOverlayHelper.save();
			TaskHelper.instance.addEventListener(Event.COMPLETE,addAsync(verify,10000,null,fault));
		}
		
		private function verify(object : Object) : void{
			taskWithResource = TaskHelper.instance.task;
			assertEquals(AssertMessage.TASK_RESOURCES_CHANGED,taskWithResource.taskResources.length,task.taskResources.length);
		}
		
		private function fault() : void{
			fail(AssertMessage.TASK_NOT_CREATED);
		}
		
	}
}