/**
* @author Matias Menafra
* @updatedDate 02/19/2010 Nicolas Dominguez
*/

/*  
	Possible List of ProjectSetup__c.ListSavedProfiles__c
	-----------------------------------------------------
	System Administrator
	Solution Manager
	Read Only
	Custom: Sales Profile
	Custom: Marketing Profile
	Custom: Support Profile
	Marketing User
	Contract Manager
	Standard User
	Standard Platform User
	Partner User
	Customer Portal Manager
	Partner Network
	Package License Manager
*/

public class ProjectSetupController {

	public String messageInfoToUsr 			{ set; get; }
	public ProjectSetup__c ProjectSetup 	{ set; get; }
	public String typeMessage				{ set; get; }
	private Boolean insertProjectSetup;
	
	/**
	* Constructor
	*/
	public ProjectSetupController(){
		
		ProjectSetup = new ProjectSetup__c();
		this.insertProjectSetup = true;
		this.typeMessage		= '';
		this.messageInfoToUsr 	= '';
		
		//Obtain list of saved Profiles
		listProfiles();
	}
	
	/** 
	* Obtain list of saved Profiles
	*/
	public void listProfiles(){
		List<ProjectSetup__c> ListAux = DAOFactory.getInstance().getListSavedProfilesProjectSetup();
		
		if( ListAux.size() > 0 ){
			this.ProjectSetup = ListAux[0];
			this.insertProjectSetup = false;
		}
		else{
			this.ProjectSetup = new ProjectSetup__c();
			this.insertProjectSetup = true;
		}
	}

	/** 
	* Save Setup
	*/	
	public void saveSetup(){
		try{
			if ( insertProjectSetup ){
				//Insert the ProjectSetup;
				DAOFactory.getInstance().insertProjectSetup( ProjectSetup );
				this.insertProjectSetup = false;
			}
			else{
				//Update the ProjectSetup;
				DAOFactory.getInstance().updateProjectSetup( ProjectSetup );
			}
			
			this.messageInfoToUsr 	= 'Project Setup Saved Successfully.';
			this.typeMessage 		= 'success';
		}
		catch( Exception e ) {
			this.messageInfoToUsr 	= 'Error: Please Reload the Page. ';
			this.typeMessage 		= 'error';
		}
	}
	
	/**
    * Test Object Formatter
    */
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
		
		Test.setCurrentPageReference( new PageReference( 'Page.ProjectSetup' ) );
		System.currentPageReference().getParameters().put( 'id', GenerateEnvironmentTest.project.id );

		ProjectSetupController projectSetup = new ProjectSetupController();
		projectSetup.saveSetup();
		
    	Test.stopTest();
		ProjectUtil.setIsTest( false );    	
    }
}