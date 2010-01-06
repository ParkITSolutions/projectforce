/** 
*@author Nicolas Dominguez @ 21/12/2009
*/
public class ProjectTaskNotesController {

	private ProjectTask__c taskVar 	{ set; get; }
	public String taskId 			{ set; get; }
	public String taskNotes 		{ set; get; }
	public String taskName 			{ set; get; }
	public String taskNameShort 	{ set; get; }
	public String projectId 		{ set; get; }
	public String projectName 		{ set; get; }
	public String projectNameShort 	{ set; get; }
	public Boolean canAccess 		{ set; get; }
	public UserPermissions userPermissions = new UserPermissions();

	/**
    * Constructor
    * @param ApexPages.StandardController
    */
    public ProjectTaskNotesController(ApexPages.StandardController ctrl){
    	
		this.taskVar = new ProjectTask__c();
		
		this.genPermissions();
		this.obtainData();
    }
    
    /**
	* Generates permissions for an especific user
	*@return void
	*/
	public void genPermissions() {
		userPermissions.setId(UserInfo.getUserId());
		userPermissions.setObjectType('Project');
		userPermissions.setPermissions();		
	}
    
    /**
    * Obtains data from the task and project
    * @return void	
    */
	public void obtainData(){
		
		this.taskId=System.currentPageReference().getParameters().get('id_task');
		List<ProjectTask__c> taskList = new List<ProjectTask__c>();

		taskList = [
			Select p.Id,p.Project__c,p.Project__r.Name, p.Name, p.notes__c, p.CreatedById,
			(Select Id, User__c, User__r.Name, User__r.Id,PercentDedicated__c From ProjectsAssignees__r order by User__r.Name)
			From ProjectTask__c p 
			where p.Id =: taskId limit 1
			];
		if (taskList.size() > 0 ) {
			this.taskVar=taskList[0];
			if (this.taskVar != null){
				this.projectId=this.taskVar.Project__c;
				this.projectName=this.taskVar.Project__r.Name;
				
				//I cut out the name if too long
				this.projectNameShort=ProjectUtil.chopWords( ProjectUtil.chopPhrase( this.projectName , 20 ));
				
				this.taskName=this.taskVar.Name;
				//I cut out the name if too long
				this.taskNameShort=ProjectUtil.chopWords( ProjectUtil.chopPhrase( this.taskName , 20 ));
				
				this.taskNotes=this.taskVar.notes__c;
				
				//Permissions
				//I can access if it is true canAccess
				this.canAccess = false;
				if(UserInfo.getUserId() == this.taskVar.CreatedById){
					this.canAccess = true;	
				}
				else if (this.userPermissions.getCanManage()){
					this.canAccess = true;
				}
				else if(((this.taskVar.ProjectsAssignees__r).size() != 0) && (this.taskVar.ProjectsAssignees__r != null)){
					for (ProjectAssignee__c item: this.taskVar.ProjectsAssignees__r) {
					
						if(UserInfo.getUserId() == item.User__r.id){
							this.canAccess = true;
						}
						else{
						}
					}
				}
			}
		}
	}

    /**
    * Cancel Changes
    * @return PageReference
    */
    public PageReference CancelEdit () {
		PageReference pageRef = new PageReference('/apex/ProjectTaskDetail');
		pageRef.getParameters().put('id', this.taskId);
        pageRef.setRedirect(true);
		return pageRef;	
	}
    
    /**
	* Save changes and redirect
	* @return PageReference
	*/
	public PageReference SaveEditAndExit () {
		this.taskVar.notes__c = taskNotes;
		update this.taskVar;
		
		PageReference pageRef = new PageReference('/apex/ProjectTaskDetail');
		pageRef.getParameters().put('id', this.taskId);
        pageRef.setRedirect(true);
		return pageRef;
	}
	
	/**
	* Save changes
	* @return PageReference
	*/
	public PageReference SaveEdit () {
		this.taskVar.notes__c = taskNotes;
		update this.taskVar;
		return null;
	}
}