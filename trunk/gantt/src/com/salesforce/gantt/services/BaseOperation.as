package com.salesforce.gantt.services
{
	import com.salesforce.Connection;
	import com.salesforce.gantt.util.ConnectionUtil;
	
	/**
	 * Class responsible to keep the connection Class to communicate
	 * with Salesforce
	 * 
	 * @author Rodrigo Birriel
	 */
	public class BaseOperation{
		
		protected var connection : Connection = ConnectionUtil.instance.connection;;
		
		public function BaseOperation(){
		}

	}
}