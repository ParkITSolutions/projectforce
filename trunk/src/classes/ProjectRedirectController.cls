/**
*@author Nicolas Gunther - 25/03/2009
*/
public class ProjectRedirectController {
    
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
    *@return pr to form page (without modify form layout)
    */
    public PageReference isAdmin(){
		User admin = new User();
		PageReference pr = null;
		String userId = UserInfo.getUserId();
		String pageName = System.currentPageReference().getParameters().get('page');
		String editId = System.currentPageReference().getParameters().get('eid');
		admin = [Select id, Profile.PermissionsModifyAllData, ProfileId, Name From User where id =: userId limit 1];    
    	if(!admin.Profile.PermissionsModifyAllData){
    		String url = (editId == null) ? pageName : pageName + '?id=' + editId;
    		pr = new PageReference('/apex/' + url);
    		pr.setRedirect(true);
    	}
    	return pr;
    }

}