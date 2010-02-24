package com.salesforce.gantt.controller
{
	import com.salesforce.gantt.model.Profile;
	 
	public interface IProfiles{
		function add(profile: Profile) : void;
		function find(profileId : String) : Profile;
		function projectMember(): Profile;
		function removeAll() : void;
	}
}