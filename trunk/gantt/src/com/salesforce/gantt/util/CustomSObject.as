package com.salesforce.gantt.util
{
	import com.salesforce.objects.SObject;

	/**
	 * Class responsible to encapsulate the namespaces added to the attributes
	 * when they are added to the object to be sent to server.
	 * 
	 * @author Rodrigo Birriel
	 */ 
	public dynamic class CustomSObject extends SObject
	{
		/**
		 * Constructor
		 * Add the namespace to the param object if it is necessary.
		 */
		public function CustomSObject(object : Object = null){
			if(object is String){
				object = SNSUtil.addNamespace(object as String);
			}
			if(object is Array){
				for each( var key : String in object){
					setProperty(key,object[key]);
				}
			}
			super(object);
		}
		
		/**
		 * Given a property to be added to this instance,
		 * the corresponding namespace to the key is added.
		 * 
		 * @param key
		 * @param value
		 */ 
		public function setProperty(key : String, value : Object) : void{
			var NSkey : String = SNSUtil.addNamespace(key);
			this[NSkey] = value;
		}
		
		/**
		 * Return the corresponding property related to the key.
		 * 
		 * @param key
		 * @return Object
		 */ 
		public function getProperty(key : String) : *{
			var NSkey : String = SNSUtil.addNamespace(key);
			return this[NSkey];
		}
		
	}
}