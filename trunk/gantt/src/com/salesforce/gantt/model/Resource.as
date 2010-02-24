package com.salesforce.gantt.model
{
	import com.salesforce.gantt.controller.Components;
	
	[Bindable]
	[RemoteClass(alias="com.salesforce.gantt.model.Resource")]
	public class Resource{
		
		public var id : String;
		public var name : String;
		public var user : User;
		public var createdDate : Date;
		public var isProjectOwner : Boolean;
		public var profile : Profile;
		
		/**
		 * Costructor
		 */	
		public function Resource(name : String = '', id : String = '', user : User = null, profile : Profile = null){
			this.id = id;
			this.name = name;
			this.user = user?user:new User();
			this.profile = new Profile();
			this.isProjectOwner = false;
			
		}
		
		public function canModifyTask(task : Task) : Boolean {
			var canModify : Boolean = false;
			if(task){
				canModify = profile.canManage || task.hasResourceID(id) || task.createdBy.id == user.id;	
			}
			return canModify;
		}
		
		public function canDeleteTask(task : Task) :Boolean{
			var canIDelete : Boolean = false;
			if(task){
				canIDelete = profile.canManage || task.createdBy.id == user.id;	
			}
			return canIDelete;	
		}
		
		public function get canCreate() : Boolean{
			return profile.canCreate;
		}
		
		public function get canManage() : Boolean{
			return profile.canManage;
		}
		
		public function toString() : String{
			return this.name ;
		}		
		
	}
}