/**
*@author Nicolas Gunther - 25/03/2009
*/
public class ProjectRedirectController {
    
	public String pageName = System.currentPageReference().getParameters().get('page');
	public String editId = System.currentPageReference().getParameters().get('eid');
	public String taskId = System.currentPageReference().getParameters().get('task');

	/**
	* Constructor
	*/
    public ProjectRedirectController (){}   

    /**
    * Read namespace
    *@return string namespace
    */
    public String getNamespace(){
        return ProjectUtil.getNamespace();
    }
    
    /**
    * Read if current user is sys admin
    *@return page reference to new/edit page (without modify form layout)
    */
    public PageReference isAdmin(){
		
		User admin = new User();
		PageReference pr = null;
		String userId = UserInfo.getUserId();

		//Is admin User
		admin = [Select id, Profile.PermissionsModifyAllData, ProfileId, Name From User where id =: userId limit 1];    
    	
    	//Non admin users can't modify layout
    	// ### Redirect always ###
    	if(!admin.Profile.PermissionsModifyAllData){
    		
    		//ApexPage Name
    		String url = pageName;
    		
    		//project Id
    		if(editId != null)
    			url += '?id=' + editId;
    		
    		//task Id	
    		if(taskId != null){
    			url += '&task=' + taskId;
    		}
    		
    		//Forward to page
    		pr = new PageReference('/apex/' + url);
    		pr.setRedirect(true);
    	}
    	
    	return pr;
    }

}