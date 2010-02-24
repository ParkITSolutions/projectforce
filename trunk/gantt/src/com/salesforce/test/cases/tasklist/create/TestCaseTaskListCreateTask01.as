package com.salesforce.test.cases.tasklist.create
{
	import com.salesforce.gantt.controller.Components;
	import com.salesforce.gantt.model.Calendar;
	import com.salesforce.gantt.model.Task;
	import com.salesforce.gantt.model.UiTask;
	import com.salesforce.test.AssertMessage;
	import com.salesforce.test.helper.GridHelper;
	import com.salesforce.test.util.TaskHelper;
	
	import flash.events.Event;
	import flash.events.FocusEvent;
	
	import flexunit.framework.EventfulTestCase;
	
	/**
	 *	Test Case : 
	 * 
	 *  @author Rodrigo Birriel - July 31, 2009
	*/
	public class TestCaseTaskListCreateTask01 extends EventfulTestCase
	{
		public function TestCaseTaskListCreateTask01(methodName:String=null)
		{
			super(methodName);
		}
		
		override public function setUp():void{
			
		}
		
		public function test2Execute() : void{
			step1();
		}
		
		//Click on the Task Name cell.
		private function step1() : void{
			listenForEvent(GridHelper.instance,FocusEvent.FOCUS_IN,EVENT_EXPECTED);
			GridHelper.instance.selectedCellToNewTask();
			assertEvents(AssertMessage.CELL_NOT_SELECTED);
			step2();
		}
		
		//Type the name of the task.
		private function step2() : void{
			GridHelper.instance.insertText("task_1");
			assertEquals(AssertMessage.TEXT_NOT_TYPED,GridHelper.instance.getText(),"task_1");
			step3();
		}
		
		//Press enter key.
		private function step3() : void{
			//listenForEvent(GridHelper.instance,KeyboardEvent.KEY_DOWN,EVENT_EXPECTED);
			GridHelper.instance.saveEditionEnterKey();
			
			//verify that the action was completed
			TaskHelper.instance.addEventListener(Event.COMPLETE,addAsync(verifyTask,10000,null,fault));
		}
		
		private function verifyTask(object : Object = null) : void{
			var task : UiTask = TaskHelper.instance.task;
			assertTrue(AssertMessage.TASK_NOT_CREATED,task.id!="");
			assertTrue("The task duration is 1.",task.duration==(!Components.instance.project.durationInHours?1:Components.instance.project.hoursPerDay));
			var startDueDatesEqualsToday : Boolean = Calendar.equals(task.startDate,task.endDate) && Calendar.equals(task.startDate,new Date());
			assertTrue("The Start and Due date are today's day.",startDueDatesEqualsToday);
			assertTrue("The % Complete is 0.",task.completed==0);
		}
		
		private function fault():void{
			fail(AssertMessage.TASK_NOT_CREATED);
		}
		
	}
}