package com.salesforce.gantt.util
{
	import mx.core.Application;
	
	/**
	 * Class used to add to a the namespace to a string.
	 * Example : namespace is Foo and the query is "select property1,property2__c,Foo__property3__c from table"
	 * the query modified would be "select property1,Foo__property2__c,Foo__property3__c from table".
	 * 
	 * @author Rodrigo Birriel.
	 */
	public class SNSUtil
	{
		private static var pattern : RegExp = /(\w*__[cr])/g;
		
		/**
		 * Given an string added the
		 */ 
		public static function addNamespace(query : String) : String{
			var queryReplaced : String = query.replace(pattern,nameSpace+"$1");
			return queryReplaced;			
		}
		
		public static function get nameSpace() : String{
			var nameSpaceParam : String = Application.application.parameters.namespace;
			if(nameSpaceParam != null && nameSpaceParam != ''){
				nameSpaceParam +="__";
			}else{
				return '';
			}
			return nameSpaceParam;
		}

	}
}