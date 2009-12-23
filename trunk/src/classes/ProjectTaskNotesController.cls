/**
*@author Nicolas Dominguez @ 21/12/2009
*/

public class ProjectTaskNotesController {

	String teamIdParam = System.currentPageReference().getParameters().get('id');
	Project2__c teamspace = new Project2__c();
	
	String Html;
	
	
	
	/**
    * Constructor
    * @param ApexPages.StandardController
    */
    public ProjectTaskNotesController(ApexPages.StandardController ctrl){
    	this.setHtml('XXX - Sacar Hardcodeado - ProjectTaskNotesController.cls');
    }
    
    /**
    * Empty Constructor
    */
    public ProjectTaskNotesController(){
    	
    }   
    
    /**
    * @param String team id
    */
    public void setTeamIdParam (String idTeam){ 
        this.teamIdParam = idTeam;
    }
    
    /**
    * @return String teamIdParam The Id of the team
    */
    public String getTeamIdParam(){
        return this.teamIdParam;
    } 
    
    /**
    * Get project Name
    * @return String
    */
    public String getProjectName(){
		String pName = [Select Id, Name from Project2__c where id =: teamIdParam].Name;
		return ProjectUtil.chopWords( ProjectUtil.chopPhrase( pName , 57 ));    	
    }
    
    /**
    * @return String (html)
    */
    public String getHtml(){
    	return this.Html;
    }
    
    /**
	* @param String html
	*/
    public void setHtml(String htmlAux){
    	this.Html=htmlAux;
    }
    
    /**
    * @return PageReference
    */
    public PageReference CancelEdit () {
		//PageReference pageRef = Page.WikiPage;
		//pageRef.getParameters().put('idWP', editWP.Id);
		//pageRef.setRedirect(true);
		//return pageRef;
		System.debug('XXX - sin terminar...');
		return null;	
	}
    
    /**
	* Save changes and redirect
	* @return PageReference
	*/
	public PageReference SaveEdit () {
		
		/*
		PageReference pageRef = Page.WikiPage;
		pageRef.getParameters().put('idWP', editWP.Id);
		pageRef.setRedirect(true);
		
		return pageRef;
		*/
		System.debug('XXX - Html='+Html);
		System.debug('XXX - sin terminar...');
		return null;
	}
	
	
}