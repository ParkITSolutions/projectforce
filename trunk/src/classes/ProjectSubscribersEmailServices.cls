/**
*@author Miguel Soares de Lima @ 09/03/2009
*/
public class ProjectSubscribersEmailServices {

    //E-mail services instance
    private Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    private List<ProjectSubscription__c> subscriptions = new List<ProjectSubscription__c>();
    
    public Boolean isTaskEdit = false;  
    public Boolean isTest = false;

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
    public void sendMemberJoinLeave( String pM, String acction )
    {
        String emailMsj = '';
        String emailSub = '';

        if ( acction == 'join' || acction == 'leave' ) 
        {   
            ProjectMember__c proj = new  ProjectMember__c();    
            proj = [ SELECT Id, Project__c, User__c, Project__r.Name, User__r.Name, Project__r.Id FROM ProjectMember__c WHERE Id =: pM ];
            
            if ( acction == 'leave') 
            {
                String oldMemberName = proj.User__r.Name;
                emailMsj = oldMemberName + ' has left project  <a href="' + Label.sfdcHostName + proj.Project__c + '">' +  proj.Project__r.Name + '</a>.';
                emailSub = 'Project Member has Left the project ';
            }
            else 
            {
                emailMsj = 'A new project member has joined project <a href="' + Label.sfdcHostName + proj.Project__c + '">' +  proj.Project__r.Name + '</a>. Please welcome ' + proj.User__r.Name + ' to the project.';
                emailSub = 'New Project Member';
            }

            if (!isTest)
            subscriptions = [ SELECT User__c, User__r.Id, User__r.Name, User__r.Email, Project__c, Project__r.Name, Project__r.Id, ProjectMemberJoinLeave__c, ProjectTaskAssignedToMe__c, ProjectTaskChanged__c, ProjectTaskDeleted__c FROM ProjectSubscription__c WHERE Project__c =: proj.Project__r.Id and ProjectMemberJoinLeave__c = true ];

            genAddress( subscriptions, emailMsj, emailSub );
        }
    }

    /**
    *@Send meail to subscribers
    */
   
    public void sendMailForTaskAssifned( String idAssignee )
    {
        String emailMsj = '';
        String emailSub = '';

        ProjectAssignee__c proj = new  ProjectAssignee__c();    
        proj = [ SELECT Id, Project__c, Project__r.Name, User__r.Name, User__c, 
        ProjectTask__c, ProjectTask__r.Name, ProjectTask__r.Description__c, ProjectTask__r.EndDate__c, ProjectTask__r.StartDate__c, ProjectTask__r.Priority__c FROM ProjectAssignee__c WHERE Id =: idAssignee ];
        
        
        //Sub:{Task Name} has been assigned to you
        //Body: {Task Details such as name and description and start and end date}      
        emailMsj = 'Task Name: <a href="' + Label.sfdcHostName + proj.ProjectTask__c + '">' + proj.ProjectTask__r.Name + '</a><br />Priority: ' + proj.ProjectTask__r.Priority__c + '<br />Start date: ' + proj.ProjectTask__r.StartDate__c + '<br />End date: ' + proj.ProjectTask__r.EndDate__c + '<br />Description: <br /><br />' + proj.ProjectTask__r.Description__c;
        emailSub = proj.ProjectTask__r.Name + ' has been assigned to you';

        if (!isTest)
        subscriptions = [ SELECT User__c, User__r.Id, User__r.Name, User__r.Email, Project__c, Project__r.Name, Project__r.Id, ProjectMemberJoinLeave__c, ProjectTaskAssignedToMe__c, ProjectTaskChanged__c, ProjectTaskDeleted__c FROM ProjectSubscription__c WHERE Project__c =: proj.Project__c and User__c =: proj.User__c and ProjectTaskAssignedToMe__c = true ];

        genAddress( subscriptions, emailMsj, emailSub );
    }
    

    /**
    *@Send meail to subscribers
    */
    public void sendMailForTaskChaged( String idTask )
    {
        String emailMsj = '';
        String emailSub = '';

        ProjectTask__c proj = new  ProjectTask__c();    
        proj = [ SELECT Id, Project__c, Project__r.Name, Name, Description__c, EndDate__c, StartDate__c, Priority__c FROM ProjectTask__c WHERE Id =: idTask ];
        
        
        //Sub:{Task Name} has been assigned to you
        //Body: {Task Details such as name and description and start and end date}      
        emailMsj = 'Task Name: <a href="' + Label.sfdcHostName + proj.Id + '">' + proj.Name + '</a><br />Priority: ' + proj.Priority__c + '<br />Start date: ' + proj.StartDate__c + '<br />End date: ' + proj.EndDate__c + '<br />Description: <br /><br />' + proj.Description__c;
        emailSub = proj.Name + ' has been updated';

        if (!isTest)
        subscriptions = [ SELECT User__c, User__r.Id, User__r.Name, User__r.Email, Project__c, Project__r.Name, Project__r.Id, ProjectMemberJoinLeave__c, ProjectTaskAssignedToMe__c, ProjectTaskChanged__c, ProjectTaskDeleted__c FROM ProjectSubscription__c WHERE Project__c =: proj.Project__c and ProjectTaskChanged__c = true ];

        genAddress( subscriptions, emailMsj, emailSub );
    }

    /**
    *@Send meail to subscribers
    */
    public void sendMailForTaskDeleted( String idTask )
    {
        String emailMsj = '';
        String emailSub = '';

        ProjectTask__c proj = new  ProjectTask__c();    
        proj = [ SELECT Id, Project__c, Project__r.Name, Name, Description__c, EndDate__c, StartDate__c, Priority__c FROM ProjectTask__c WHERE Id =: idTask ];
        
        
        //Sub:{Task Name} has been assigned to you
        //Body: {Task Details such as name and description and start and end date}      
        emailMsj = 'Task Name:' + proj.Name + '<br />Priority: ' + proj.Priority__c + '<br />Start date: ' + proj.StartDate__c + '<br />End date: ' + proj.EndDate__c + '<br />Description: <br /><br />' + proj.Description__c;
        emailSub = proj.Name + ' has been deleted';

        if (!isTest)
        subscriptions = [ SELECT User__c, User__r.Id, User__r.Name, User__r.Email, Project__c, Project__r.Name, Project__r.Id, ProjectMemberJoinLeave__c, ProjectTaskAssignedToMe__c, ProjectTaskChanged__c, ProjectTaskDeleted__c FROM ProjectSubscription__c WHERE Project__c =: proj.Project__c and ProjectTaskDeleted__c = true ];

        genAddress( subscriptions, emailMsj, emailSub );
    }


    public void genAddress( List<ProjectSubscription__c> subscriptions, String emailMsj, String emailSub )
    {
        //Array address
        String[] address = new String[]{}; 
        Integer it = 0;
        if( subscriptions.size() > 10)
        for(Integer i =0; i < subscriptions.size(); i++ )   
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
        else 
        if(subscriptions.size() > 0 && subscriptions != null)
        {   
            for( ProjectSubscription__c ts : subscriptions )
            address.add(ts.User__r.Email);
    
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
    Boolean alreadySent = false;
    public void SendMail(String[] toAddresses , Project2__c team,  String Message, String subject) {
        // Assign thsetReplyToe addresses for the To and CC lists to the mail object.
        mail.setToAddresses(toAddresses);
        // Specify the address used when the recipients reply to the email.
        mail.setReplyTo('forwardtosfdc@gmail.com');
        // Specify the name used as the display name.
        mail.setSenderDisplayName('Team Subscribe');  
        //Specify the subject line for your email address.
        mail.setSubject(subject);

        mail.setSenderDisplayName(team.Name);
        // Set to True if you want to BCC yourself on the email.
        mail.setBccSender(false);
        // Optionally append the salesforce.com email signature to the email.
        // The email address of the user executing the Apex Code will be used.
        mail.setUseSignature(true); 
        //Set Content Mail
        mail.setHtmlBody(Message);
        // Send the email you have created.
        if(!alreadySent)
            Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
        alreadySent = true;
    }
}