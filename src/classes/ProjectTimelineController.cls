/**
*@author Nicolas Gunther @ 16/07/2008
*/
public with sharing class ProjectTimelineController {
    
    private Project2__c project;    
    private String param = System.currentPageReference().getParameters().get('id');
    
    /**
    *Constructor
    */
    public ProjectTimelineController(){
        getTeamAndProject(param);
    }
    
    /**
    * Get Project
    *@return Project2__c
    */
    public Project2__c getProject(){
		return this.project;
    }
    
    
    /**
    * Get Namespace
    *@return namespace
    */
    public String getNamespace(){
    	return ProjectUtil.getNamespace();
    }
    
    /**
    * Get Team and Project for current team id
    *@param String param
    *@return void
    */
    public void getTeamAndProject(String param){
        if(param != null){
            project = [select Id, Name from Project2__c p where p.Id =: param];
        }
    }
}