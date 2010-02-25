public class InstallController {

	public List<String> profilesNames = new List<String> {'Member Profile' , 'Public Profile' , 'Project Administrator'};
    public List<ProjectProfile__c> profiles = new List<ProjectProfile__c>();
    public ProjectProfile__c projectProfile =  new ProjectProfile__c(); 
    public List<ProjectProfile__c> profilesToInsert = new List<ProjectProfile__c>();

    
	
	/**
	*Constructor
	*/
	public InstallController(){
		InitializeProfiles();
	}
	
	/**
	*
	*/
	//TODO Javadoc
	public void projectSetupActualization(){
		List<ProjectSetup__c> setups = new List<ProjectSetup__c>();
		List<ProjectSetup__c> setupsMod = new List<ProjectSetup__c>();
		setups = [ SELECT id, CanViewButtonNew__c, ListSavedProfiles__c FROM ProjectSetup__c ];
		
		for( ProjectSetup__c sObj : setups )
			if (sObj.ListSavedProfiles__c != '' ){
				sObj.ListSavedProfiles__c = sObj.CanViewButtonNew__c;
				setupsMod.add( sObj );
			}
		
		if( setupsMod.size() > 0 )
			update setupsMod;
	}
	
	/**
	* Initializes Profiles
	*@return void
	*/
	private void InitializeProfiles(){
	
        profiles = [select Id, Name from ProjectProfile__c where Name in : profilesNames];
        
       	if(!existProfile(profilesNames.get(0))){
            projectProfile = new ProjectProfile__c();
            projectProfile.Name = profilesNames.get(0);
            projectProfile.ManageProjectTasks__c = false;
            projectProfile.CreateProjectTasks__c = true;
            profilesToInsert.add( projectProfile );
        }
        
        if(!existProfile(profilesNames.get(1))){
            projectProfile = new ProjectProfile__c();
            projectProfile.Name = profilesNames.get(1);
            projectProfile.ManageProjectTasks__c = false;
            projectProfile.CreateProjectTasks__c = false;
            profilesToInsert.add( projectProfile );
        }
        
        if(!existProfile(profilesNames.get(2))){
            projectProfile = new ProjectProfile__c();
            projectProfile.Name = profilesNames.get(2);
            projectProfile.ManageProjectTasks__c = true;
            projectProfile.CreateProjectTasks__c = true;
            profilesToInsert.add( projectProfile);
        }
        
        if(profilesToInsert.size() > 0)
        	insert profilesToInsert;
	}

	/**
	*Check from list if Name Profile exist an set boolean
	*@param String name
	*@return Boolean 
	*/
	public Boolean existProfile(String name){
        for(ProjectProfile__c profile : profiles){
        	if (profile.Name == name){        	
        		return true;	
        	}
        }
        return false;	
	}
}