package com.salesforce.gantt.model
{
	[Bindable]
	[RemoteClass(alias="com.salesforce.gantt.model.User")]
	public class User
	{
		public var id : String = '';
		public var name : String = '';
		public var idAuthenticate : String = '';
		public var email : String ;
		public var password : String ;
		public var firstName : String;
		public var lastName : String;
		public var title : String;
		public var companyName : String;
				
		function User(id : String = '',name : String = '')
		{
			if(id != '')
			{
				this.id = id;
			}
			this.name = name;
		}
		
		public function toString():String{
			return name;
		}
		
	}
}