package com.salesforce.gantt.controller
{
	import com.salesforce.gantt.model.Resource;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * Handler class responsible to manage the project's resources.
	 * 
	 * @author 	Rodrigo Birriel
	 */ 
	public class Resources implements IResources
	{
		[Bindable]
		public var resources : ArrayCollection = new ArrayCollection();
		
		/**
		 * Constructor
		 */
		public function Resources() : void{
		}
        
        /**
        * Add or update a resource to the resources's collection.
        * 
        * @param resouce:	the resource to be added or updated.
        */ 
        public function addOrUpdate(resource : Resource) : void{
        	var resourceLocal : Resource = find(resource.id);
			if(!resourceLocal){
				resources.addItem(resource);
			} else{
				resourceLocal = resource;
			}
        }
        
		/**
		 * Find a resource in the collection given an id.
		 * 
		 * @param 	resourceId the user id associated to a resource to find.
		 * @return 	Resource returns the resource searched by resourceId
		 * 					otherwise returns null.
		 */
		public function find(resourceId : String) : Resource
		{
			var resource : Resource = null;
	     	for(var j : int = 0; j < this.resources.length; j++)
	     	{
	     		resource = Resource(this.resources.getItemAt(j));
	     		if(resource.user.id == resourceId)
	     		{
	     			return resource;
	     		} 
	     		
	     	}
	     	return null;
	    }
	    
	    /**
	    * Given a resource, remove it from the resources's collection.
	    * 
	    * @param 	resource the instance to be deleted.
	    */
	    public function remove(resource : Resource) : void{
	    	var found : Boolean = false;
	    	var resourceTemp : Resource;
	    	for(var i : int = 0; !found && resources.length; i++){
	    		resourceTemp = Resource(resources.getItemAt(i));
	    		found = resourceTemp.id = resource.id;
	    		if(found){
	    			resources.removeItemAt(i);
	    		}
	    	}
	    }
	    
	    /**
	    * Clean the resources's collection.
	    */ 
	    public function removeAll() : void{
	    	resources.removeAll();
	    }
	    
	    /**
	    * Find a resource associated by user id.
	    * 
	    * @param 	userId  the user id.
	    * @return 	the resource associated to the user id,
	    * 			otherwise return null.
	    */ 
	    public function findByUser(userId : String) : Resource{
	    	var resourceUser : Resource;
	    	for each(var resource : Resource in resources){
	    		if(resource.user.id == userId){
	    			resourceUser = resource;
	    		}
	    	}
	    	return resourceUser;
	    }
	    
	    /**
	    * Returns the available resources, not assignee  to any task.
	    * 
	    * @return 	the available resources.
	    */
	    public function getAvailableResources() : ArrayCollection
	    {
	    	var availableResources : ArrayCollection = new ArrayCollection();
	    	for(var i : int = 0; i < resources.length ; i++)
	    	{
	    		var resource : Resource = Resource(resources.getItemAt(i));
		    	
		    	availableResources.addItem(resource);
	    	}
	    	return availableResources;
	    }
	}
}