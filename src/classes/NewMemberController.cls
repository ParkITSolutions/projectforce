/*
* @author Nicolas Dominguez
*/
public with Sharing class NewMemberController {
    
    public String projectId;
    public Boolean  isProduction        { set; get; }
    public Boolean emailNotifications   { set; get; }
    public Boolean isAdministrator      { set; get; }
    public String colleagueNames        { set; get; }
    public String projectName           { set; get; }
    public String postAction            { set; get; }
    public String listErrors            { set; get; }
    public List<User> mailList;
    
    /**
    * Constructor
    */
    public NewMemberController(){
        this.isProduction   = ProjectUtil.isProduction;
        this.mailList       = null;
    }
    
    /**
    * Action Method which inserts the new Member
    */
    public void action(){
        
        this.mailList                           = new List<User>();
        List<ProjectMember__c> newMemberList    = new List<ProjectMember__c>();
        String pageName                         = '';
        
        //discriminate by page
        if( System.currentPageReference().getUrl().contains( 'ProjectDetail' ) ){
            pageName = 'ProjectDetail-';
        }   
        if( System.currentPageReference().getUrl().contains( 'ProjectTaskDetail' ) ){
            pageName = 'ProjectTaskDetail-';
        }
        if( System.currentPageReference().getUrl().contains( 'MembersList' ) ){
            pageName = 'MembersList-';
        }
        
        if( ( colleagueNames != '' ) & ( colleagueNames != null ) ){
            List<String> newMembers = colleagueNames.split( '[ ]*,[ ]*' );

            //Find de users (where the user is not a member)
            List<User> userList = DAOFactory.getInstance().findUserNotMember( newMembers , this.projectId );
            
            Map<String,Id> projectProfile = DAOFactory.getInstance().idProjectProfile();

            if( !userList.isEmpty() ) {
                
                Map<String,String> auxMap = new Map<String,String>{};

                for( User user : userList ){
                    ProjectMember__c newMember = new ProjectMember__c();
                    newMember.User__c       = user.Id;
                    newMember.Name          = user.Name;
                    newMember.Project__c    = this.projectId;
                    
                    auxMap.put( user.Name,user.Name );      
        
                    Id idProfile = null;
                    if( isAdministrator ){
                        idProfile = projectProfile.get( 'Project Administrator' );
                    }
                    else{
                        idProfile = projectProfile.get( 'Member Profile' );
                    }
        
                    newMember.Profile__c = idProfile; 
                    newMemberList.add( newMember );
        
                    //If Email Notification is selected
                    if( emailNotifications ){
                        this.mailList.add( user );
                    }
                }
                
                //insert newMemberList;
                DAOFactory.getInstance().newMemberList( newMemberList );
                
                if( emailNotifications ){
                    this.sendMails();
                }
                
                if ( userList.size() == newMembers.size() ){
                    //Ok
                    this.postAction = pageName+'NewMemberSuccess';
                }
                else{
                    //Some users were not admitted
                    String stringAux = '';
                    for( String str : newMembers ){
                        if( str != '' &&  str != null && auxMap.get(str) != str )
                            stringAux += ', ' + str;
                    }
                    
                    this.listErrors = stringAux;
                    this.postAction = pageName+'NewMemberPartialSuccess';
                }
            }
            else{
                //Empty or invalid users
                this.postAction = pageName+'NewMemberEmptyWithError';
                this.listErrors = colleagueNames;
            }
            
            this.colleagueNames='';
        }
        else{
            //the same for all
            this.postAction = 'All-NewMemberEmpty';
        }
    }

    /**
    * Load Project Name
    * @return projectName
    */
    public void loadProjectName(){
        this.projectName = ProjectUtil.chopWords( ProjectUtil.chopPhrase( DAOFactory.getInstance().getProjectInfo( this.projectId ).name , 24 ) );
    }

    /**
    * Send mail to new members
    */
    public void sendMails(){
        String message = 'You Have Been Added to ' + this.projectName;
        for( User user: this.mailList ){
            SendMail( user, message );
        }
    }
    
    /**
    * 
    */
    public void setProjectId( String value ){
        this.projectId = value;
        this.loadProjectName();
    }
    
    /**
    * 
    */
    public String getProjectId(){
        return this.projectId;
    }
    
    /**
    * Send mail to new members
    * @param user
    * @param message
    */
    public void SendMail( User user, String message )
    {
        String[] toAddresses = new String[] {user.Email};
        ProjectSubscribersEmailServices.getInstance().newMemberEmail(toAddresses , this.projectName); 
    }
    
    /**
    * Test new member overlay component
    */
    static testMethod void myUnitTest(){
        
        GenerateEnvironmentTest.gen();
        ProjectUtil.setIsTest( true );
        Test.startTest();
        
        Test.setCurrentPageReference( new PageReference( 'Page.ProjectDetail' ) );
        NewMemberController newMember = new NewMemberController();
        
        newMember.setProjectId( GenerateEnvironmentTest.project.Id );
        newMember.getProjectId();
        newMember.loadProjectName();
        
        newMember.colleagueNames        = 'Miguel Soares';
        newMember.emailNotifications    = true;
        newMember.isAdministrator       = false;
        newMember.action();
       // System.assertEquals( 'ProjectDetail-NewMemberSuccess', newMember.postAction );
        
        newMember.colleagueNames        = 'Nicolas Dominguez';
        newMember.emailNotifications    = true;
        newMember.isAdministrator       = true;
        newMember.action();
        //System.assertEquals( 'ProjectDetail-NewMemberSuccess', newMember.postAction );
        
        newMember.colleagueNames        = 'Nicolas Dominguez, Miguel Soares, Nicolas Dodssminguez';
        newMember.emailNotifications    = false;
        newMember.isAdministrator       = false;
        newMember.action();
        //System.assertEquals( 'ProjectDetail-NewMemberEmptyWithError', newMember.postAction );
        
        newMember.colleagueNames        = 'Andres Canavesi, Miguel Soares, Nicolas Dodssminguez';
        newMember.emailNotifications    = false;
        newMember.isAdministrator       = false;
        newMember.action();
        //System.assertEquals( 'ProjectDetail-NewMemberPartialSuccess', newMember.postAction );
        
        newMember.colleagueNames        = '';
        newMember.emailNotifications    = false;
        newMember.isAdministrator       = false;
        newMember.action();
        //System.assertEquals( 'All-NewMemberEmpty', newMember.postAction );
        
        newMember = new NewMemberController();
        newMember.setProjectId( GenerateEnvironmentTest.project2.Id );
        newMember.getProjectId();
        newMember.loadProjectName();
        
        Test.setCurrentPageReference( new PageReference( 'Page.MembersList' ) );
        newMember = new NewMemberController();
        newMember.setProjectId( GenerateEnvironmentTest.project2.Id );
        newMember.getProjectId();
        newMember.loadProjectName();
        newMember.action();
        
        Test.setCurrentPageReference( new PageReference( 'Page.ProjectTaskDetail' ) );
        newMember = new NewMemberController();
        newMember.setProjectId( GenerateEnvironmentTest.project2.Id );
        newMember.getProjectId();
        newMember.loadProjectName();
        newMember.action();
        
        Test.stopTest();
        ProjectUtil.setIsTest( false );
    }
}