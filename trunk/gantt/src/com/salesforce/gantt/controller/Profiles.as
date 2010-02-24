package com.salesforce.gantt.controller
{
	import com.salesforce.gantt.model.Profile;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * Profiles handler.
	 * 
	 * @author Rodrigo Birriel
	 */ 
	 
	public class Profiles implements IProfiles
	{
		private var profiles : ArrayCollection;
		
		public function Profiles(){
			profiles = new ArrayCollection();
		}
		
		/**
		 * Add a profile to the profiles's collection
		 * @param profile the instance to be added
		 */
		public function add(profile: Profile):void{
			profiles.addItem(profile);
		}
		
		/**
		 * Given a profile id returns the profile's instance,
		 * otherwise return null.
		 * @param profileId the profile identifier to be found.
		 * @return Profile the profile found.
		 */ 
		public function find(profileId:String):Profile{
			var currentProfile : Profile = null;
			for each( var profile : Profile in profiles){
				if(profile.id == profileId){
					currentProfile = profile;
					break;
				}
			}
			return currentProfile;
		}
		
		/**
		 * Search in the collection for a profile with specific permission
		 * for project's member
		 * 
		 * @return Profile a instance of this, otherwise null.
		 */
		public function projectMember(): Profile{
			var projectMember : Profile;
			for each( var profile : Profile in profiles){
				if(profile.canCreate && !profile.canManage){
					projectMember = profile;
				}
			}
			return projectMember;
		}
		
		public function removeAll() : void{
			profiles.removeAll();
		}
	}
}