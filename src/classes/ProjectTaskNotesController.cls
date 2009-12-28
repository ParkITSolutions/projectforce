/**
*@author Nicolas Dominguez @ 21/12/2009
*/

public class ProjectTaskNotesController {

	private ProjectTask__c taskVar { set; get; }
	public String taskId { set; get; }
	public String taskNotes { set; get; }
	public String taskName { set; get; }
	public String taskNameShort { set; get; }

	public String projectId { set; get; }
	public String projectName { set; get; }
	public String projectNameShort { set; get; }
	
	/**
    * Constructor
    * @param ApexPages.StandardController
    */
    public ProjectTaskNotesController(ApexPages.StandardController ctrl){
    	
		this.taskVar = new ProjectTask__c();
		this.obtainData();
    }
    
    /**
    * Obtain data from the task and project
    * @return void	
    */
	public void obtainData(){
		
		this.taskId=System.currentPageReference().getParameters().get('id_task');
		List<ProjectTask__c> taskList = new List<ProjectTask__c>();

		taskList = [Select p.Id,p.Project__c,p.Project__r.Name, p.Name, p.notes__c From ProjectTask__c p where p.Id =: taskId limit 1];
		if (taskList.size() > 0 ) {
			this.taskVar=taskList[0];
			if (this.taskVar != null){
				this.projectId=this.taskVar.Project__c;
				this.projectName=this.taskVar.Project__r.Name;
				//I cut out the name if too long
				this.projectNameShort=ProjectUtil.chopWords( ProjectUtil.chopPhrase( this.projectName , 24 ));
				
				this.taskName=this.taskVar.Name;
				//I cut out the name if too long
				this.taskNameShort=ProjectUtil.chopWords( ProjectUtil.chopPhrase( this.taskName , 24 ));
				
				this.taskNotes=this.taskVar.notes__c;
			}
		}
	}

    /**
    * @return PageReference
    */
    public PageReference CancelEdit () {
		System.debug('XXX - sin terminar...');
		return null;	
	}
    
    /**
	* Save changes and redirect
	* @return PageReference
	*/
	public PageReference SaveEdit () {
		this.taskVar.notes__c = taskNotes;
		update this.taskVar;
		return null;
	}
	
	
}