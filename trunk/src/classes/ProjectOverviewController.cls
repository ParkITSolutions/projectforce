/** 
*@author Rodrigo Birriel @ 03/17/2009
*/
public with sharing class ProjectOverviewController {

	public Boolean  isProduction 			{ set; get; }
    public List<ProjectMember__c> projects = new List<ProjectMember__c>();
    public List<Project> auxProjectsList = new List<Project>();
    public String parentId = null;
    public String filter = System.currentPageReference().getParameters().get('filter');
    public PaginatorController paginator = new PaginatorController();
    public Boolean isTest = false;
    List<Project> retProjects = new List<Project>();
    public List<Letters> letterFilter = new List<Letters>();
    //Letters list
    public List<String> lettersList = new List<String>{'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'};    
    public String objectPrefix = Schema.SObjectType.Project2__c.getKeyPrefix();
    //Items to list per page
    static final Integer itemsToList = 10;
    public UserPermissions userPermissions	 	{ set; get; }
	public Boolean isManager   					{ set; get; }
    public String domain;
    
    /**
    * Construct
    */
    public projectOverviewController(){
    	
    	this.isProduction = ProjectUtil.isProduction;
        projectsForTabs();
        
        domain = ProjectUtil.getDomain();
        
        this.userPermissions = new UserPermissions();
		this.genPermissions();
		
    } 
    
    /**
    * Load permission for current user
    */
 	public void genPermissions(){
        this.userPermissions.setId( UserInfo.getUserId() );
        this.userPermissions.setObjectType( 'Project' );
        this.userPermissions.setPermissions();
        
        this.isManager 	= this.userPermissions.getCanManage();
    }
    
    /**
    * Obtian and save the org url 
    * @return void
    */
    public void GetHost(){
		/*AuxHostName__c  mcs  =  AuxHostName__c.getInstance('DirHostName');
		mcs.FieldHostName__c = ProjectUtil.getDomain();
		upsert mcs;*/
    }
    
  	/**
    *If a given string has its length greater than wordLength param,
    *it returns the same string but cut by lengthCriteria
    *
    *@param String string
    *@param int wordLength
    *@param int lengthCriteria
	*@return String
	*/
	public String cutString(String phrase, Integer wordLength, Integer lengthCriteria){
		
		if(phrase.length() > wordLength){
			phrase = phrase.substring(0, lengthCriteria)+'...';
		}
		
		return phrase;
	}
    
	/**
	*@return String
	*/
	public String getDomain(){
		return this.domain;
	}
    
    /**
    *@param Boolean b
    *@return void
    */
    public void setIsTest(Boolean b){
        isTest = b;
    }
    
    /**
    *@return PaginatorController
    */
    public PaginatorController getPaginator (){
        return paginator;
    }
    
    /**
    *@param String id
    *@return void
    */
    public void setParentId (String id){
        parentId = id;  
    }
    
    /**
    *@param String f
    *@return void
    */
    public void setFilter(String f){
        filter = f;
    }       

    /**
    * Check if project profile exist for current user
    * @return PageReference
    */
    public PageReference getProfileExist(){
        PageReference pr = null;
        List<ProjectProfile__c> profiles = new List<ProjectProfile__c>();
        if(profiles.size() == 0){
            ProjectProfile__c profile = new ProjectProfile__c();
            profile.Name = UserInfo.getName();
            insert profile;
        }
        return pr;
    }
    
    /**
    *@return List<ProjectMember__c>
    */
    public List<ProjectMember__c> getProjects(){
        return projects;
    }
    
    /**
    *@param List<ProjectMember__c> tms
    *@return void
    */
    public void setProjects(List<ProjectMember__c> tms){
        projects = tms;
    }
    
    /**
    *
    *@return string
    */
    public String getObjectPrefix(){
        return objectPrefix;
    }
     
    /**
    * This method completes the list of Project: "retProject"
    *@return List<Project>
    */
    public List<Project> getProjectsForTabs(){
        return retProjects;
    }  

    /**
    *Determines who can view the Create New Project button
    *@return Boolean
    */
    public Boolean getCanViewCreateNewProject(){
        /*ProjectSetupController canV = new ProjectSetupController();
        return canV.canView();*/
        return true;
    }
    
    /**
    *@projectsForTabs()
    * This method completes the list of Projects: "retProjects"
    *@return void
    */
    public void projectsForTabs(){
        //filter for query
        List<Project2__c> projects = new List<Project2__c>();
        retProjects.clear();
        auxProjectsList.clear();
        isAllProjects = false;
        
        //For Code Coverage Use
        Integer lim = (isTest) ? 1 : 1000;       
        
        //Types of filter
        if(System.currentPageReference().getParameters().get('filter') != null)
            filter = System.currentPageReference().getParameters().get('filter');
            
 
        
        if(filter == 'newProjects')//@newProjects
        {
        	projects.addAll([Select (Select Id  From ProjectsMembers__r), (Select Id, Milestone__c From ProjectsTasks__r), t.CreatedDate, t.Name, t.Picture__c, t.Id From Project2__c t ORDER by t.CreatedDate  DESC LIMIT :lim]);                              
        }
        else if(filter == 'allProjects') //@allProjects
        {
            projects.addAll([Select (Select Id From ProjectsMembers__r), (Select Id, Milestone__c From ProjectsTasks__r), t.Name, t.Picture__c, t.Id From Project2__c t order by t.Name asc limit :lim]);                             
            //Only allProjects show pagination and abc
            isAllProjects = false;
        	//@Default My Projects
        }
        else
        {
            List<ProjectMember__c> tml = new List<ProjectMember__c>();
            
            tml = [Select s.Project__c,s.Project__r.Id 
                    From ProjectMember__c s 
                    where s.User__c =: UserInfo.getUserId() 
                    order by s.CreatedDate desc 
                    limit :lim];
            
            List<Project2__c> projectsAux = new List<Project2__c>();
            
            for(ProjectMember__c tm : tml){
                if(tm.Project__r != null){
                    projectsAux.add(tm.Project__r);
                }
            }
            
            projects.addAll( [Select (Select Id,User__c From ProjectsMembers__r), (Select Id, Milestone__c From ProjectsTasks__r), t.Name, t.Picture__c, t.Id From Project2__c t where t.Id in : projectsAux order by t.Name asc] );
                  
        }
        /* AM commented
        if(filter == 'allProjects'){
            paginator.setNumberOfItemsToShow(itemsToList);//(10);
        }else{
            paginator.setNumberOfItemsToShow(projects.size()); 
        }
        */
        if(projects.size() >= 1){
            isAllProjects = true;
        }
        if (projects.size()>itemsToList){
            paginator.setNumberOfItemsToShow(itemsToList);//(10);
        }else{
            paginator.setNumberOfItemsToShow(projects.size()); 
        }
              
        //Populate Inner class with project List
        
        if(projects.size() > 0){
            for(Integer i=0; i<projects.size(); i++){
                
                Project t = new Project();
                t.name = cutString(projects[i].Name, 70, 60);
                t.image = projects[i].Picture__c;
                t.id = projects[i].Id;
                t.members = projects[i].ProjectsMembers__r.size();
                
                //Looking for milestone in tasks
                t.milestones = 0;
                for(ProjectTask__c task : projects[i].ProjectsTasks__r){
                    if(task.Milestone__c)
                        t.milestones++;
                } 
                
                t.tasks = projects[i].ProjectsTasks__r.size() - t.milestones;
                
                if(filter == 'newProjects'){
                    if(projects[i].CreatedDate != null){
                        String format = projects[i].CreatedDate.format('MM/dd/yyyy');
                        t.createDate = 'Created on '+String.valueOf(format);
                    }
                }else { 
                    t.createDate = '';
                }

                retProjects.add(t);
                auxProjectsList.add(t);
                paginator.clearPagination();
                paginator.setTotalItemsNumber(retProjects.size());
                paginator.genCntPagination();           
            } 
        }
    }
    
    /**
    * This method returns the size of the Projects list: "retProjects"
    *@return Integer
    */
    public Integer getProjectsForTabsSize(){
        return retProjects.size();
    }
    
    /*
    *@return boolean
    */
    public Boolean isAllProjects { get; set; }
  
    /**
    * Get Letter Filter
    *@return List<Letters> 
    */
    public List<Letters> getLetterFilter(){ 
        setLetterFilter();
        return  letterFilter;
    }
    
    /**
    * Set Letter Filter
    *@return void
    */
    public void setLetterFilter () {    
        if(System.currentPageReference().getParameters().get('ltr') != null)
            return;  
        letterFilter.clear();
        for (String item : lettersList){
            Letters currentLetter = new Letters();              
            Integer cntSites = 0;   
            
            for (Project t : auxProjectsList){ 
                if (t.name.startsWith(item) || t.name.startsWith(item.toLowerCase())){
                    cntSites++;
                }
            }
            currentLetter.CntSites = cntSites;
            currentLetter.Letter = item;
            currentLetter.setContainSites(cntSites);
            letterFilter.add(currentLetter);
        }   
    }
    
    /**
    * Filter for Projects
    *@return void
    */
    public void filterProjects (){
        String letter = System.currentPageReference().getParameters().get('ltr');
        retProjects.clear();
        if(letter != 'ALL'){
            for (Project t : auxProjectsList){
                if (t.name.startsWith(letter) || t.name.startsWith(letter.toLowerCase())){
                    retProjects.add(t);
                }
            }
        }else{
            for (Project t : auxProjectsList){
                retProjects.add(t);
            }
        }
        
        paginator.clearPagination();
        paginator.setTotalItemsNumber(retProjects.size());
        paginator.genCntPagination();           
    }
    
    
    /**
    * Inner Class Letters
    *@class
    */
    public class Letters{
        
        Boolean containSites;
        public String Letter{ get; set; }
        public Integer CntSites { get; set; }

        /**
        * Set num of ocurs.
        *@param Integer cntSites
        *@return void
        */
        public void setContainSites (Integer cntSites){
            if (cntSites == 0){
                this.containSites = false;
            }else{
                this.containSites = true;
            }
        }
        
        /**
        * Returns num of ocurs.
        *@return Boolean
        */
        public Boolean getContainSites (){
            return containSites;
        }
    }  
        
    /*
    * Inner Class project
    *@class
    */
    public class Project {
        
        public String name { get; set; }
        
        public String createDate{ 
            get; 
            set{
                createDate = value;
            } 
        }
        
        public String id { get; set; }
        
        /**
        *@return String
        */
        public String image {   
            set {
                if(value == null) 
                    image = 'null';
                else
                    image = '/servlet/servlet.FileDownload?file=' + value;
            }
            get; 
        }
        
        public Integer members { get; set; }
        
        public Integer tasks { get; set; }
        
        public Integer milestones { get; set; }        
    }
}