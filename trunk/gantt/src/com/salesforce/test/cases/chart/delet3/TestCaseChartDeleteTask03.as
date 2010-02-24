package com.salesforce.test.cases.chart.delet3
{
	import com.salesforce.test.AssertMessage;
	import com.salesforce.test.helper.BarControlHelper;
	import com.salesforce.test.helper.GridHelper;
	import com.salesforce.test.util.TaskHelper;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	
	import flexunit.framework.EventfulTestCase;
	
	import mx.events.ListEvent;

	public class TestCaseChartDeleteTask03 extends EventfulTestCase
	{
		public function TestCaseChartDeleteTask03(methodName:String=null)
		{
			super(methodName);
		}

		public function testMainExecute():void{
			TaskHelper.instance.createTask();
			TaskHelper.instance.addEventListener(Event.COMPLETE, addAsync(steps, 10000, null, fault));
		}
		
		private function steps(obj:Object):void{
			step1();
			step2();
			step3();

			ExternalInterface.call("console.info", "3-OK!!");
		}
		
		//Click on the task
		private function step1():void{
			listenForEvent(GridHelper.instance, ListEvent.ITEM_CLICK, EVENT_EXPECTED);
			var rowTask : int = GridHelper.instance.getRowTaskCreated();
			GridHelper.instance.clickRow(rowTask);
			assertEvents(AssertMessage.ROW_NO_SELECTED);
			
		}
		
		//Click on Delete button.
		private function step2():void{
			listenForEvent(BarControlHelper.instance, MouseEvent.CLICK, EVENT_EXPECTED);
			BarControlHelper.instance.clickDelete();
			
			assertEvents(AssertMessage.CLICK_NOT_OCCURED);
			assertTrue(AssertMessage.OVERLAY_NO_VISIBLE, BarControlHelper.instance.overlayDeleteIsVisible());
		}
		
		//Click on Conntinue and Delete button.
		private function step3():void{
			listenForEvent(BarControlHelper.instance, MouseEvent.CLICK, EVENT_EXPECTED);
			BarControlHelper.instance.confirmDelete();
			
			assertEvents(AssertMessage.CLICK_NOT_OCCURED);
		}
		
		private function fault():void{
			
		}
		
	}
}