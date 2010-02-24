package com.salesforce.test.cases.chart.navigator
{
	import com.salesforce.test.AssertMessage;
	import com.salesforce.test.helper.ChartHelper;
	
	import flexunit.framework.EventfulTestCase;
	

	public class TestCaseChartNavigatorTask02 extends EventfulTestCase
	{
		public function TestCaseChartNavigatorTask02(methodName:String=null)
		{
			super(methodName);
		}

		public function testMainExecute():void{
			ChartHelper.instance.clickToggleViewNavigator();
			assertTrue(AssertMessage.NAVIGATOR_NOT_IS_VISIBLE, !ChartHelper.instance.barChartOverviewIsVisible());
		}
		
	}
}