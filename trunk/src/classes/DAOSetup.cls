/**
* @author Nicolas Dominguez 02/19/2010
*/
public class DAOSetup {

	/**
	* Constructor
	*/
	public DAOSetup(){
	}
	
	/**
	* Get ListSavedProfiles from ProjectSetup 
	* @return List<ProjectSetup__c>
	*/
	public List<ProjectSetup__c> getListSavedProfiles(){ 
		return [ select Id, ListSavedProfiles__c, CanViewButtonNew__c from ProjectSetup__c limit 1 ];
	}
	
	/** 
	* Insert project setup
	* @param ProjectSetup__c 
	*/
	public void insertProjectSetup( ProjectSetup__c projectSetup ){
		insert projectSetup;
	}
	
	/** 
	* Updtate project setup
	* @param ProjectSetup__c
	*/
	public void updateProjectSetup( ProjectSetup__c projectSetup ){
		update projectSetup;
	}
}