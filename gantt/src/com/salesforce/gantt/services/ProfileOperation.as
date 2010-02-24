package com.salesforce.gantt.services
{
	
	import com.salesforce.*;
	import com.salesforce.events.*;
	import com.salesforce.objects.*;
	import com.salesforce.results.*;
	
	import mx.rpc.IResponder;
	import mx.rpc.events.*;
	import mx.rpc.soap.*;
	import mx.rpc.wsdl.*;
	
	public class ProfileOperation extends BaseOperation{
		
		public function ProfileOperation() : void{
		}
		
		public function load(ar : IResponder) : void{
			var query : String = "select Id,Name,ManageProjectTasks__c,CreateProjectTasks__c from ProjectProfile__c";
			connection.query(query,ar);
		}
	}
}