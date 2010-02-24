package com.salesforce.gantt.commands.resource
{
	import com.salesforce.gantt.commands.SimpleCommand;
	import com.salesforce.gantt.controller.Components;
	import com.salesforce.gantt.model.User;
	import com.salesforce.gantt.util.CustomSObject;
	import com.salesforce.results.QueryResult;
	
	import mx.collections.ArrayCollection;

	/**
	 * Command to encapsulate the users loading on demand.
	 * 
	 * @author Rodrigo Birriel
	 */
	public class ReadUserOnDemandCommand extends SimpleCommand{
		private var pattern : String;
		private var filteredElements : ArrayCollection;
		
		[Bindable]
		public var users : ArrayCollection;
		
		/**
		 * Constructor
		 * 
		 * @param pattern the substring to match.
		 * @param collection is a reference of the collection to be populated.
		 * @param filteredElements is the collection of ids to be discared in the query result.
		 */
		public function ReadUserOnDemandCommand(pattern : String, collection : ArrayCollection, filteredElements : ArrayCollection){
			super();
			this.pattern = pattern;
			users = collection;
			this.filteredElements = filteredElements;
		}
		
		override public function execute():void{
			Components.instance.salesforceService.resourceOperation.loadUsersOnDemand(pattern,filteredElements,this);	
		}
		
		override public function result(data:Object):void{
			var queryResult : QueryResult = QueryResult(data);
			var user : User;
			var record : CustomSObject;
			for(var i : int=0; i < queryResult.size;i++){
				record = queryResult.records[i];
				user = new User();
				user.id = record.Id; 
				user.name = record.Name; 
				user.firstName = record.FirstName;
				user.lastName = record.LastName;
				user.companyName = record.CompanyName;
				user.title = record.Title;
				users.addItem(user);
			} 
		}
	}
}