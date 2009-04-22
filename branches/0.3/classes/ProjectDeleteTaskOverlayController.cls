/**
*@author Alvaro Scuccimarra @ 04/07/2009
*/
public class ProjectDeleteTaskOverlayController {
	
	private Id USERID = UserInfo.getUserId(); 
	private String idDeletes = '';
	private UserPermissions userPermissions = new UserPermissions();
	private String projectId = '';
		
	public ProjectDeleteTaskOverlayController(){} 
	 
	/**
    * Generate User Permissions
    */
    public void genPermissions () {
        userPermissions.setId(UserInfo.getUserId());
        userPermissions.setProject(projectId);
        userPermissions.setObjectType('Project');
        userPermissions.setPermissions();   
            
    }
    
    /**
    *@return idDeletes
    */
    public String getIdDeletes () {
        return idDeletes;   
    }
    
    /**
    *@param sidDeletes
    */
    public void setIdDeletes (String sidDeletes) {
        idDeletes = sidDeletes; 
    }
    
    
    public void deleteTaskFromList(){
    	deleteTask();	
    }
    
    public PageReference deleteTaskFromDetail(){
    	deleteTask();
       	PageReference pr = new PageReference('/apex/ProjectDetail?id=' + projectId);
        pr.setRedirect(true);
        return pr;
    }
    
    public void deleteTask(){
        List<String> myIds = new List<String>();
        if (idDeletes != '' && idDeletes != null){
            myIds = idDeletes.split(':'); 
        }
       
        if(myIds.size()>0){
            List<ProjectTask__c> tasksToDelete = [select (Select User__c from ProjectsAssignees__r ), id, Project__r.Id from ProjectTask__c where id in: myIds];
      		projectId = tasksToDelete[0].Project__r.Id;
      		genPermissions();
            if (tasksToDelete.size() > 0){
                List<ProjectTask__c> taskListToDelete = new List<ProjectTask__c>(); 
                for (ProjectTask__c iterTask : tasksToDelete){
                    Boolean cantEditAndDelete = false;
                    Integer countAssignee = 0;
                    while (!cantEditAndDelete && countAssignee < iterTask.ProjectsAssignees__r.size()){
                        if(iterTask.ProjectsAssignees__r[countAssignee].User__c != USERID){
                            cantEditAndDelete =  true;
                        }else {
                            countAssignee++;
                        }
                    }
                    if(!cantEditAndDelete || UserPermissions.getCanManage() || iterTask.createdById == USERID){
                        taskListToDelete.add(iterTask);
                    }else {
                        throw new CustomException('Insufficient Privileges');   
                    }
                   
                }
                if(taskListToDelete.size() > 0) {
                	delete taskListToDelete;
	            }
            }
        }
        idDeletes = '';
    }
    
}