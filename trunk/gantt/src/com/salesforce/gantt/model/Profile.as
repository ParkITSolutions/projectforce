package com.salesforce.gantt.model
{
	/**
	 * Class responsible to contain the necessaries permissions
	 * for each profile
	 * 
	 * @author Rodrigo Birriel
	 */ 
	
	[Bindable]
	[RemoteClass(alias="com.salesforce.gantt.model.Profile")]
	public class Profile{
		
		public var id : String;
		public var name : String;
		public var canCreate : Boolean;
		public var canManage : Boolean;
		
		public function Profile(id: String = '', name : String ='',canCreate : Boolean = false, canManage : Boolean = false){
			
			this.name = name;
			this.id = id;
			this.canCreate = false;
			this.canManage = false
		}
	}
}