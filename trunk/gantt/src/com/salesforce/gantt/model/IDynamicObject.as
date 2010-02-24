package com.salesforce.gantt.model
{
	/**
	 * Interface used by classes which contain a properties map.
	 * 
	 * @author Rodrigo Birriel
	 */
	public interface IDynamicObject
	{
		/** given a key returns a value */
		function property(key : String) : Object;
		
		/** returns the type SObject type*/
		function get stype() : String;
	}
}