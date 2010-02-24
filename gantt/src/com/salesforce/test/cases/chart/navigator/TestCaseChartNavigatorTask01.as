package com.salesforce.test.cases.chart.navigator
{
	import com.salesforce.test.AssertMessage;
	import com.salesforce.test.helper.ChartHelper;
	
	import flexunit.framework.EventfulTestCase;
	

	public class TestCaseChartNavigatorTask01 extends EventfulTestCase
	{
		public function TestCaseChartNavigatorTask01(methodName:String=null)
		{
			super(methodName);
		}

		public function testMainExecute():void{
			ChartHelper.instance.clickToggleViewNavigator();
			assertTrue(AssertMessage.NAVIGATOR_IS_VISIBLE, ChartHelper.instance.barChartOverviewIsVisible());
		}
		
	}
}
