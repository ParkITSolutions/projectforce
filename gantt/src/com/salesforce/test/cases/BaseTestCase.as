package com.salesforce.test.cases
{
	import com.salesforce.test.util.TaskHelper;
	
	import flexunit.framework.EventfulTestCase;
	
	public class BaseTestCase extends EventfulTestCase
	{
		protected var seleniumFlexApi  : SeleniumFlexAPI = new SeleniumFlexAPI();
		public function BaseTestCase(methodName:String=null)
		{
			super(methodName);
		}
		
		public override function tearDown():void{
			TaskHelper.instance.deleteTask(true);
		}

	}
}