/**
*@author Rodrigo Birriel @ 06/09/2008
*/
public without sharing class ProjectsCreateNewProjectController {
	
	public static Boolean allowCustomer = true;//false;
	public static Boolean allowPartner = true;//false;  

	List<Group> allowCustomerActivated = new List<Group>();
	List<Group> allowPartnetActivated = new List<Group>();
	/**
	* Attributes
	*/
    private Project2__c theTeam = new Project2__c();
    
    /**
    * Constructor
    */
    public ProjectsCreateNewProjectController(){
    	allowCustomerActivated = [ SELECT Id FROM Group WHERE Type = 'AllCustomerPortal' ];
		allowPartnetActivated = [ SELECT Id FROM Group WHERE Type = 'PRMOrganization' ];

		String idAct = system.currentPageReference().getParameters().get( 'id' );
		if( idAct !=  null ){
			List<GroupMember> gm = new List<GroupMember>();
			Group instance = new Group();
			String instanceName = 'projectSharing' + idAct;
			if(allowCustomerActivated.size() > 0 ){
				instance = [ SELECT Id FROM Group WHERE Name =: instanceName LIMIT 1 ];
				gm = [ SELECT Id FROM GroupMember WHERE GroupId =: instance.Id AND UserOrGroupId =: allowCustomerActivated[0].Id ];
				ProjectsCreateNewProjectController.allowCustomer = (gm.size() > 0) ? true : false;
			}
			if(allowPartnetActivated.size() > 0 ){
				instance = [ SELECT Id FROM Group WHERE Name =: instanceName LIMIT 1 ];
				gm = [ SELECT Id FROM GroupMember WHERE GroupId =: instance.Id AND UserOrGroupId =: allowPartnetActivated[0].Id ];
				ProjectsCreateNewProjectController.allowPartner = (gm.size() > 0) ? true : false;
			}		 
		}	
    }
    
	/**
	*@param Boolean
	*/
	public static Boolean getAllowCustomerStatic(){ 
		return allowCustomer ;
	}
	/**
	*@param Boolean
	*/
	public static Boolean getAllowPartnerStatic(){ 
		return allowPartner ;
	}

	/**
	*@param Boolean
	*/
	public void setAllowCustomer( Boolean value ){
		ProjectsCreateNewProjectController.allowCustomer = value;
	}
	/** 
	*@param Boolean
	*/
	public void setAllowPartner( Boolean value ){
		ProjectsCreateNewProjectController.allowPartner = value;
	}
	/**
	*@return Boolean
	*/
	public Boolean getAllowCustomer(){
		return ProjectsCreateNewProjectController.allowCustomer;
	}
	/**
	*@return Boolean 
	*/
	public Boolean getAllowPartner(){
		return ProjectsCreateNewProjectController.allowPartner;
	} 
	/**
	*@return Boolean
	*/
	public Boolean getAllowCustomerActivated(){
		return allowCustomerActivated.size() > 0;
	}
	/**
	*@return Boolean
	*/
	public Boolean getAllowPartnerActivated(){
		return allowPartnetActivated.size() > 0;
	}	
    

}