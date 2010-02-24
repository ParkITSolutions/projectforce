package com.salesforce.gantt.model
{
	[RemoteClass(alias="com.salesforce.gantt.model.TaskResource")]
	public class TaskResource
	{
		public var id : String;
		public var resource : Resource;
		public var dedicated : int;
		
		/*
		 * Costructor
		 */		
		public function TaskResource(id : String = '', resource : Resource = null, dedicated : int = 0)
		{
			this.id = id;
			this.resource = resource;
			//this.resource = new Resource('dummyResource');
			this.dedicated = dedicated;
		}
		/*
		 * toString()
		 */
		public function toString() : String
		{
			return this.resource.name;
		}
		public function clone() : TaskResource 
		{
			var taskResource : TaskResource = new TaskResource();
			taskResource.id				= id;
	    	taskResource.resource		= resource;
	    	taskResource.dedicated		= dedicated;
	    	return taskResource;
		}
	}
}