/**
* @author Bruno Fagundez
* @createdDate 10/06/2008
*/
global class FlexWebService {   
        
    public UserPermissions userPermissions = new UserPermissions();
    
    /**
    * Load permissions for one user for some project
    * @param project id
    * @param user id
    */
    public void genPermissions (String projectId, String userId) {
        userPermissions.setId(userId);
        userPermissions.setProject(projectId);
        userPermissions.setObjectType('Project');
        userPermissions.setPermissions();       
    }
    
    /**
    * Generate permissions for one user for some project
    * @param project id
    * @param user id
    * @return userPermissions
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
            
        String userPermissionsString = canCreate+'|'+canManage;
        return userPermissionsString; 
    }
    
    /**
    * Test FlexWebService
    */
    public static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
    	
    	FlexWebService  fw = new FlexWebService();
    	
    	fw.genPermissions( GenerateEnvironmentTest.project.id, GenerateEnvironmentTest.user.id );
    	FlexWebService.generatePermissions( GenerateEnvironmentTest.user.id, GenerateEnvironmentTest.project.id );
    	
    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    }     	
}