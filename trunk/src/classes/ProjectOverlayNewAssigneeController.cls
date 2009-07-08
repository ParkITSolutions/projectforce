public class ProjectOverlayNewAssigneeController {

	private Id projectId;
	
	private Id taskId;
	private String taskName = '';
	
	private List<SelectOption> memberList = new List<SelectOption>();
	private Id memberSelected;
	
	private List<SelectOption> scale = new List<SelectOption>();
	private Integer PercentSelected = 0; 
	
	/* 
	* Constructor
	*/
	public ProjectOverlayNewAssigneeController(){
		taskId = System.currentPageReference().getParameters().get('id');
	}	
	
	/**
	*Set project Id.
	*@param Id pId
	*@return void
	*/
	public void setProjectId( Id pId ){
		this.projectId = pId;
	}

	/**
	*Return project Id.
	*@return Id
	*/
	public Id getProjectId(){
		return this.projectId;
	}

	/**
	*Set task Id.
	*@param Id
	*@return void
	*/
	public void setTaskId( Id tId ){
		this.taskId = tId;
	}

	/**
	* Returns task Id.
	*@return Id
	*/
	public Id getTaskId(){
		return this.taskId;
	}
	
	/**
	*Return members list.
	*@return List<Member>
	*/
	public List<SelectOption> getMemberList(){
		this.createMemList();
		return this.memberList;
	}
	
	/**
	*Return member selected id.
	*@return Id
	*/
	public Id getMemberSelected(){
		return this.memberSelected;
	}

	/**
	*Set member selected id.
	*@param Id
	*@return void
	*/
	public void setMemberSelected( Id mS ){
		this.memberSelected = mS;
	}
	
	/**
	*@return List<SelectOption>
	*/
	public List<SelectOption> getScale(){
		this.construcPercentScale();
		return this.scale;
	}
	
	/**
	* Set the percent selected.
	*@return Integer
	*/
	public Integer getPercentSelected(){
		return this.PercentSelected;
	}
	
	/**
	*Set the percent selected.
	*@param Integer pS
	*@return void
	*/
	public void setPercentSelected( Integer pS ){
		this.PercentSelected = pS;
	}

	/**
	* Returns project name.
	*@return String
	*/
	public String getTaskName(){
		this.extTaskName();
		return this.TaskName;
	}

    /**
	*Return if memberlist has size==0.
	*@return boolean
	*/
	public boolean getMemberListSize(){
		if (memberList.size()>0) {
			return true;		
		}else return false;
	}
	
	public void saveAssignee(){
		
		ProjectAssignee__c newAss = new ProjectAssignee__c();
		
		newAss.Project__c = this.projectId;
		newAss.ProjectTask__c = this.taskId;
		newAss.User__c = (String)this.memberSelected;
		newAss.PercentDedicated__c = this.PercentSelected;
		insert newAss;
		
		//reset percent to 0
		this.PercentSelected = 0;
				
	}
	
	/**
	*Construc the percent scale.
	*/
	private void construcPercentScale(){
	
		String toStr;
		if( this.scale.size() != 21 )
			for( Integer k = 0; k < 21; k++){
				toStr = ( k * 5 ).format();
				this.scale.add( new SelectOption( toStr, toStr ));
			}
	}

	/**
	* Get project name from D.B.
	*@return void
	*/
	private void extTaskName(){
	
		if( this.TaskName == '' ){
			ProjectTask__c pT = new ProjectTask__c();
			pT = [ select Id, Project__c, Name from ProjectTask__c where Id =: taskId ];
			this.projectId = pT.Project__c; 
			this.taskName = pT.Name;
		}
	}	
		
	/**
	*Create a members list.
	*@return void
	*/
	private void createMemList(){
	
		List<ProjectMember__c> memList = new List<ProjectMember__c>();
		List<ProjectAssignee__c> assi = new List<ProjectAssignee__c>();
		List<String> idsAssi = new List<String>();
		
		assi = [ select User__c from ProjectAssignee__c where ProjectTask__c =: taskId ];
		
		if( assi.size() > 0 ){
			for( ProjectAssignee__c a : assi )
			idsAssi.add( a.User__c );
		}

		if( this.projectId == null )
		this.extTaskName();
		
		memList = [ select Id, User__c, User__r.Name 
						from ProjectMember__c 
						where Project__c =: projectId and User__r.IsActive != false and User__c not in: idsAssi ];
 		
 		if( memList.size() > 0 ){
 			this.memberList = new List<SelectOption>();
			SelectOption aMember = new SelectOption( 'Choose a member', 'Choose a member' );
			this.memberList.add( aMember );			
			for(ProjectMember__c m : memList){
				aMember = new SelectOption( m.User__c, m.User__r.Name );
				this.memberList.add( aMember );			
			}
		}		
	}
}