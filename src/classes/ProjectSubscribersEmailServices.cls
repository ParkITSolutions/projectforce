/**
*@author Miguel Soares de Lima @ 03/09/2009
*/
public class ProjectSubscribersEmailServices{

	private static ProjectSubscribersEmailServices instance = null;

    //E-mail services instance
    private Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    private List<ProjectSubscription__c> subscriptions = new List<ProjectSubscription__c>();
    private List<ProjectSubscription__c> subscriptions2 = new List<ProjectSubscription__c>();
    public Boolean isTaskEdit = false;  
    public Boolean isTest = false;
    
	public static Boolean alreadySent = false;
	
    /**
    * Constructor
    */ 
    private ProjectSubscribersEmailServices(){}
    
    public static ProjectSubscribersEmailServices getInstance(){
    	if( instance == null )
    		instance = new ProjectSubscribersEmailServices();
    	
    	return instance;
    }

    /**
    *@param Boolean isTest
    *@return void
    */
    public void setIsTest ( Boolean isTest ) 
    {
        this.isTest = isTest;   
    }
    
    /**
    *@param Boolean isTaskEdit
    *@return void
    */
    public void setIsTaskEdit ( Boolean isTaskEdit ){
        this.isTaskEdit = isTaskEdit;
    }


	///////////////////////////////////////////////////////////////////////////////////////////////////
	//Html
	private String returnHtmlIni(String varHtmlIni){
		//String varHtmlIni = '';
		varHtmlIni=varHtmlIni+'<html>';
		varHtmlIni=varHtmlIni+'<head>';
		varHtmlIni=varHtmlIni+'	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">';
		varHtmlIni=varHtmlIni+'	<title>Project Mail</title>';
		varHtmlIni=varHtmlIni+'	<style type="text/css" media="screen">';
		varHtmlIni=varHtmlIni+'		body {';
		varHtmlIni=varHtmlIni+'			margin: 0;';
		varHtmlIni=varHtmlIni+'			padding: 0;';
		varHtmlIni=varHtmlIni+'		}';
		varHtmlIni=varHtmlIni+'		a {';
		varHtmlIni=varHtmlIni+'			color: #cc0000;';
		varHtmlIni=varHtmlIni+'		}';
		varHtmlIni=varHtmlIni+'		.opcion {';
		varHtmlIni=varHtmlIni+'			font-family: Georgia;';
		varHtmlIni=varHtmlIni+'			font-size: 12px;';
		varHtmlIni=varHtmlIni+'			font-weight: bold;';
		varHtmlIni=varHtmlIni+'			color: #000000;';
		varHtmlIni=varHtmlIni+'			margin: 0 0 4px 0;';
		varHtmlIni=varHtmlIni+'			padding: 0;';
		varHtmlIni=varHtmlIni+'		}';
		varHtmlIni=varHtmlIni+'		.header_project{';
		varHtmlIni=varHtmlIni+'			background-image: url(/img/bgTop.gif);';
		varHtmlIni=varHtmlIni+'			background-position: left top;';
		varHtmlIni=varHtmlIni+'			background-repeat: repeat-x;';
		varHtmlIni=varHtmlIni+'		}';
		varHtmlIni=varHtmlIni+'		.page_section {';
		varHtmlIni=varHtmlIni+'			top:0;';
		varHtmlIni=varHtmlIni+'			left:0;	';
		varHtmlIni=varHtmlIni+'			/*background:url(section_icon.gif) no-repeat left top;*/';
		varHtmlIni=varHtmlIni+'			color:#FFFFFF;';
		varHtmlIni=varHtmlIni+'		}';
		varHtmlIni=varHtmlIni+'		.header_portal {';
		varHtmlIni=varHtmlIni+'			background:#004D6B none repeat scroll 0 0;';
		varHtmlIni=varHtmlIni+'			height: 58px;';
		varHtmlIni=varHtmlIni+'			position:relative;';
		varHtmlIni=varHtmlIni+'			width:100%;';
		varHtmlIni=varHtmlIni+'			display: block;';
		varHtmlIni=varHtmlIni+'			overflow: hidden;';
		varHtmlIni=varHtmlIni+'		}';
		varHtmlIni=varHtmlIni+'		';
		varHtmlIni=varHtmlIni+'		.tit1{';
		varHtmlIni=varHtmlIni+'			color:#004D63;';
		varHtmlIni=varHtmlIni+'			font-style:italic;';
		varHtmlIni=varHtmlIni+'		}';
		varHtmlIni=varHtmlIni+'		.tit2{';
		varHtmlIni=varHtmlIni+'			color:#9C928C;';
		varHtmlIni=varHtmlIni+'			font-style:italic;';
		varHtmlIni=varHtmlIni+'		}';
		varHtmlIni=varHtmlIni+'';
		varHtmlIni=varHtmlIni+'		';
		varHtmlIni=varHtmlIni+'	</style>';
		varHtmlIni=varHtmlIni+'</head>';
		varHtmlIni=varHtmlIni+'<body>';
		varHtmlIni=varHtmlIni+'<table width="600" cellspacing="0" cellpadding="0" border="0">';
		varHtmlIni=varHtmlIni+'	<tr>';
		varHtmlIni=varHtmlIni+'		<td>';
		varHtmlIni=varHtmlIni+'			<table width="600" cellspacing="0" cellpadding="0" border="0" style="margin-left: 40px; margin-right: 40px; margin-top: 10px; margin-bottom: 20px;">';
		varHtmlIni=varHtmlIni+'				<tr>';
		varHtmlIni=varHtmlIni+'					<td class="header_project" align="center"> ';
		varHtmlIni=varHtmlIni+'						<div style="background: rgb(255, 247, 255) none repeat scroll 0% 0%; height: 55px; -moz-background-clip: -moz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-policy: -moz-initial;">';
		varHtmlIni=varHtmlIni+'						<h1>';
		varHtmlIni=varHtmlIni+'						<font class="tit1">Project</font><font class="tit2">force</font>';
		varHtmlIni=varHtmlIni+'						</h1>';
		varHtmlIni=varHtmlIni+'						</div>';
		varHtmlIni=varHtmlIni+'					</td>';
		varHtmlIni=varHtmlIni+'				</tr>';
		varHtmlIni=varHtmlIni+'				<tr>';
		varHtmlIni=varHtmlIni+'					<td align="center">';
		varHtmlIni=varHtmlIni+'						<div class="header_portal">';
		varHtmlIni=varHtmlIni+'							<div class="page_section">';
		varHtmlIni=varHtmlIni+'								<h1 alt="pepe asd efeee gue hay qeu no se">pepe asd.. </h1>';
		varHtmlIni=varHtmlIni+'							</div>';
		varHtmlIni=varHtmlIni+'						</div>';
		varHtmlIni=varHtmlIni+'					</td>';
		varHtmlIni=varHtmlIni+'				</tr>';
		varHtmlIni=varHtmlIni+'				<tr>';
		varHtmlIni=varHtmlIni+'					<td>';
		varHtmlIni=varHtmlIni+'						&nbsp;';
		varHtmlIni=varHtmlIni+'					</td>';
		varHtmlIni=varHtmlIni+'				</tr>';
		varHtmlIni=varHtmlIni+'				<tr>';
		varHtmlIni=varHtmlIni+'					<td>';
		varHtmlIni=varHtmlIni+'						&nbsp;';
		varHtmlIni=varHtmlIni+'					</td>';
		varHtmlIni=varHtmlIni+'				</tr>';
		varHtmlIni=varHtmlIni+'				<tr>';
		varHtmlIni=varHtmlIni+'					<td> ';
		varHtmlIni=varHtmlIni+'						<table width="90%" align="center" border="0" cellspacing="0" cellpadding="0">';
		varHtmlIni=varHtmlIni+'							<tr>';
		return varHtmlIni;
	}

	private String returnHtmlFin(String varHtmlIni,String pie){
		//String  varHtmlIni= '';
		varHtmlIni=varHtmlIni+'							</tr>';
		varHtmlIni=varHtmlIni+'							<tr>';
		varHtmlIni=varHtmlIni+'								<td>';
		varHtmlIni=varHtmlIni+'									&nbsp;';
		varHtmlIni=varHtmlIni+'								</td>';
		varHtmlIni=varHtmlIni+'							</tr>';
		varHtmlIni=varHtmlIni+'							<tr>';
		varHtmlIni=varHtmlIni+'								<td>';
		varHtmlIni=varHtmlIni+'									&nbsp;';
		varHtmlIni=varHtmlIni+'								</td>';
		varHtmlIni=varHtmlIni+'							</tr>';
		varHtmlIni=varHtmlIni+'							';
		varHtmlIni=varHtmlIni+'						</table>';
		varHtmlIni=varHtmlIni+'					</td>';
		varHtmlIni=varHtmlIni+'				</tr>';
		if (pie != ''){
			varHtmlIni=varHtmlIni+'				<tr><td>'+pie;
			varHtmlIni=varHtmlIni+'				</td></tr>';
		}
		varHtmlIni=varHtmlIni+'			</table>';
		varHtmlIni=varHtmlIni+'		</td>';
		varHtmlIni=varHtmlIni+'	</tr>';
		varHtmlIni=varHtmlIni+'</table>';
		varHtmlIni=varHtmlIni+'</body>';
		varHtmlIni=varHtmlIni+'</html>';
		return varHtmlIni;
	}
	
/*	private String returnVarHtml(String titulo, String campo){
		
	}*/
	///////////////////////////////////////////////////////////////////////////////////////////////////
	
    /**
    * Sends email to subscribers
    *@param List<String> lstPMId
    *@param String action
    *@return void
    */
    public void sendMemberJoinLeave( List<String> lstPMId, String acction )
    {
        String emailMsj = '';
        String emailSub = '';

        if ( acction == 'join' || acction == 'leave' ) 
        {   
            List<ProjectMember__c> lstPM = new  List<ProjectMember__c>();    
            lstPM = [ SELECT Id, Project__c, User__c, Project__r.Name, User__r.Name 
            			FROM ProjectMember__c 
            			WHERE Id in : lstPMId ];
            if (!isTest)
            subscriptions = [ SELECT User__c, User__r.Id, User__r.Name, User__r.Email, Project__c, 
            					Project__r.Name, ProjectMemberJoinLeave__c, ProjectTaskAssignedToMe__c, 
            					ProjectTaskChanged__c, ProjectTaskDeleted__c 
            					FROM ProjectSubscription__c 
            					WHERE Project__c =: lstPM[0].Project__c and ProjectMemberJoinLeave__c = true ];
            					
            for(ProjectMember__c proj : lstPM ){
	            if ( acction == 'leave') 
	            {
	                String oldMemberName = proj.User__r.Name;
	                emailMsj = oldMemberName + ' has left project  <a href="' 
	                			+ Label.sfdcHostName+'apex/ProjectDetail?id='+ proj.Project__c + + '">' 
	                			+  proj.Project__r.Name + '</a>.';
	                emailSub = 'Project Member has Left the project ';
	            }
	            else 
	            {
	                emailMsj = 'A new project member has joined project <a href="' 
	                			+ Label.sfdcHostName+'apex/ProjectDetail?id='+ proj.Project__c +'">' 
	                			+  proj.Project__r.Name + '</a>. Please welcome ' + proj.User__r.Name 
	                			+ ' to the project.';
	                emailSub = 'New Project Member';
	            }
	            
				if( subscriptions.size() > 0)	
	            genAddress( subscriptions, emailMsj, emailSub );
            }
        }
    }

    /**
    * Send mail to subscribers
    *@param List<String> lstPAId
    *@return void
    */
    public void sendMailForTaskAssigned( List<String> lstPAId )
    {
        String emailMsj = '';
        String emailSub = ''; 
        List<String> lstUserId = new  List<String>();   

        List<ProjectAssignee__c> lstPA = new  List<ProjectAssignee__c>();    
        lstPA = [ SELECT Id, Project__c, Project__r.Name, User__r.Name, User__c, ProjectTask__c, 
        			ProjectTask__r.Name, ProjectTask__r.Description__c, ProjectTask__r.EndDate__c, 
        			ProjectTask__r.StartDate__c, ProjectTask__r.Priority__c 
        			FROM ProjectAssignee__c 
        			WHERE Id in : lstPAId ];
     
        string pId='';
        List<ProjectTask__c> ptL = new List<ProjectTask__c>();
        if( lstPA.size() > 0 ){
	        ptL = [SELECT Project__c from ProjectTask__c where id =: lstPA[0].ProjectTask__c];
	       	if (ptL.size() > 0) 
	       		pId=ptL[0].Project__c;
        }

        for(ProjectAssignee__c proj : lstPA){
	        //Sub:{Task Name} has been assigned to you
	        //Body: {Task Details such as name and description and start and end date}      
	        emailMsj = 'Project Name: <a href="' + Label.sfdcHostName +'apex/ProjectDetail?id='
	        			+ proj.Project__c + '">' + proj.Project__r.Name + '</a><br />Task Name: <a href="' 
	        			+ Label.sfdcHostName+'apex/projecttaskdetail?id='+proj.ProjectTask__c + '">' 
	        			+ proj.ProjectTask__r.Name + '</a><br />Priority: ' 
	        			+ proj.ProjectTask__r.Priority__c + '<br />Start date: ' 
	        			+ proj.ProjectTask__r.StartDate__c + '<br />End date: ' 
	        			+ proj.ProjectTask__r.EndDate__c + '<br />Description: ' 
	        			+ (( proj.ProjectTask__r.Description__c == null ) ? '' : proj.ProjectTask__r.Description__c);
	        emailSub = proj.ProjectTask__r.Name + ' has been assigned to you';
	
	        lstUserId.add(proj.user__c);

        }
           
        if (!isTest ){
          	 subscriptions = [ SELECT User__c, User__r.Id, User__r.Name, User__r.Email, Project__c, 
          	 					Project__r.Name, ProjectMemberJoinLeave__c, ProjectTaskAssignedToMe__c, 
          	 					ProjectTaskChanged__c, ProjectTaskDeleted__c 
          	 					FROM ProjectSubscription__c 
          	 					WHERE  Project__c =: lstPA[0].Project__c and ProjectTaskAssignedToMe__c = true and User__c in : lstUserId ];
         }
    	if( subscriptions.size() > 0){	
    	        genAddress( subscriptions, emailMsj, emailSub );
		}  
	  } 
    

    /**
    * Send mail to subscribers
    *@param List<String> lstPTId
    *@return void
    */
   public static void sendMailForTaskChangedFuture( List<String> lstPTId ){
   		ProjectSubscribersEmailServices m = new ProjectSubscribersEmailServices();
   		m.sendMailForTaskChanged( lstPTId );
   }
   
    /**
    * Send mail to subscribers
    *@param List<String> lstPTId
    *@return void
    */
   public  void sendMailForTaskChanged( List<String> lstPTId )
    {
        String emailMsj = '';
        String emailSub = '';

        List<String> lstUserId = new  List<String>();  
        
        List<ProjectTask__c> lstPT = new  List<ProjectTask__c>();    
        lstPT = [ SELECT Id, Project__c, Project__r.Name, Name, Description__c, EndDate__c, 
        			StartDate__c, Priority__c 
        			FROM ProjectTask__c 
        			WHERE Id in : lstPTId ];
        
        List<String> SubAssignees = new List<String>();
        if (lstPT.size()>0 ){
            for (ProjectAssignee__c a :[select id, user__c 
            								from ProjectAssignee__c 
            								where ProjectTask__c =: lstPT[0].id]){
        		SubAssignees.add(a.user__c);
            }
  	        //Sub:{Task Name} has been updated
	        //Body: {Task Details such as name and description and start and end date}      
	        emailMsj = 'Project Name: <a href="' + Label.sfdcHostName +'apex/ProjectDetail?id='
	        			+ lstPT[0].Project__r.Id + '">' + lstPT[0].Project__r.Name + '</a><br />Task Name: <a href="' 
	        			+ Label.sfdcHostName+'apex/projecttaskdetail?id='+lstPT[0].id+ '">' + lstPT[0].Name 
	        			+ '</a><br />Priority: ' + lstPT[0].Priority__c + '<br />Start date: ' 
	        			+ lstPT[0].StartDate__c + '<br />End date: ' + lstPT[0].EndDate__c 
	        			+ '<br />Description: ' + lstPT[0].Description__c;
	        emailSub = lstPT[0].Name + ' has been updated';

	        if (!isTest){
	            subscriptions = [ SELECT User__c, User__r.Id, User__r.Name, User__r.Email, Project__c, 
	            					Project__r.Name, ProjectMemberJoinLeave__c, ProjectTaskAssignedToMe__c, 
	            					ProjectTaskChanged__c, ProjectTaskDeleted__c 
	            					FROM ProjectSubscription__c 
	            					WHERE  Project__c =: lstPT[0].Project__c  and User__r.Id!=:UserInfo.getUserId() and ProjectTaskAssignToMeChanged__c = true and user__c in :SubAssignees];
	        }
	    	if( subscriptions.size() > 0){	
	    	     genAddress( subscriptions, emailMsj, emailSub );
			}        
        }
    }
    
     /**
    * Send mail to subscribers
    *@param List<String> lstPTId
    *@return void
    */
   public void sendMailForTaskStatusChanged( List<String> lstPTId )
    {
        String emailMsj = '';
        String emailSub = '';

        List<String> lstUserId = new  List<String>();  
        
        List<ProjectTask__c> lstPT = new  List<ProjectTask__c>();    
        lstPT = [ SELECT Id, Project__c, Project__r.Name, Name, Description__c, EndDate__c, 
        			StartDate__c, Priority__c 
        			FROM ProjectTask__c 
        			WHERE Id in : lstPTId ];
        
        List<String> SubAssignees = new List<String>();
        if (lstPT.size()>0){
            for (ProjectAssignee__c a :[select id, user__c 
            								from ProjectAssignee__c 
            								where ProjectTask__c =: lstPT[0].id]){
        		SubAssignees.add(a.user__c);
            }
  	        //Sub:{Task Name} has been updated
	        //Body: {Task Details such as name and description and start and end date}      
	        emailMsj = 'Project Name: <a href="' + Label.sfdcHostName +'apex/ProjectDetail?id='
	        			+ lstPT[0].Project__r.Id + '">' + lstPT[0].Project__r.Name + '</a><br />Task Name: <a href="' 
	        			+ Label.sfdcHostName+'apex/projecttaskdetail?id='+lstPT[0].id+ '">' + lstPT[0].Name 
	        			+ '</a><br />Priority: ' + lstPT[0].Priority__c + '<br />Start date: ' 
	        			+ lstPT[0].StartDate__c + '<br />End date: ' + lstPT[0].EndDate__c 
	        			+ '<br />Description: ' + lstPT[0].Description__c;
	        emailSub = lstPT[0].Name + ' has been updated its status';

	        if (!isTest){
	            subscriptions = [ SELECT User__c, User__r.Id, User__r.Name, User__r.Email, Project__c, 
	            					Project__r.Name, ProjectMemberJoinLeave__c, ProjectTaskAssignedToMe__c, 
	            					ProjectTaskChanged__c, ProjectTaskDeleted__c 
	            					FROM ProjectSubscription__c 
	            					WHERE  Project__c =: lstPT[0].Project__c  
	            					AND User__r.Id!=:UserInfo.getUserId() 
	            					AND ProjectTaskChanged__c = true];
	        }
	    	if( subscriptions.size() > 0){	
	    	     genAddress( subscriptions, emailMsj, emailSub );
			}       
        }
    }


    /**
    * Send mail to subscribers
    *@aram List<String> lstPTId
    *@return void
    */
    public static void sendMailForTaskPercentChangedFuture( List<String> lstPTId, List<String> statuses, List<String> percents ){   
    	ProjectUtil.inFuture = true;
		ProjectSubscribersEmailServices m = new ProjectSubscribersEmailServices();
		m.sendMailForTaskPercentChanged( lstPTId, statuses, percents ); 
	}   
	
	public void sendMailForTaskPercentChanged( List<String> lstPTId, List<String> statuses, List<String> percents  ){   
   	
  		Map<String,ProjectTask__c> BaseMap=ProjectUtil.BaseMap;
        String OldStatus=statuses[0];//BaseMap.get(lstPTId[0]).Status__c;
        Double OldPercent=Double.valueOf(percents[0]);////BaseMap.get(lstPTId[0]).PercentCompleted__c;
     
        String emailMsj = '';
        String emailSub = '';

        List<String> lstUserId = new  List<String>();  
        
        List<ProjectTask__c> lstPT = new  List<ProjectTask__c>();    
        lstPT = [ SELECT Id, Project__c, Project__r.Name, Name, Description__c, EndDate__c, StartDate__c, 
        			Priority__c,PercentCompleted__c,Status__c 
        			FROM ProjectTask__c 
        			WHERE Id in : lstPTId ];
        
        List<String> SubAssignees = new List<String>();

          
        if ((lstPT.size()>0)&&(oldPercent!=lstPT[0].PercentCompleted__c)){
            for (ProjectAssignee__c a :[select id, user__c from ProjectAssignee__c 
            								where ProjectTask__c =: lstPT[0].id]){
        		SubAssignees.add(a.user__c);
            }
  	        //Sub:{Task Name} percent completed changed
	        //Body: {Task Details such as name and description and start and end date}      
	        emailMsj = 'Project Name: <a href="' + Label.sfdcHostName +'apex/ProjectDetail?id='
	        			+ lstPT[0].Project__r.Id + '">' + lstPT[0].Project__r.Name + '</a><br />Task Name: <a href="' 
	        			+ Label.sfdcHostName+'apex/projecttaskdetail?id='+lstPT[0].id+ '">' 
	        			+ lstPT[0].Name + '</a><br />Priority: ' + lstPT[0].Priority__c + '<br />Start date: ' 
	        			+ lstPT[0].StartDate__c + '<br />End date: ' + lstPT[0].EndDate__c + '<br />Description: ' 
	        			+ lstPT[0].Description__c+'<br /><br />The percent completed has changed from '+oldPercent
	        			+' to '+lstPT[0].PercentCompleted__c;
	      //  */
	        /////////
	        /*
	        emailMsj = 'Project Name: <a href="' + Label.sfdcHostName +'apex/ProjectDetail?id='
	        			+ lstPT[0].Project__r.Id + '">' + lstPT[0].Project__r.Name + '</a><br />';
	        			
	        			'Task Name: <a href="' + Label.sfdcHostName+'apex/projecttaskdetail?id='+lstPT[0].id+ '">' 
	        			+ lstPT[0].Name + '</a><br />';
	        			'Priority: ' + lstPT[0].Priority__c + '<br />';
	        			'Start date: ' 	+ lstPT[0].StartDate__c + '<br />';
	        			'End date: ' + lstPT[0].EndDate__c + '<br />';
	        			'Description: '	+ lstPT[0].Description__c+'<br /><br />
	        			
	        			The percent completed has changed from '+oldPercent
	        			+' to '+lstPT[0].PercentCompleted__c;
	        */
	        /////////
        	emailSub = lstPT[0].Name + ' percent completed changed';
        	
	        if (!isTest){
	            subscriptions = [ SELECT User__c, User__r.Id, User__r.Name, User__r.Email, Project__c, 
	            					Project__r.Name, ProjectMemberJoinLeave__c, ProjectTaskAssignedToMe__c, 
	            					ProjectTaskChanged__c, ProjectTaskDeleted__c 
	            					FROM ProjectSubscription__c 
	            					WHERE  Project__c =: lstPT[0].Project__c   and ProjectTaskChanged__c = true];
	             
	        }
	        
	    	if( subscriptions.size() > 0){	
	    	     genAddress( subscriptions, emailMsj, emailSub );
			}        
        }
    }

    /**
    *Send mail to subscribers
    *@param List<String> lstTaskId
    *@return void
    */
    public void sendMailForTaskDeleted( List<String> lstTasksId )
    {	
        String emailMsj = '';
        String emailSub = '';
        List<ProjectTask__c> lstTask = new  List<ProjectTask__c>();    
        lstTask = [ SELECT Id, Project__c, Project__r.Name, Name, Description__c, EndDate__c, 
        				StartDate__c, Priority__c 
        				FROM ProjectTask__c 
        				WHERE Id  in : lstTasksId ];
        if (!isTest){
	        subscriptions = [ SELECT User__c, User__r.Id, User__r.Name, User__r.Email, 
	        					Project__c, Project__r.Name, ProjectMemberJoinLeave__c, 
	        					ProjectTaskAssignedToMe__c, ProjectTaskChanged__c, ProjectTaskDeleted__c 
	        					FROM ProjectSubscription__c 
	        					WHERE Project__c =: lstTask[0].Project__c and ProjectTaskDeleted__c = true ];
        }
        for(ProjectTask__c proj : lstTask){
	        //Sub:{Task Name} has been deleted from {Project Name}
	        //Body: {Task Details such as name and description and start and end date}      
	        emailMsj = 'Project Name: <a href="' + Label.sfdcHostName +'apex/ProjectDetail?id='
	        			+ proj.Project__r.id + '">' + proj.Project__r.Name + '</a><br />Priority: ' 
	        			+ proj.Priority__c + '<br />Start date: ' + proj.StartDate__c + '<br />End date: ' 
	        			+ proj.EndDate__c + '<br />Description: ' + proj.Description__c;
	        emailSub = proj.Name + ' has been deleted from '+proj.Project__r.Name;
	
			if( subscriptions.size() > 0)	
	        genAddress( subscriptions, emailMsj, emailSub );
        }
    }
    
    /*s*
    *@param List<String> lstAssId
    *@return void
    */
    @future
    public static void sendMailForAssDeletedFuture( List<String> lstAssId, List<String> taskIdList, List<String> usersIdList ){
    	
    	ProjectSubscribersEmailServices i = new ProjectSubscribersEmailServices();
    	i.sendMailForAssDeleted( lstAssId, taskIdList, usersIdList );
    }
    
    /**
    *@param List<String> lstAssId
    *@return void
    */
	public void sendMailForAssDeleted( List<String> lstAssId, List<String> taskIdList, List<String> usersIdList ){
        String emailMsj = '';
        String emailSub = '';
		List<ProjectTask__c> tasks = new List<ProjectTask__c>();
		
        List<String> lstUserId = new  List<String>();   		
		
		tasks = [ SELECT Id, Project__c, name, description__c, endDate__c, startDate__c, priority__c, project__r.name FROM ProjectTask__c WHERE id in: taskIdList];
		
        
        if ((tasks.size()>0) && !(ProjectUtil.DeleteTaskMailSent)){
		        string pId = tasks[0].project__c;
				for( ProjectTask__c t : tasks ){
			        emailMsj = 'Project Name: <a href="' + Label.sfdcHostName +'apex/ProjectDetail?id='
			        		+ t.Project__c + '">' + t.Project__r.Name + '</a><br />Task Name: <a href="' 
			        		+ Label.sfdcHostName+'apex/projecttaskdetail?id='+t.id + '">' 
			        		+ t.Name + '</a><br />Priority: ' + t.Priority__c 
			        		+ '<br />Start date: ' + t.StartDate__c + '<br />End date: ' 
			        		+ t.EndDate__c + '<br />Description:' + t.Description__c;
			        
			        emailSub = 'You were unassigned from the task ' + t.Name + '.';			    
				}
				if(!isTest){
			    	subscriptions = [ SELECT User__c, User__r.Id, User__r.Name, User__r.Email, Project__c, 
			    						Project__r.Name, ProjectTaskAssignToMeChanged__c 
			    						FROM ProjectSubscription__c 
			    						WHERE Project__c =: pId and ProjectTaskAssignedToMe__c = true and User__c in : usersIdList ];
		        }	
				if( subscriptions.size() > 0){
		    	    genAddress( subscriptions, emailMsj, emailSub );
				}
        }
        ProjectUtil.DeleteTaskMailSent=false;
	}

   /**
    *@param List<ProjectSubscription__c> subscriptions
    *@param String emailMsj
    *@param String emailSub
    *@return void
    */
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
    *@return void
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