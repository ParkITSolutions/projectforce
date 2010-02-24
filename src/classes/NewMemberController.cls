/*
* @author Nicolas Dominguez
*/
public class NewMemberController {
	
	public String projectId;
	public Boolean emailNotifications 	{ set; get; }
	public Boolean isAdministrator 		{ set; get; }
	public String colleagueNames		{ set; get; }
	public String projectName			{ set; get; }
	public String postAction 	    	{ set; get; }
	public String listErrors 	    	{ set; get; }
	public List<User> mailList;
	
	/**
	* Constructor
	*/
	public NewMemberController(){
		this.mailList = null;
	}
	
	

	public void action(){
		
		this.mailList 							= new List<User>();
		List<ProjectMember__c> newMemberList 	= new List<ProjectMember__c>();
		List<String> newMembers 				= colleagueNames.split( '[ ]*,[ ]*' );
		
		if( !newMembers.isEmpty() ){
			//Find de users (where the user is not a member)
			List<User>  userList = DAOFactory.getInstance().findUserNotMember( newMembers , this.projectId );
			
			Map<String,Id> projectProfile = DAOFactory.getInstance().idProjectProfile();

			if( !userList.isEmpty() )
			{
				
				Map<String,String> auxMap = new Map<String,String>{};

				for( User user : userList ){
					ProjectMember__c newMember = new ProjectMember__c();
					newMember.User__c 		= user.Id;
					newMember.Name 			= user.Name;
					newMember.Project__c 	= this.projectId;
					
					auxMap.put( user.Name,user.Name );		
		
					Id idProfile = null;
					if( isAdministrator )
					{
						idProfile = projectProfile.get( 'Project Administrator' );
					}
					else
					{
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
					this.postAction = 'NewMemberSuccess';
				}
				else{
					//Some users were not admitted
					String stringAux='';
					for( String str : newMembers ){
						if( str != '' &&  str != null && auxMap.get(str) != str )
							stringAux += ', ' + str;
					}
					
					this.listErrors = stringAux;
					this.postAction = 'NewMemberPartialSuccess';
				}
			}
			else{
				//Empty or invalid users
				this.postAction = 'NewMemberEmptyWithError';
				this.listErrors = colleagueNames;
			}
		}
		else {
			//must enter at least one user
			this.postAction = 'NewMemberEmpty';
		}
		this.colleagueNames='';
	}

	/**
	* Load Project Name
	* @return projectName
	*/
	public void loadProjectName(){
		this.projectName = ProjectUtil.chopWords( ProjectUtil.chopPhrase( DAOFactory.getInstance().getProjectInfo( this.projectId ).name , 24 ));
	}

	/**
	* Send mail to new members
	*/
	public void sendMails(){
		String message = 'You Have Been Added to ' + this.projectName;
		for( User user: this.mailList ){
			SendMail( user,message );
		}
	}
	
	public void setProjectId( String value ){
		this.projectId = value;
		this.loadProjectName();
	}
	
	public String getProjectId(){
		return this.projectId;
	}
	/**
	* Send mail to new members
	* @param user
	* @param message
	*/
	public void SendMail( User user, String message ){
		
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        String subject = message;
       
        String[] toAddresses = new String[] {user.Email};
 		// Assign the addresses for the To and CC lists to the mail object.
		mail.setToAddresses( toAddresses );
		// Specify the address used when the recipients reply to the email.
		mail.setReplyTo( 'forwardtosfdc@gmail.com' );
		// Specify the name used as the display name.
		mail.setSenderDisplayName( user.Name );
		// Specify the subject line for your email address.
		mail.setSubject( subject );
		// Set to True if you want to BCC yourself on the email.
		mail.setBccSender( false );
		// Optionally append the salesforce.com email signature to the email.
		// The email address of the user executing the Apex Code will be used.
		mail.setUseSignature( true );
		// Specify the html version of the content as well.
		message = ( message == null ) ? '' : message;
		mail.setHtmlBody( message );
		// Send the email you have created.
        Messaging.sendEmail( new Messaging.SingleEmailMessage[] { mail } );
    }
}