/*
*@author Nicolas Dominguez @ 29/01/2010
*/
public with sharing class QuickLinksWidgetController {
    
    public Boolean isProduction 			{ set; get; }
    public String projectId;
    public UserPermissions userPermission   { set; get; }
    public Boolean canView                 	{ set; get; }

    /**
    * Constructor
    */
    public QuickLinksWidgetController(){
    	this.isProduction	= ProjectUtil.isProduction;
    }
    
    /**
    * Load permission for current user
    */
    private void genPermissions(){
        userPermission.setId(UserInfo.getUserId());
        userPermission.setProject(this.projectId);
        userPermission.setObjectType('Project');
        userPermission.setPermissions();
        //If is member or canmanage
        this.canView = userPermission.isUserMemberOfProject( UserInfo.getUserId() , this.projectId ) || userPermission.getCanManage();
    }
    
    public void setProjectId( String value ){
		//To pass bug of apex
		this.projectId 		= value;
		this.userPermission = new UserPermissions(); 
		this.genPermissions();
	}
	
	public String getProjectId(){
		return this.projectId;
	}
	
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
    	
    	QuickLinksWidgetController qLk = new QuickLinksWidgetController();
    	qLk.setProjectId( GenerateEnvironmentTest.project.id );
    	qLk.getProjectId();
    	qLk.userPermission = qLk.userPermission; 
    	qLk.canView = qLk.canView;
    	
    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    }	
}