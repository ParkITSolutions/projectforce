/**
*@author Bruno Fagundez @ 10/06/2008
*/
global class FlexWebService {   
        
    public UserPermissions userPermissions = new UserPermissions();
    
    /**
    * Load permissions for one user for some project
    *@param String project id
    *@param Stirng user id
    */
    public void genPermissions (String projectId, String userId) {
        userPermissions.setId(userId);
        userPermissions.setProject(projectId);
        userPermissions.setObjectType('Project');
        userPermissions.setPermissions();       
    }
    
    /**
    * Generate permissions for one user for some project
    *@static
    *@param String project id
    *@param Stirng user id
    */
    webservice static String generatePermissions (String user, String project) {
        UserPermissions userPermissions = new UserPermissions();
        userPermissions.setId(user);
        userPermissions.setProject(project);
        userPermissions.setObjectType('Project');
        userPermissions.setPermissions();
        
        String canCreate = 'false';
        String canManage = 'false';
        
        if(userPermissions.getCanCreate())
            canCreate = 'true';
        if(userPermissions.getCanManage())
            canManage = 'true';
            
        //String to return
        String userPermissionsString = canCreate+'|'+canManage;
        return userPermissionsString; 
    }
}