package com.salesforce.gantt.controller
{
	import com.salesforce.gantt.model.Resource;
	
	import mx.collections.ArrayCollection;
	
	public interface IResources
	{
		function set resources(resources : ArrayCollection) : void;
		function get resources() : ArrayCollection;
		
		function addOrUpdate(resource : Resource) : void;
		function find(idResource : String) : Resource;
		function remove(resource : Resource): void;
		function removeAll() : void;
		function findByUser(userId : String) : Resource;
		function getAvailableResources() :ArrayCollection;
	}
}