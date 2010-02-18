/**
* @author Matias Menafra
*/
public class ProjectSetupController {

	public List<SelectOption> allProfiles   		{ set; get; }
	public List<SelectOption> savedProfiles 		{ set; get; }
	public String selectedProfsStr 					{ set; get; }
	private List<String> selectedProfsList 			{ set; get; }
	private	List<ProjectSetup__c> savedProfilesStr 	{ set; get; }
	
	/**
	* Constructor
	*/
	public ProjectSetupController(){
		allProfiles = new List<SelectOption>();
		this.savedProfiles = new List<SelectOption>();
		selectedProfsList = new List<String>();
		savedProfilesStr = new List<ProjectSetup__c>();
		this.setingAllProfiles();
	}
	
	/**
	*
	*@param String[] s
	*@return void
	*//*
	public void setSelectedProfilesList( String[] s ){
		String p = s[0];
	}
	*/
	


	/**
	*@return List<SelectOption>
	*//*
	public List<SelectOption> getSavedProfiles(){
		this.setingAllProfiles();
		return this.savedProfiles;
	}

	/**
	*@return PageReference
	*/	
	public PageReference saveAdmSettings(){
		
		if( this.savedProfilesStr.size() > 0 ){
			this.savedProfilesStr[0].CanViewButtonNew__c =  selectedProfsStr;
			update this.savedProfilesStr;
		}else{
			ProjectSetup__c newSetup  = new ProjectSetup__c();
			newSetup.CanViewButtonNew__c = this.selectedProfsStr;
			insert newSetup;
		}

		this.setingAllProfiles();
		
		PageReference pr = new PageReference( '/apex/ProjectOverview');
		pr.setRedirect( true );
		return pr;
	}

	/**
	*@return void 
	*/
	private void setingAllProfiles(){

		this.allProfiles.clear();
		this.savedProfiles.clear();
		this.selectedProfsList.clear();
		
		this.stringProfiles();
		
		//Profiles can't view
		List<Profile> allProfilesTemp = new List<Profile>(); 
		allProfilesTemp = [ select id, name 
								from Profile 
								where id not in: this.selectedProfsList and name != 'System Administrator'];
		
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
	*@return void 
	*/
	public void stringProfiles(){
		
		this.savedProfilesStr = [ select Id, CanViewButtonNew__c from ProjectSetup__c limit 1 ];
		if( this.savedProfilesStr.size() > 0 ){
			if(savedProfilesStr[0].CanViewButtonNew__c != null )
				this.selectedProfsList = savedProfilesStr[0].CanViewButtonNew__c.split( '#' );
		}
	}
	
	/**
	*@return boolean 
	*/
	public Boolean canView(){		
		
		return  this.getIfCanModifyAllData() || (( this.savedProfilesStr.size() > 0 ) && savedProfilesStr[0].CanViewButtonNew__c.contains( UserInfo.getProfileId()));
	}	

	/**
	*@return boolean 
	*/
	public Boolean getIfCanModifyAllData(){
		
		return [Select id, Profile.PermissionsModifyAllData 
				From User 
				where id =: UserInfo.getUserId() 
				limit 1].Profile.PermissionsModifyAllData; 		
	}	
}