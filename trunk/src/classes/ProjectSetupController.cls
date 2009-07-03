public class ProjectSetupController {

	private List<SelectOption> allProfiles   = new List<SelectOption>(); 
	private List<SelectOption> savedProfiles = new List<SelectOption>(); 
	public String selectedProfsStr = '';
	private List<String> selectedProfsList = new List<String>();
	private	List<ProjectSetup__c> savedProfilesStr = new List<ProjectSetup__c>();
	
	/**
	* Constructor
	*/
	public ProjectSetupController(){		
		this.setingAllProfiles();
	}
	
	public void setSelectedProfilesList( String[] s){
		String p = s[0];
	}
	
	public String[] getSelectedProfilesList(){
		String[] p = new String[]{};
		return p;
	}
	
	/**
	*
	*/
	public List<SelectOption> getAllProfiles(){
		return this.allProfiles;
	}

	/**
	*
	*/
	public List<SelectOption> getSavedProfiles(){
		this.setingAllProfiles();
		/**
		if( this.savedProfiles.size() == 0 ){
			Profile admProfile = [ select id, name from Profile where name = 'System Administrator'];			
			this.savedProfiles.add( new SelectOption( admProfile.id, admProfile.name ));
		}
		*/
		return this.savedProfiles;
	}

	/**
	*
	*/	
	public void saveAdmSettings(){
		
		if( this.savedProfilesStr.size() > 0 ){
			this.savedProfilesStr[0].CanViewButtonNew__c =  selectedProfsStr;
			update this.savedProfilesStr;
		}else{
			ProjectSetup__c newSetup  = new ProjectSetup__c();
			newSetup.CanViewButtonNew__c = this.selectedProfsStr;
			insert newSetup;
		}

		this.setingAllProfiles();
	}
	
	/**
	*
	*/
	public void setSelectedProfsStr( String s ){
		this.selectedProfsStr = s;
	}

	/**
	*
	*/
	public String getSelectedProfsStr(){
		return this.selectedProfsStr;
	}
	
	// Private methods

	/**
	*
	*/
	private void setingAllProfiles(){
		
		this.stringProfiles();
		
		// Profiles can't view
		List<Profile> allProfilesTemp = new List<Profile>(); 
		allProfilesTemp = [ select id, name from Profile where id not in: this.selectedProfsList and name != 'System Administrator'];
		
		if( allProfilesTemp.size() > 0 ){
			this.allProfiles.clear();
			for( Profile pr : allProfilesTemp )
				this.allProfiles.add( new SelectOption( pr.id, pr.name ));
		}	
		
		// Profiles can view
		if( this.savedProfilesStr.size() > 0 )
		if( savedProfilesStr[0].CanViewButtonNew__c != null ){
			
			List<Profile> savedProfilesTemp = new List<Profile>(); 
			savedProfilesTemp = [ select id, name from Profile where id in: this.selectedProfsList ];
			
			if( savedProfilesTemp.size() > 0 ){
				this.savedProfiles.clear();
				for( Profile pr : savedProfilesTemp )
					this.savedProfiles.add( new SelectOption( pr.id, pr.name ));
			}
		}	
	}
	
	/**
	*
	*/
	public void stringProfiles(){
		this.savedProfilesStr = [ select Id, CanViewButtonNew__c from ProjectSetup__c limit 1 ];
		if( this.savedProfilesStr.size() > 0 ){
			if(savedProfilesStr[0].CanViewButtonNew__c != null )
				this.selectedProfsList = savedProfilesStr[0].CanViewButtonNew__c.split( '#' );
		}
	}
	
	/**
	*
	*/
	public Boolean canView(){		
		return  this.getIfCanModifyAllData() || savedProfilesStr[0].CanViewButtonNew__c.contains( UserInfo.getProfileId());
	}	

	/**
	*
	*/
	public Boolean getIfCanModifyAllData(){
		return [Select id, Profile.PermissionsModifyAllData From User where id =: UserInfo.getUserId() limit 1].Profile.PermissionsModifyAllData; 		
	}	

}