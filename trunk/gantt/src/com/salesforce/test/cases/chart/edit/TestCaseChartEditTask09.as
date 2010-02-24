package com.salesforce.test.cases.chart.edit
{
	import com.salesforce.gantt.model.Dependency;
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
	 *	Test Case : Edit a task with Edit button, and delete a dependency.
	 * 
	 *  @author Rodrigo Birriel - August 06, 2009
	*/
	public class TestCaseChartEditTask09 extends BaseTestCase
	{
		private var task : UiTask;
		private var taskWithDependency : UiTask;
		
		public function TestCaseChartCreateTask9()
		{
		}
		
		public function test2execute() : void{
			previousCreateTask1()
		}
		
		private function previousCreateTask1() : void{
			TaskHelper.instance.createTask();
			TaskHelper.instance.addEventListener(Event.COMPLETE,addAsync(previousCreateTask2,20000));
		}
		
		private function previousCreateTask2(object :Object) : void{
			task = TaskHelper.instance.task;
			TaskHelper.instance.createTask();
			TaskHelper.instance.addEventListener(Event.COMPLETE,addAsync(previousAddDependency,20000));
		}
		
		private function previousAddDependency(object : Object) : void{
			taskWithDependency = TaskHelper.instance.task;
			var dependency : Dependency = new Dependency(task);
			TaskHelper.instance.createDependency(dependency,taskWithDependency);
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
		
		//Click on Delete link next to the dependency.
		private function step4() : void{
			TaskEditOverlayHelper.instance.clickDeleteDependency();
			step5();
		}
		
		//Click on: - Save button.
		private function step5() : void{
			TaskEditOverlayHelper.save();
			TaskHelper.instance.addEventListener(Event.COMPLETE,addAsync(verify,10000,null,fault));
		}
		
		private function verify(object : Object) : void{
			taskWithDependency = TaskHelper.instance.task;
			assertEquals(AssertMessage.TASK_WITH_DEPENDENCIES,taskWithDependency.dependencies.length,0)
		}
		
		private function fault() : void{
			fail(AssertMessage.TASK_NOT_CREATED);
		}
		
	}
}