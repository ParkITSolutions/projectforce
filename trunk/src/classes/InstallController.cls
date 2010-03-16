/**
* @author Miguel Soares
* @createDate 02/23/2010
*/
public with sharing class InstallController {
	
	public Boolean 					isProduction { set; get; }
	public List<String> 			profilesNames;
    public List<ProjectProfile__c> 	profiles;
    public ProjectProfile__c 		projectProfile;
    public List<ProjectProfile__c> 	profilesToInsert;
	
	/**
	* Constructor
	*/
	public InstallController(){
		this.isProduction		= ProjectUtil.isProduction;
		this.profilesNames 		= new List<String> {'Member Profile' , 'Public Profile' , 'Project Administrator'};
	    this.profiles 			= new List<ProjectProfile__c>();
	    this.projectProfile 	= new ProjectProfile__c(); 
	  	this.profilesToInsert 	= new List<ProjectProfile__c>();
	}
	
	/**
	*
	*/
	public Pagereference projectSetupActualization(){
		
		List<ProjectSetup__c> setup = new List<ProjectSetup__c>();
		List<String> setupNames = new List<String>();
		
		setup = DAOFactory.getInstance().getListSavedProfilesProjectSetup();
		
		if( setup.size() > 0 && setup[ 0 ].CanViewButtonNew__c != null ){ 
			 			
			for( Profile s : [ SELECT id, Name FROM Profile WHERE id IN: setup[ 0 ].CanViewButtonNew__c.split( '#' ) ])
				setupNames.add( s.name );
				
			setup[ 0 ].ListSavedProfiles__c = ProjectUtil.joinStrListByToken( setupNames , ';' );
			
			DAOFactory.getInstance().updateProjectSetup( setup[ 0 ]);
		}

		return this.InitializeProfiles();
	}
	
	/**
	* Initializes Profiles
	*/
	private Pagereference InitializeProfiles(){
		
		Pagereference pageRef = Page.projectOverview;
		pageRef.setRedirect( true );
		
        profiles = [ select Id, Name from ProjectProfile__c where Name in : profilesNames ];
        
       	if( !existProfile( profilesNames.get(0) ) ){
            projectProfile = new ProjectProfile__c();
            
            projectProfile.Name 					= profilesNames.get(0);
            projectProfile.ManageProjectTasks__c 	= false;
            projectProfile.CreateProjectTasks__c 	= true;
            profilesToInsert.add( projectProfile );
        }
        
        if( !existProfile( profilesNames.get(1) ) ){
            projectProfile = new ProjectProfile__c();
            
            projectProfile.Name 					= profilesNames.get(1);
            projectProfile.ManageProjectTasks__c 	= false;
            projectProfile.CreateProjectTasks__c 	= false;
            profilesToInsert.add( projectProfile );
        }
        
        if( !existProfile( profilesNames.get(2) ) ){
            projectProfile = new ProjectProfile__c();
            
            projectProfile.Name 					= profilesNames.get(2);
            projectProfile.ManageProjectTasks__c 	= true;
            projectProfile.CreateProjectTasks__c 	= true;
            profilesToInsert.add( projectProfile);
        }
        
        if( profilesToInsert.size() > 0 ){
        	insert profilesToInsert;
        	return null;
        }
        
       return pageRef;
	}

	/**
	* Check from list if Name Profile exist an set boolean
	* @param name
	* @return Boolean 
	*/
	public Boolean existProfile( String name ){
        for( ProjectProfile__c profile : profiles ){
        	if( profile.Name == name ){        	
        		return true;	
        	}
        }
        return false;	
	}
	
	/**
    * Test Install Controller
    */
    public static testMethod void myUnitTest(){
    	
		ProjectUtil.setIsTest( true );
    	Test.startTest();
    	
    	delete [ select Id, Name from ProjectProfile__c ];
    	
		InstallController install = new InstallController();
		install.projectSetupActualization();
		
    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    }

    
    
}