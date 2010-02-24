package com.salesforce.gantt.commands.profile
{
	import com.salesforce.gantt.commands.SimpleCommand;
	import com.salesforce.gantt.controller.Components;
	import com.salesforce.gantt.model.Profile;
	import com.salesforce.gantt.util.CustomSObject;
	import com.salesforce.results.QueryResult;

	/**
	 * Class responsible to encapsultate the read information about a project's profile.
	 *
	 * @author Rodrigo Birriel
	 */
	public class ReadProfilesCommand extends SimpleCommand
	{
		public function ReadProfilesCommand()
		{
			super();
		}
		
		override public function execute():void{
			Components.instance.salesforceService.profileOperation.load(this);
		}
		
		override protected function actionCallBack(response : Object):void{
			var queryResult : QueryResult = QueryResult(response);
			var profile : Profile;
			var profileSObject : CustomSObject;
			Components.instance.profiles.removeAll();
			for (var i : int = 0; i < queryResult.size; i++){
				profileSObject = queryResult.records[i];
				profile = new Profile();
				profile.id = profileSObject.Id;
				profile.name = profileSObject.Name;
				profile.canManage = profileSObject.getProperty('ManageProjectTasks__c');
				profile.canCreate = profileSObject.getProperty('CreateProjectTasks__c');
				Components.instance.profiles.add(profile);
			}
		}
	}
}