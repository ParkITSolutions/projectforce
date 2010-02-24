package com.salesforce.test.cases.chart.delet3
{
	import com.salesforce.test.AssertMessage;
	import com.salesforce.test.helper.BarControlHelper;
	import com.salesforce.test.helper.GridHelper;
	import com.salesforce.test.util.TaskHelper;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.external.ExternalInterface;
	import flash.ui.Keyboard;
	
	import flexunit.framework.EventfulTestCase;
	
	import mx.core.Application;
	import mx.events.ListEvent;
	

	public class TestCaseChartDeleteTask05 extends EventfulTestCase
	{
		
		public function TestCaseChartDeleteTask05(methodName:String=null)
		{
			super(methodName);
		}

		public function testMainExecute():void{
			TaskHelper.instance.createTask(true);
			TaskHelper.instance.addEventListener(Event.COMPLETE, addAsync(steps, 10000, null, fault));
		}
		
		private function steps(obj:Object):void{
			step1();
			step2();
			step3();
		}
		
		//Click on the task
		private function step1():void{
			listenForEvent(GridHelper.instance, ListEvent.ITEM_CLICK, EVENT_EXPECTED);
			var rowTask : int = GridHelper.instance.getRowTaskCreated();
			GridHelper.instance.clickRow(rowTask);
			assertEvents(AssertMessage.ROW_NO_SELECTED);
			
		}
		
		//Press Delete Key.
		private function step2():void{
			Application.application.mainView.barChart.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, true,false,0,Keyboard.DELETE));
		}
		
		//Press Enter Key. - Can not be automated
		private function step3():void{
			BarControlHelper.instance.confirmDelete();
		}
		
		private function fault():void{
			fail(AssertMessage.TASK_NOT_CREATED);
		}
		
	}
}