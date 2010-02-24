package com.salesforce.gantt.commands.resource
{
	import com.salesforce.Util;
	import com.salesforce.gantt.commands.SimpleCommand;
	import com.salesforce.gantt.controller.Components;
	import com.salesforce.gantt.model.Project;
	import com.salesforce.gantt.model.Resource;
	import com.salesforce.gantt.model.User;
	import com.salesforce.gantt.util.CustomSObject;
	import com.salesforce.objects.SObject;
	import com.salesforce.results.QueryResult;

	/**
	 * Command class container responsible to load the project's resources
	 * 
	 * @author Rodrigo Birriel
	 */ 
	public class ReadResourcesCommand extends SimpleCommand
	{
		private var project : Project;
		
		public function ReadResourcesCommand(project : Project)
		{
			super();
			this.project = project;
		}
		
		override public function execute() : void{
			Components.instance.salesforceService.resourceOperation.loadProyectResources(project,this);
		}
		
		override protected function actionCallBack(response : Object) : void{
			var queryResult : QueryResult = response as QueryResult;
			var userSObject : Object;
			var profileSObject : Object;
			var resourceSObject : CustomSObject;
			var resourceId : String;
			var user : User
			var resource : Resource;
			Components.instance.users.removeAll();
			Components.instance.resources.removeAll();
			for (var i : int = 0; i < queryResult.records.length; i++) 
	    	{ 				    		
	    		resourceSObject = queryResult.records[i];
	    		userSObject = resourceSObject.getProperty('User__r');
	    		profileSObject = resourceSObject.getProperty('Profile__r'); 
	    		resourceId = resourceSObject.Id;
	    		
	    		// add new user to users'handler associated to a resource
	    		user = new User(userSObject.Id,userSObject.Name);
	    		user.firstName = userSObject.FirstName;
	    		user.lastName = userSObject.LastName;
	    		user.title = userSObject.Title;
	    		//user.profile = profileSObject.Name;
	    		user.companyName = userSObject.CompanyName;
	    		Components.instance.users.addOrUpdate(user);
	    		
	    		// add new resource to resources's handler
	    		resource = new Resource(userSObject.Name, resourceId,user);
	    		//FIXME please ouch it hurts!!
	    		if(profileSObject){
	    			resource.profile = Components.instance.profiles.find(profileSObject.Id);	
	    		}
	    		resource.createdDate = Util.stringToDate(resourceSObject.CreatedDate);
	    		resource.isProjectOwner = project.createdBy == user.id;
	    		Components.instance.resources.addOrUpdate(resource);
	    	}
		}
	}
}