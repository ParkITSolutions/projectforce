package com.salesforce.test.cases.tasklist.delet3
{
	import com.salesforce.test.*;
	import com.salesforce.test.helper.BarControlHelper;
	import com.salesforce.test.helper.GridHelper;
	import com.salesforce.test.util.TaskHelper;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import flexunit.framework.EventfulTestCase;
	
	import mx.events.ListEvent;

	
	/**
	 *	Test Case : Cancel the deletion of the task.
	 * 
	 *  @author Rodrigo Birriel - July 31, 2009
	*/
	public class TestCaseTaskListDeleteTask01 extends EventfulTestCase
	{
		public function TestCaseTaskListDeleteTask01()
		{
			super();
		}
		
		public function test2execute():void{
			TaskHelper.instance.createTask();
			TaskHelper.instance.addEventListener(Event.COMPLETE,addAsync(step1,10000,null,fault));
		}
		
		//Select the row that contains the task you want to delete.
		public  function step1(object : Object) : void{
			listenForEvent(GridHelper.instance,ListEvent.ITEM_CLICK,EVENT_EXPECTED);
			var rowTask : int = GridHelper.instance.getRowTaskCreated();
			GridHelper.instance.clickRow(rowTask);
			assertEvents(AssertMessage.ROW_NO_SELECTED);
			step2();
		}
		
		//Click on Delete button.
		public function step2() : void{
			listenForEvent(BarControlHelper.instance,MouseEvent.CLICK,EVENT_EXPECTED);
			BarControlHelper.instance.clickDelete();
			assertEvents(AssertMessage.CLICK_NOT_OCCURED);
			assertTrue(AssertMessage.OVERLAY_NO_VISIBLE,BarControlHelper.instance.overlayDeleteIsVisible());
			step3();
		}
		
		//Click on Cancel button.
		public function step3(): void{
			listenForEvent(BarControlHelper.instance,MouseEvent.CLICK,EVENT_EXPECTED);
			BarControlHelper.instance.cancelDelete();
			assertEvents(AssertMessage.CLICK_NOT_OCCURED);
			verify();
		}
		
		public function verify(): void{
		}
		
		public function fault(): void{
			fail(AssertMessage.TASK_NOT_CREATED);
		}
		
	}
}