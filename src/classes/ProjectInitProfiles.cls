public class ProjectInitProfiles {

	public List<String> profilesNames = new List<String> {'Member Profile' , 'Public Profile' , 'Project Administrator'};
    public List<ProjectProfile__c> profilesToInsert = new List<ProjectProfile__c>();
    public List<ProjectProfile__c> profiles = new List<ProjectProfile__c>();
    public ProjectProfile__c projectProfile =  new ProjectProfile__c(); 
    public Boolean showOverlay = false;

	

	/**
	*@ Contructor
	*/
	public ProjectInitProfiles (){
		
        profiles = [select Id, Name from ProjectProfile__c where Name in : profilesNames];
        
       	if(!existProfile('Member Profile')){
            projectProfile = new ProjectProfile__c();
            projectProfile.Name = 'Member Profile';
            projectProfile.ManageProjectTasks__c = false;
            projectProfile.CreateProjectTasks__c = true;
            profilesToInsert.add( projectProfile );
        }
        
        if(!existProfile('Public Profile')){
            projectProfile = new ProjectProfile__c();
            projectProfile.Name = 'Public Profile';
            projectProfile.ManageProjectTasks__c = false;
            projectProfile.CreateProjectTasks__c = false;
            profilesToInsert.add( projectProfile );
        }
        
        if(!existProfile('Project Administrator')){
            projectProfile = new ProjectProfile__c();
            projectProfile.Name = 'Project Administrator';
            projectProfile.ManageProjectTasks__c = true;
            projectProfile.CreateProjectTasks__c = true;
            profilesToInsert.add( projectProfile);
        }
        
        if(profilesToInsert.size() > 0)
        	showOverlay = true;

	}
	
	/**
	*@ Save Profiles
	*/
	public void saveProfiles(){
		insert profilesToInsert;
	}
	
	/**
	*@Check from list if Name Profile exist an set boolean
	*/
	public Boolean existProfile(String name){
        for(ProjectProfile__c profile : profiles){
        	if (profile.Name == name){        	
        		return true;
        		break;	
        	}
        }
        return false;	
	}
	public Boolean getShowOverlay(){
		return showOverlay;
	}

}