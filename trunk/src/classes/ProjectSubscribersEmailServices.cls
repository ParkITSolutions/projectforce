/**
*@author Miguel Soares de Lima @ 03/09/2009
*/
public class ProjectSubscribersEmailServices {

    //E-mail services instance
    private Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    private List<ProjectSubscription__c> subscriptions = new List<ProjectSubscription__c>();
    public Boolean isTaskEdit = false;  
    public Boolean isTest = false;
	public static Boolean alreadySent = false;
	 
    /**
    * Constructor (def)
    */
    public ProjectSubscribersEmailServices(){}

    /**
    *@param Boolean isTest
    */
    public void setIsTest ( Boolean isTest ) 
    {
        this.isTest = isTest;   
    }
    
    /**
    *@param Boolean
    */
    public void setIsTaskEdit ( Boolean isTaskEdit ){
        this.isTaskEdit = isTaskEdit;
    }

    /**
    *@Send meail to subscribers
    */
    public void sendMemberJoinLeave( List<String> lstPMId, String acction )
    {
        String emailMsj = '';
        String emailSub = '';

        if ( acction == 'join' || acction == 'leave' ) 
        {   
            List<ProjectMember__c> lstPM = new  List<ProjectMember__c>();    
            lstPM = [ SELECT Id, Project__c, User__c, Project__r.Name, User__r.Name FROM ProjectMember__c WHERE Id in : lstPMId ];
            if (!isTest)
            subscriptions = [ SELECT User__c, User__r.Id, User__r.Name, User__r.Email, Project__c, Project__r.Name, ProjectMemberJoinLeave__c, ProjectTaskAssignedToMe__c, ProjectTaskChanged__c, ProjectTaskDeleted__c FROM ProjectSubscription__c WHERE Project__c =: lstPM[0].Project__c and ProjectMemberJoinLeave__c = true ];
            for(ProjectMember__c proj : lstPM ){
	            if ( acction == 'leave') 
	            {
	                String oldMemberName = proj.User__r.Name;
	                emailMsj = oldMemberName + ' has left project  <a href="' + Label.sfdcHostName+'apex/ProjectDetail?id='+ proj.Project__c + + '">' +  proj.Project__r.Name + '</a>.';
	                emailSub = 'Project Member has Left the project ';
	            }
	            else 
	            {
	                emailMsj = 'A new project member has joined project <a href="' + Label.sfdcHostName+'apex/ProjectDetail?id='+ proj.Project__c +'">' +  proj.Project__r.Name + '</a>. Please welcome ' + proj.User__r.Name + ' to the project.';
	                emailSub = 'New Project Member';
	            }
	            
				if( subscriptions.size() > 0)	
	            genAddress( subscriptions, emailMsj, emailSub );
            }
        }
    }

    /**
    *@Send mail to subscribers
    */
    public void sendMailForTaskAssigned( List<String> lstPAId )
    {
        String emailMsj = '';
        String emailSub = ''; 
        List<String> lstUserId = new  List<String>();   

        List<ProjectAssignee__c> lstPA = new  List<ProjectAssignee__c>();    
        lstPA = [ SELECT Id, Project__c, Project__r.Name, User__r.Name, User__c, 
        ProjectTask__c, ProjectTask__r.Name, ProjectTask__r.Description__c, ProjectTask__r.EndDate__c, ProjectTask__r.StartDate__c, ProjectTask__r.Priority__c FROM ProjectAssignee__c WHERE Id in : lstPAId ];
     
        string pId='';
        List<ProjectTask__c> ptL = [SELECT Project__c from ProjectTask__c where id=:lstPA[0].ProjectTask__c];
       	if (ptL.size() > 0) {
       		pId=ptL[0].Project__c;
       	}

        for(ProjectAssignee__c proj : lstPA){
	        //Sub:{Task Name} has been assigned to you
	        //Body: {Task Details such as name and description and start and end date}      
	        emailMsj = 'Project Name: <a href="' + Label.sfdcHostName +'apex/ProjectDetail?id='+ proj.Project__c + '">' + proj.Project__r.Name + '</a><br />Task Name: <a href="' + Label.sfdcHostName+'apex/projecttaskdetail?id='+proj.ProjectTask__c + '">' + proj.ProjectTask__r.Name + '</a><br />Priority: ' + proj.ProjectTask__r.Priority__c + '<br />Start date: ' + proj.ProjectTask__r.StartDate__c + '<br />End date: ' + proj.ProjectTask__r.EndDate__c + '<br />Description: ' + (( proj.ProjectTask__r.Description__c == null ) ? '' : proj.ProjectTask__r.Description__c);
	        emailSub = proj.ProjectTask__r.Name + ' has been assigned to you';
	
	        lstUserId.add(proj.user__c);

        }
           
        if (!isTest){
          	 subscriptions = [ SELECT User__c, User__r.Id, User__r.Name, User__r.Email, Project__c, Project__r.Name, ProjectMemberJoinLeave__c, ProjectTaskAssignedToMe__c, ProjectTaskChanged__c, ProjectTaskDeleted__c FROM ProjectSubscription__c WHERE  Project__c =: lstPA[0].Project__c and ProjectTaskAssignedToMe__c = true and User__c in : lstUserId ];
         }
    	if( subscriptions.size() > 0){	
    	        genAddress( subscriptions, emailMsj, emailSub );
		}  
	  } 
    

    /**
    *@Send mail to subscribers
    */
   public void sendMailForTaskChanged( List<String> lstPTId )
    {
        String emailMsj = '';
        String emailSub = '';

        List<String> lstUserId = new  List<String>();  
        
        List<ProjectTask__c> lstPT = new  List<ProjectTask__c>();    
        lstPT = [ SELECT Id, Project__c, Project__r.Name, Name, Description__c, EndDate__c, StartDate__c, Priority__c FROM ProjectTask__c WHERE Id in : lstPTId ];
        
        List<String> SubAssignees = new List<String>();

        //System.debug('\n\n//////////////////////////\n  lstAssId: ' +  lstPTId + '\n//////////////////////////\n\n');
        System.debug('\n\n//////////////////////////\n  pas : ' + lstPT + '\n//////////////////////////\n\n');
        System.debug('\n\n//////////////////////////\n  pas[0] : ' + lstPT[0] + '\n//////////////////////////\n\n');
           
        if (lstPT.size()>0){
        	
            for (ProjectAssignee__c a :[select id, user__c from ProjectAssignee__c where ProjectTask__c =: lstPT[0].id]){
        		SubAssignees.add(a.user__c);
            }
  	        //Sub:{Task Name} has been updated
	        //Body: {Task Details such as name and description and start and end date}      
	        emailMsj = 'Project Name: <a href="' + Label.sfdcHostName +'apex/ProjectDetail?id='+ lstPT[0].Project__r.Id + '">' + lstPT[0].Project__r.Name + '</a><br />Task Name: <a href="' + Label.sfdcHostName+'apex/projecttaskdetail?id='+lstPT[0].id+ '">' + lstPT[0].Name + '</a><br />Priority: ' + lstPT[0].Priority__c + '<br />Start date: ' + lstPT[0].StartDate__c + '<br />End date: ' + lstPT[0].EndDate__c + '<br />Description: ' + lstPT[0].Description__c;
	        emailSub = lstPT[0].Name + ' has been updated';

	        if (!isTest){
	            subscriptions = [ SELECT User__c, User__r.Id, User__r.Name, User__r.Email, Project__c, Project__r.Name, ProjectMemberJoinLeave__c, ProjectTaskAssignedToMe__c, ProjectTaskChanged__c, ProjectTaskDeleted__c FROM ProjectSubscription__c WHERE  Project__c =: lstPT[0].Project__c  and User__r.Id!=:UserInfo.getUserId() and ProjectTaskAssignToMeChanged__c = true and user__c in :SubAssignees];
	        }
	    	if( subscriptions.size() > 0){	
	    	     genAddress( subscriptions, emailMsj, emailSub );
			}        
        }
    }


    /**
    *@Send mail to subscribers
    */
   public void sendMailForTaskPercentChanged( List<String> lstPTId ){   
   	
  		Map<String,ProjectTask__c> BaseMap=ProjectUtil.BaseMap;
    
        Double OldPercent=BaseMap.get(lstPTId[0]).PercentCompleted__c;
        String OldStatus=BaseMap.get(lstPTId[0]).Status__c;
     
        String emailMsj = '';
        String emailSub = '';

        List<String> lstUserId = new  List<String>();  
        
        List<ProjectTask__c> lstPT = new  List<ProjectTask__c>();    
        lstPT = [ SELECT Id, Project__c, Project__r.Name, Name, Description__c, EndDate__c, StartDate__c, Priority__c,PercentCompleted__c,Status__c FROM ProjectTask__c WHERE Id in : lstPTId ];
        
        List<String> SubAssignees = new List<String>();

          
        if ((lstPT.size()>0)&&(oldPercent!=lstPT[0].PercentCompleted__c)){
            for (ProjectAssignee__c a :[select id, user__c from ProjectAssignee__c where ProjectTask__c =: lstPT[0].id]){
        		SubAssignees.add(a.user__c);
            }
  	        //Sub:{Task Name} percent completed changed
	        //Body: {Task Details such as name and description and start and end date}      
	        emailMsj = 'Project Name: <a href="' + Label.sfdcHostName +'apex/ProjectDetail?id='+ lstPT[0].Project__r.Id + '">' + lstPT[0].Project__r.Name + '</a><br />Task Name: <a href="' + Label.sfdcHostName+'apex/projecttaskdetail?id='+lstPT[0].id+ '">' + lstPT[0].Name + '</a><br />Priority: ' + lstPT[0].Priority__c + '<br />Start date: ' + lstPT[0].StartDate__c + '<br />End date: ' + lstPT[0].EndDate__c + '<br />Description: ' + lstPT[0].Description__c+'<br /><br />The percent completed has changed from '+oldPercent+' to '+lstPT[0].PercentCompleted__c;
        	emailSub = lstPT[0].Name + ' percent completed changed';


	        if (!isTest){
	            subscriptions = [ SELECT User__c, User__r.Id, User__r.Name, User__r.Email, Project__c, Project__r.Name, ProjectMemberJoinLeave__c, ProjectTaskAssignedToMe__c, ProjectTaskChanged__c, ProjectTaskDeleted__c FROM ProjectSubscription__c WHERE  Project__c =: lstPT[0].Project__c   and ProjectTaskChanged__c = true and user__c in :SubAssignees];
	        }
	    	if( subscriptions.size() > 0){	
	    	     genAddress( subscriptions, emailMsj, emailSub );
			}        
        }
    }

    /**
    *@Send mail to subscribers
    */
    public void sendMailForTaskDeleted( List<String> lstTasksId )
    {
        String emailMsj = '';
        String emailSub = '';
        List<ProjectTask__c> lstTask = new  List<ProjectTask__c>();    
        lstTask = [ SELECT Id, Project__c, Project__r.Name, Name, Description__c, EndDate__c, StartDate__c, Priority__c FROM ProjectTask__c WHERE Id  in : lstTasksId ];
        if (!isTest){
	        subscriptions = [ SELECT User__c, User__r.Id, User__r.Name, User__r.Email, Project__c, Project__r.Name, ProjectMemberJoinLeave__c, ProjectTaskAssignedToMe__c, ProjectTaskChanged__c, ProjectTaskDeleted__c FROM ProjectSubscription__c WHERE Project__c =: lstTask[0].Project__c and ProjectTaskDeleted__c = true ];
        }
        for(ProjectTask__c proj : lstTask){
	        //Sub:{Task Name} has been deleted from {Project Name}
	        //Body: {Task Details such as name and description and start and end date}      
	        emailMsj = 'Project Name: <a href="' + Label.sfdcHostName +'apex/ProjectDetail?id='+ proj.Project__r.id + '">' + proj.Project__r.Name + '</a><br />Priority: ' + proj.Priority__c + '<br />Start date: ' + proj.StartDate__c + '<br />End date: ' + proj.EndDate__c + '<br />Description: ' + proj.Description__c;
	        emailSub = proj.Name + ' has been deleted from '+proj.Project__r.Name;
	
			if( subscriptions.size() > 0)	
	        genAddress( subscriptions, emailMsj, emailSub );
        }
    }
	public void sendMailForAssDeleted( List<String> lstAssId ){
        String emailMsj = '';
        String emailSub = '';
		List<ProjectAssignee__c> pAs = new List<ProjectAssignee__c>();
		
        List<String> lstUserId = new  List<String>();   		
		
		pAs = [ SELECT Id,User__c,ProjectTask__r.Project__c, ProjectTask__c, Project__c, Project__r.Name, ProjectTask__r.Name, ProjectTask__r.Description__c, 
		ProjectTask__r.EndDate__c, ProjectTask__r.StartDate__c, ProjectTask__r.Priority__c FROM ProjectAssignee__c WHERE Id in: lstAssId ];

        string pId='';
        List<ProjectTask__c> ptL = [SELECT Project__c from ProjectTask__c where id=:pas[0].ProjectTask__c];
       	if (ptL.size() > 0) {
       		pId=ptL[0].Project__c;
       	}

        
        
        if (pAs.size()>0){
				for( ProjectAssignee__c pA : pAs ){
			        emailMsj = 'Project Name: <a href="' + Label.sfdcHostName +'apex/ProjectDetail?id='+ pA.Project__c + '">' + pA.Project__r.Name + '</a><br />Task Name: <a href="' + Label.sfdcHostName+'apex/projecttaskdetail?id='+pA.ProjectTask__c + '">' + pA.ProjectTask__r.Name + '</a><br />Priority: ' + pA.ProjectTask__r.Priority__c + '<br />Start date: ' + pA.ProjectTask__r.StartDate__c + '<br />End date: ' + pA.ProjectTask__r.EndDate__c + '<br />Description:' + pA.ProjectTask__r.Description__c;
			        emailSub = 'You were unassigned from the task ' + pA.ProjectTask__r.Name + '.';			    
				    lstUserId.add(pA.user__c);
				}
				if(!isTest){
			    	subscriptions = [ SELECT User__c, User__r.Id, User__r.Name, User__r.Email, Project__c, Project__r.Name, ProjectTaskAssignToMeChanged__c FROM ProjectSubscription__c WHERE Project__c =: pId and ProjectTaskAssignedToMe__c = true and User__c in : lstUserId ];
		        }	
				if( subscriptions.size() > 0){
		    	    genAddress( subscriptions, emailMsj, emailSub );
				}
        }
	}

    public void genAddress( List<ProjectSubscription__c> subscriptions, String emailMsj, String emailSub )
    {
    	
        //Array address
        String[] address = new String[]{}; 
        Integer it = 0;
        if( subscriptions.size() > 10){
	        for(Integer i =0; i < subscriptions.size(); i++ ){   
	            if(it < 10 || i == subscriptions.size() )
	            {
	                address.add(subscriptions[i].User__r.Email);
	                it ++;
	            }
	            else
	            {
	                SendMail(address, subscriptions[0].Project__r, emailMsj, emailSub);
	                it = 0;
	            }
	        }
        }else if(subscriptions.size() > 0 && subscriptions != null)
	        {   
	            for( ProjectSubscription__c ts : subscriptions ){
	            	address.add(ts.User__r.Email);
	            }
	            SendMail(address, subscriptions[0].Project__r, emailMsj, emailSub);
	        }   
    }

    
    /**
    * SEND MAIL
    *@param String[] e-mails Array
    *@param Team__c team
    *@param String message
    *@param String subject
    */
   
    public void SendMail(String[] toAddresses , Project2__c team,  String Message, String subject) {
        // Assign thsetReplyToe addresses for the To and CC lists to the mail object.
        mail.setToAddresses(toAddresses);
        // Specify the address used when the recipients reply to the email.
        mail.setReplyTo('forwardtosfdc@gmail.com');
        // Specify the name used as the display name.
        mail.setSenderDisplayName('Team Subscribe');  
        //Specify the subject line for your email address.
        mail.setSubject(subject);
        //mail.setSenderDisplayName( team.Name );
        // Set to True if you want to BCC yourself on the email.
        mail.setBccSender(false);
        // Optionally append the salesforce.com email signature to the email.
        // The email address of the user executing the Apex Code will be used.
        mail.setUseSignature(true); 
        //Set Content Mail
        mail.setHtmlBody(Message);
        // Send the email you have created.
   
        if(!ProjectSubscribersEmailServices.alreadySent)
            Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
        //ProjectSubscribersEmailServices.alreadySent = true;
    }
}