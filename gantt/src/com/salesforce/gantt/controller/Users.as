package com.salesforce.gantt.controller
{
	import com.salesforce.gantt.model.User;
	
	import mx.collections.ArrayCollection;
	
	public class Users implements IUsers
	
	{
	    					
		[Bindable]
		public var users : ArrayCollection;
		
		/*
		 * Constructor
		 */
		public function Users() : void
		{
			users = new ArrayCollection();
		}
		
		/**
		 * Find a user by id
		 * @param id : user id.
		 * @return User identified with id.
		 */
		public function getUser(id : String) : User
		{
			var userFound : User = null ;
			for each(var user : User in users){
				if(user.id == id){
					userFound = user;
					break
				}
			}
			return userFound;
		}
		
		/**
		 * Add or update a user in the users's collection,
		 * if the user exsits this is updated otherwise is added.
		 * @param user the instance to be added or updated.
		 */
		public function addOrUpdate(user : User) : void{
			var userLocal : User = getUser(user.id);
			if(!userLocal){
				users.addItem(user);
			} else{
				userLocal = user;
			}
		}
		
		/**
		 * Clean the users collection
		 */ 	
		public function removeAll() : void{
			users.removeAll();
		}
	}
}