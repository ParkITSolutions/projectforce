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
	/** 
	*	First part of the body of the mail html
	*	@param String varHtml
	*	@param String title 
	*/
	private String returnHtmlIni(String varHtmlIni, String title){
		varHtmlIni=varHtmlIni+'<html>';
		varHtmlIni=varHtmlIni+'<head>';
		varHtmlIni=varHtmlIni+'	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">';
		varHtmlIni=varHtmlIni+'	<title>Project Mail</title>';
		varHtmlIni=varHtmlIni+'	<style type="text/css" media="screen">';
		varHtmlIni=varHtmlIni+'		body {';
		varHtmlIni=varHtmlIni+'			margin: 0;';
		varHtmlIni=varHtmlIni+'			padding: 0;';
		varHtmlIni=varHtmlIni+'		}';
		//varHtmlIni=varHtmlIni+'		a {';
		//varHtmlIni=varHtmlIni+'			color: #FFFFFF !important;';
		//varHtmlIni=varHtmlIni+'		}';
		varHtmlIni=varHtmlIni+'		.header_project{';
		varHtmlIni=varHtmlIni+'			background-position: left top;';
		varHtmlIni=varHtmlIni+'			background-repeat: repeat-x;';
		varHtmlIni=varHtmlIni+'		}';
		varHtmlIni=varHtmlIni+'		.header_portal {';
		varHtmlIni=varHtmlIni+'			background:#004D6B none repeat scroll 0 0;';
		varHtmlIni=varHtmlIni+'			height: 58px;';
		varHtmlIni=varHtmlIni+'			position:relative;';
		varHtmlIni=varHtmlIni+'			width:100%;';
		varHtmlIni=varHtmlIni+'			display: block;';
		varHtmlIni=varHtmlIni+'			overflow: hidden;';
		varHtmlIni=varHtmlIni+'		}';
		varHtmlIni=varHtmlIni+'	</style>';
		varHtmlIni=varHtmlIni+'</head>';
		varHtmlIni=varHtmlIni+'<body>';
		varHtmlIni=varHtmlIni+'<table width="600" cellspacing="0" cellpadding="0" border="0">';
		varHtmlIni=varHtmlIni+'	<tr>';
		varHtmlIni=varHtmlIni+'		<td>';
		varHtmlIni=varHtmlIni+'			<table width="600" cellspacing="0" cellpadding="0" border="0" style="margin-left: 40px; margin-right: 40px; margin-top: 10px; margin-bottom: 20px;">';
		varHtmlIni=varHtmlIni+'				<tr>';
		varHtmlIni=varHtmlIni+'					<td class="header_project" align="center" span="2">';
		varHtmlIni=varHtmlIni+'						<div style="background: rgb(255, 247, 255) none repeat scroll 0% 0%; height: 55px;">';
		varHtmlIni=varHtmlIni+'						<span style="color:#004D63;font-style:italic;font-size:30px;">Project</span><span style="color:#9C928C;font-style:italic;font-size:30px;">force</span>';
		varHtmlIni=varHtmlIni+'						</div>';
		varHtmlIni=varHtmlIni+'					</td>';
		varHtmlIni=varHtmlIni+'				</tr>';
		varHtmlIni=varHtmlIni+'				<tr>';
		varHtmlIni=varHtmlIni+'					<td align="center" span="2">';
		varHtmlIni=varHtmlIni+'						<div style="background: #004D6B none repeat scroll 0% 0%; height: 55px;">';
		varHtmlIni=varHtmlIni+'							<div style="color:#FFFFFF;font-size: 22px;">'+title+'</div>';
		varHtmlIni=varHtmlIni+'						</div>';
		varHtmlIni=varHtmlIni+'					</td>';
		varHtmlIni=varHtmlIni+'				</tr>';
		varHtmlIni=varHtmlIni+'				<tr>';
		varHtmlIni=varHtmlIni+'					<td span="2">';
		varHtmlIni=varHtmlIni+'						&nbsp;';
		varHtmlIni=varHtmlIni+'					</td>';
		varHtmlIni=varHtmlIni+'				</tr>';
		varHtmlIni=varHtmlIni+'				<tr>';
		varHtmlIni=varHtmlIni+'					<td span="2">';
		varHtmlIni=varHtmlIni+'						&nbsp;';
		varHtmlIni=varHtmlIni+'					</td>';
		varHtmlIni=varHtmlIni+'				</tr>';
		varHtmlIni=varHtmlIni+'				<tr>';
		varHtmlIni=varHtmlIni+'					<td span="2"> ';
		varHtmlIni=varHtmlIni+'						<table width="90%" align="center" border="0" cellspacing="0" cellpadding="0">';
		return varHtmlIni;
	}

	/** 
	*	The fields part of  Html Mail 
	*	@param String varHtml
	*	@param String titleField
	*	@param String field  
	*	@return String
	*/
	private String returnVarHtml(String varHtmlIni, String titleField, String field){
		varHtmlIni=varHtmlIni+'							<tr>';
		if (titleField!=''){
			varHtmlIni=varHtmlIni+'							<td align="left" style="font-family: Georgia;font-size: 12px;font-weight: bold;color: #000000;margin: 0 0 4px 0;padding: 0;font-style:italic;" width="30%">';
			varHtmlIni=varHtmlIni+'								'+titleField;
			varHtmlIni=varHtmlIni+'							</td>';
			varHtmlIni=varHtmlIni+'							<td align="left">';
		}
		else{
			varHtmlIni=varHtmlIni+'							<td align="left" span="2">';
		}
		varHtmlIni=varHtmlIni+'									'+field;
		varHtmlIni=varHtmlIni+'								</td>';
		varHtmlIni=varHtmlIni+'							</tr>';
		return varHtmlIni;	
	}
	
	/** 
	*	Bottom of the HTML mail body
	*	@param String varHtml
	*	@param String msj  
	*	@return String
	*/
	private String returnHtmlFin(String varHtmlIni,String msj){
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
		if (msj != ''){
			varHtmlIni=varHtmlIni+'			<tr><td style="color:#000000; font-style:italic;" span="2">'+msj;
			varHtmlIni=varHtmlIni+'			</td></tr>';
		}
		varHtmlIni=varHtmlIni+'			</table>';
		varHtmlIni=varHtmlIni+'		</td>';
		varHtmlIni=varHtmlIni+'	</tr>';
		varHtmlIni=varHtmlIni+'</table>';
		varHtmlIni=varHtmlIni+'</body>';
		varHtmlIni=varHtmlIni+'</html>';
		return varHtmlIni;
	}
	
	/** 
	*	Return of subject of the Html Mail
	*	@param String project
	*	@param String action  
	*	@return String
	*/
	private String returnHtmlSubject(String project, String action){
		String aux = project.toUpperCase();
		String SubjectHtml='ProjectForce : ['+aux+'] '+action;
		return SubjectHtml;
		
	}
	
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
            	String htmlVar ='';
				String title='';
				String field='';
				String msjFoot='';
	            if ( acction == 'leave'){
					title=proj.Project__r.Name ;
					htmlVar=returnHtmlIni(htmlVar,title);
					
					field= proj.User__r.Name + ' has left project  <a href="'+ Label.sfdcHostName+'apex/ProjectDetail?id='+ proj.Project__c + '">'+  proj.Project__r.Name + '</a>.';
					htmlVar=returnVarHtml(htmlVar,'', field);
					htmlVar=returnHtmlFin(htmlVar,'');
					emailMsj=htmlVar;
					String Msg='Project Member has Left the project';
					emailSub=returnHtmlSubject(proj.Project__r.Name,Msg);
					
	            }
	            else {	                
	                title=proj.Project__r.Name;
					htmlVar=returnHtmlIni(htmlVar,title);
					
					field= 'A new project member has joined project <a href="' + Label.sfdcHostName+'apex/ProjectDetail?id='+ proj.Project__c +'">'+  proj.Project__r.Name + '</a>. Please welcome ' + proj.User__r.Name+ ' to the project.';
					htmlVar=returnVarHtml(htmlVar,'', field);
					htmlVar=returnHtmlFin(htmlVar,'');
					emailMsj=htmlVar;
					String Msg='New Project Member';
					emailSub=returnHtmlSubject(proj.Project__r.Name,Msg);
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
	
			String htmlVar ='';
			String title='';
			String field='';
			String msjFoot='';

			title='<a style="color:#FFFFFF;" href="' + Label.sfdcHostName +'apex/ProjectDetail?id='+ proj.Project__c + '">'+ proj.Project__r.Name + '</a>';
			htmlVar=returnHtmlIni(htmlVar,title);
			
			title='Task Name';
			field='<a href="'+ Label.sfdcHostName+'apex/projecttaskdetail?id='+proj.ProjectTask__c + '">'+ proj.ProjectTask__r.Name + '</a>';
			htmlVar=returnVarHtml(htmlVar, title, field);
			
			title='Priority';
			field=proj.ProjectTask__r.Priority__c;
			htmlVar=returnVarHtml(htmlVar, title, field);
			
			title='Start date';
			field=proj.ProjectTask__r.StartDate__c.format();
			htmlVar=returnVarHtml(htmlVar, title, field);
			
			title='End date';
			field='';
			if (proj.ProjectTask__r.EndDate__c != null)
				field=proj.ProjectTask__r.EndDate__c.format();
			htmlVar=returnVarHtml(htmlVar, title, field);
			
			title='Description';
			field=( proj.ProjectTask__r.Description__c == null ) ? '' : proj.ProjectTask__r.Description__c;
			htmlVar=returnVarHtml(htmlVar, title, field);
			
			msjFoot='You have been assigned to this task';
			htmlVar=returnHtmlFin(htmlVar,msjFoot);
			
			emailMsj=htmlVar;			
			String Msg='task '+ ProjectUtil.chopWords( ProjectUtil.chopPhrase( proj.ProjectTask__r.Name , 35 )) + ' has been assigned to you';
			emailSub=returnHtmlSubject(proj.Project__r.Name,Msg);
			
			
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
        
	        String htmlVar ='';
			String title='';
			String field='';
			String msjFoot='';
			
			title='<a style="color:#FFFFFF;" href="' + Label.sfdcHostName +'apex/ProjectDetail?id='+ lstPT[0].Project__r.Id + '">' + lstPT[0].Project__r.Name + '</a>';
			htmlVar=returnHtmlIni(htmlVar,title);
			
			title='Task Name';
			field='<a href="'+ Label.sfdcHostName+'apex/projecttaskdetail?id='+lstPT[0].id+ '">' + lstPT[0].Name+ '</a>';
			htmlVar=returnVarHtml(htmlVar, title, field);
			
			title='Priority';
			field=lstPT[0].Priority__c;
			htmlVar=returnVarHtml(htmlVar, title, field);
			
			title='Start date';
			field=lstPT[0].StartDate__c.format();
			htmlVar=returnVarHtml(htmlVar, title, field);
			
			title='End date';
			field='';
			if (lstPT[0].EndDate__c != null)
				field=lstPT[0].EndDate__c.format();
			htmlVar=returnVarHtml(htmlVar, title, field);
			
			
			title='End Descripcion';
			field=lstPT[0].Description__c;
			htmlVar=returnVarHtml(htmlVar, title, field);
			
			msjFoot='The task has been updated';
			htmlVar=returnHtmlFin(htmlVar,msjFoot);
			
			emailMsj=htmlVar;
			
			String Msg='task '+ ProjectUtil.chopWords( ProjectUtil.chopPhrase( lstPT[0].Name , 35 )) + ' has been updated';
			emailSub=returnHtmlSubject(lstPT[0].Project__r.Name,Msg);

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
        
	        String htmlVar ='';
			String title='';
			String field='';
			String msjFoot='';
			
			title='<a style="color:#FFFFFF;" href="' + Label.sfdcHostName +'apex/ProjectDetail?id='+ lstPT[0].Project__r.Id + '">' + lstPT[0].Project__r.Name + '</a>';
			htmlVar=returnHtmlIni(htmlVar,title);
			
			title='Task Name';
			field='<a href="'+ Label.sfdcHostName+'apex/projecttaskdetail?id='+lstPT[0].id+ '">' + lstPT[0].Name+ '</a>';
			htmlVar=returnVarHtml(htmlVar, title, field);
			
			title='Priority';
			field=lstPT[0].Priority__c;
			htmlVar=returnVarHtml(htmlVar, title, field);
			
			title='Start date';
			field=lstPT[0].StartDate__c.format();
			htmlVar=returnVarHtml(htmlVar, title, field);
			
			title='End date';
			field='';
			if (lstPT[0].EndDate__c != null)
				field=lstPT[0].EndDate__c.format();
			htmlVar=returnVarHtml(htmlVar, title, field);
			
			title='Description';
			field=lstPT[0].Description__c;
			htmlVar=returnVarHtml(htmlVar, title, field);
			
			msjFoot='The task has been updated';
			htmlVar=returnHtmlFin(htmlVar,msjFoot);
			
			emailMsj=htmlVar;
	        
	        String Msg='task '+ProjectUtil.chopWords( ProjectUtil.chopPhrase( lstPT[0].Name , 35 )) + ' has been updated its status';
			emailSub=returnHtmlSubject(lstPT[0].Project__r.Name,Msg);

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

	        String htmlVar ='';
	        String title='';
	        String field='';
	        String msjFoot='';
	        
	        title='<a style="color:#FFFFFF;" href="' + Label.sfdcHostName +'apex/ProjectDetail?id='+ lstPT[0].Project__r.Id + '">' + lstPT[0].Project__r.Name + '</a>';
	        htmlVar=returnHtmlIni(htmlVar,title);
	        
	        title='Task Name';
	        field='<a href="' + Label.sfdcHostName+'apex/projecttaskdetail?id='+lstPT[0].id+ '">'+ lstPT[0].Name + '</a>';
	        htmlVar=returnVarHtml(htmlVar, title, field);
	        
	        title='Priority';
	        field=lstPT[0].Priority__c;
	        htmlVar=returnVarHtml(htmlVar, title, field);
	        
	        title='Start date';
	        field=lstPT[0].StartDate__c.format();
	        htmlVar=returnVarHtml(htmlVar, title, field);
	        
	        title='End date';
	        field='';
			if (lstPT[0].EndDate__c != null)
				field=lstPT[0].EndDate__c.format();
	        htmlVar=returnVarHtml(htmlVar, title, field);
	        
	        title='Description';
	        field=lstPT[0].Description__c;
	        htmlVar=returnVarHtml(htmlVar, title, field);
	        
	        msjFoot='The percent completed from task has changed from '+oldPercent+' to '+lstPT[0].PercentCompleted__c;
	        htmlVar=returnHtmlFin(htmlVar,msjFoot);
	        emailMsj=htmlVar;

        	String Msg='task '+ProjectUtil.chopWords( ProjectUtil.chopPhrase( lstPT[0].Name , 35 )) + ' percent completed changed';
			emailSub=returnHtmlSubject(lstPT[0].Project__r.Name,Msg);
        	
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
	        
	        String htmlVar ='';
			String title='';
			String field='';
			String msjFoot='';
			
			title='<a style="color:#FFFFFF;" href="' + Label.sfdcHostName +'apex/ProjectDetail?id='+ proj.Project__r.id + '">' + proj.Project__r.Name + '</a>';
			htmlVar=returnHtmlIni(htmlVar,title);
			
			title='Priority';
			field=proj.Priority__c;
			htmlVar=returnVarHtml(htmlVar, title, field);
			
			title='Start date';
			field=proj.StartDate__c.format();
			htmlVar=returnVarHtml(htmlVar, title, field);
			
			title='End date';
			field='';
			if (proj.EndDate__c != null)
				field=proj.EndDate__c.format();
			htmlVar=returnVarHtml(htmlVar, title, field);
			
			title='Description';
			field=proj.Description__c;
			htmlVar=returnVarHtml(htmlVar, title, field);
			
			msjFoot='Task '+proj.Name + ' has been deleted from '+proj.Project__r.Name;
			htmlVar=returnHtmlFin(htmlVar,msjFoot);
			
			emailMsj=htmlVar;
			
			String Msg='task '+ ProjectUtil.chopWords( ProjectUtil.chopPhrase( proj.Name , 35 )) + ' has been deleted';
			emailSub=returnHtmlSubject(proj.Project__r.Name,Msg);
	
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

			        String htmlVar ='';
					String title='';
					String field='';
					String msjFoot='';
					
					title='<a style="color:#FFFFFF;" href="' + Label.sfdcHostName +'apex/ProjectDetail?id='+ t.Project__c + '">' + t.Project__r.Name + '</a>';
					htmlVar=returnHtmlIni(htmlVar,title);
					
					title='Task Name';
					field='<a href="' + Label.sfdcHostName+'apex/projecttaskdetail?id='+t.id + '">'+ t.Name + '</a>';
					htmlVar=returnVarHtml(htmlVar, title, field);
					
					title='Priority';
					field='t.Priority__c';
					htmlVar=returnVarHtml(htmlVar, title, field);
					
					title='Start date';
					field=t.StartDate__c.format();
					htmlVar=returnVarHtml(htmlVar, title, field);
					
					title='End date';
					field='';
					if (t.EndDate__c != null)
						field=t.EndDate__c.format();
					htmlVar=returnVarHtml(htmlVar, title, field);
					
					title='Description';
					field=t.Description__c;
					htmlVar=returnVarHtml(htmlVar, title, field);
					
					msjFoot='You were unassigned from this task';
					htmlVar=returnHtmlFin(htmlVar,msjFoot);
					
					emailMsj=htmlVar;
			        
			        String Msg='You were unassigned from task ' + ProjectUtil.chopWords( ProjectUtil.chopPhrase( t.Name , 35 )) + '.';
					emailSub=returnHtmlSubject(t.Project__r.Name,Msg);
						    
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
	
	
	
	//////////////////
	/**
    * Send mail to subscribers, for expiring task
    *@param List<String> lstPTId
    *@return void
    */
   	public  void sendMailForExpiringTasks( List<String> lstPTId ) {
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
        
	        String htmlVar ='';
			String title='';
			String field='';
			String msjFoot='';
			
			title='<a style="color:#FFFFFF;" href="' + Label.sfdcHostName +'apex/ProjectDetail?id='+ lstPT[0].Project__r.Id + '">' + lstPT[0].Project__r.Name + '</a>';
			htmlVar=returnHtmlIni(htmlVar,title);
			
			title='Task Name';
			field='<a href="'+ Label.sfdcHostName+'apex/projecttaskdetail?id='+lstPT[0].id+ '">' + lstPT[0].Name+ '</a>';
			htmlVar=returnVarHtml(htmlVar, title, field);
			
			title='Priority';
			field=lstPT[0].Priority__c;
			htmlVar=returnVarHtml(htmlVar, title, field);
			
			title='Start date';
			field=lstPT[0].StartDate__c.format();
			htmlVar=returnVarHtml(htmlVar, title, field);
			
			title='End date';
			field='';
			if (lstPT[0].EndDate__c != null)
				field=lstPT[0].EndDate__c.format();
			htmlVar=returnVarHtml(htmlVar, title, field);
			
			
			title='End Descripcion';
			field=lstPT[0].Description__c;
			htmlVar=returnVarHtml(htmlVar, title, field);
			
			msjFoot='Task is past its due date';
			htmlVar=returnHtmlFin(htmlVar,msjFoot);
			
			emailMsj=htmlVar;
			
			String Msg='Task '+ ProjectUtil.chopWords( ProjectUtil.chopPhrase( lstPT[0].Name , 35 )) + ' is past its due date';
			emailSub=returnHtmlSubject(lstPT[0].Project__r.Name,Msg);

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
	
	////////////////////

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
        if(subscriptions.size() > 0 && subscriptions != null){
        	for(Integer i =0; i <= subscriptions.size(); i++ ){   
	            if(it < 10 && i < subscriptions.size() )
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
        }
        /*
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
	   */   
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
   
    
    /** findForExpiringTask and send mail...
    *@param void
    *@return void
    */
    public void findForExpiringTask(){
    	Date dNow = Date.today();
    	// List of project with subscription
    	for (Project2__c listOfProjects : 
		[ 	Select p.ProjectDayOfExpiringTask__c, p.ProjectBeforeOfExpiringTask__c, p.ProjectAfterOfExpiringTask__c, p.Name, p.Id 
			From Project2__c p
    		where p.ProjectDayOfExpiringTask__c = true  or  p.ProjectBeforeOfExpiringTask__c = true or  p.ProjectAfterOfExpiringTask__c = true 
    	]) {
			//List of task  
			for ( ProjectTask__c listOfTask : 
			[	
				Select p.Status__c, p.StartDate__c, p.Name, p.Milestone__c, p.Id, p.EndDate__c, p.PercentCompleted__c, p.Priority__c,
				(Select Name, User__c From ProjectsAssignees__r) , Project__c
				From ProjectTask__c p 
				where p.Project__c =: listOfProjects.Id and Status__c != 'Closed' and Status__c != 'Resolved'
			]){
				Date dStart = listOfTask.StartDate__c;
				Date dEnd = listOfTask.EndDate__c;
				Date dEndMinusOne = listOfTask.EndDate__c;
				String shippingType='';

				if (listOfTask.Milestone__c){
					//If is a MILESTONE
					integer dNowMinusDStart = dStart.daysBetween(dNow);
					if (dNowMinusDStart == 0){
						shippingType='milestoneDayExpiry';
					}
					else if (dNowMinusDStart > 0){
						//Repetitive after expiring, i send mail one day yes one day no
						Integer resmod = math.mod(dNowMinusDStart, 2);
						if (resmod == 0){
							//Prepare to send mail
							shippingType='milestoneAfterExpiring';
						}
					}
				}
				else{ 
					//Is not milestone!! its a normal TASK
					dEndMinusOne  =  dEnd.addDays(-1);

					integer dNowMinusDEnd = dEnd.daysBetween(dNow);
					if ((dNowMinusDEnd > 0)&&(listOfProjects.ProjectAfterOfExpiringTask__c)){
						//As this to overcome their due date
						//Repetitive after expiring, i send mail one day yes one day no
						Integer resmod = math.mod(dNowMinusDEnd, 2);
						if (resmod == 0){
							//Prepare to send mail
							shippingType='afterExpiring';
						}
					}
					else if ((dNowMinusDEnd == 0)&&(listOfProjects.ProjectDayOfExpiringTask__c)){
						//Expiry day
						shippingType='dayExpiry';
					}
					else { //(dNowMinusDEnd < 0)
						integer dEndMinusOneMinusDStart = dStart.daysBetween(dEndMinusOne);
						integer dEndMinusOneMinusDEnd = dEndMinusOne.daysBetween(dNow);
						if ((dEndMinusOneMinusDStart > 0 ) && (dEndMinusOneMinusDEnd == 0)&&(listOfProjects.ProjectBeforeOfExpiringTask__c)){
							//One day for expiring...
							shippingType='beforeExpiring';
						}
					}
				} // end else mileston

				if ((shippingType=='beforeExpiring')||(shippingType=='dayExpiry')||(shippingType=='afterExpiring')||(shippingType=='milestoneExpiring')){
					if (listOfTask.ProjectsAssignees__r != null){
						Boolean ifAccess = false;
						
						//Eliminar
						String usr ='';
						
						List<String> SubAssignees = new List<String>();
						for (ProjectAssignee__c useraux : listOfTask.ProjectsAssignees__r){
							//Cambiarrrrr
							usr+=useraux.User__c+',';
							ifAccess=true;
							SubAssignees.add(useraux.User__c);
						}
						
						List<User> mailUsers = new List<User>();
						//List<String> mailUsers = new List<String>();
						mailUsers = [Select u.Email From User u where u.Id in :SubAssignees];
						System.debug('XXX - Users='+mailUsers);
						//mailUsers =(User:{'Email=soares@timbasoftware.com', Id='00530000001jvrdAAA'}, User:{'Email=ndominguez@timbasoftware.com', Id='00530000001lbRJAAY'}, User:{'Email=mmenafra@timbasoftware.com', Id='00530000002S0U2AAK'}) ;
						//mailUsers['00530000001jvrdAAA']=
						//System.debug('XXX - Users!='+mailUsers);						
						if (ifAccess){
							////////////////
							System.debug ('**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**');
							//*
								System.debug ('XXX - PROJECT = '+listOfProjects.Name+', id projecto ='+listOfProjects.Id);
								if (listOfTask.Milestone__c)
									System.debug ('XXX - MILESTONE = '+listOfTask.Name);
								else
									System.debug ('XXX - TASK = '+listOfTask.Name);
								System.debug ('XXX - NOW='+dNow+', START='+dStart+', EndMinusOne='+dEndMinusOne+', END='+dEnd);
								System.debug ('XXX - PercentCompleted = '+listOfTask.PercentCompleted__c+', Status='+listOfTask.Status__c);
								System.debug ('XXX - Usuarios : '+usr);
							//*/
							/////////////////
							String htmlVar ='';
							String htmlVarStart='';
							String htmlVarEnd='';
							String titleField='';
							String title='';
							String field='';
							String msjFoot='';
							String Subject='';
							///////TASK
							if (shippingType=='beforeExpiring'){
								//System.debug ('XXX - TASK - ENVIOMAIL MANIANA VENCE dEndMinusOneMinusDStart > 0 ) && (dEndMinusOneMinusDEnd < 0) -> esta entre el dia anterior del fin de task y el fin de la task...');
								
								Subject = 'One day left for Task "'+ProjectUtil.chopWords( ProjectUtil.chopPhrase( listOfTask.Name , 35 ))+'" to expire.';
								Subject =  returnHtmlSubject(listOfProjects.Name,Subject);

								msjFoot = 'One day left for Task to expire.';
								htmlVarEnd=returnHtmlFin(htmlVarEnd,msjFoot);
							}
							///////TASK
							else if (shippingType=='dayExpiry'){
								//System.debug ('XXX - TASK - ENVIOMAIL DIA VENCIMIENTO now = end (now - end = 0 )');
								
								Subject = 'Task "'+ProjectUtil.chopWords( ProjectUtil.chopPhrase( listOfTask.Name , 35 ))+'" expires today.';
								Subject =  returnHtmlSubject(listOfProjects.Name,Subject);

								msjFoot='<label style="color:red">Task expires today.</label>';
								htmlVarEnd=returnHtmlFin(htmlVarEnd,msjFoot);
							}
							///////TASK
							else if (shippingType=='afterExpiring'){
								//System.debug ('XXX - TASK - ENVIOMAIL VENCIDO HACE MAS DE UN DIA now > end (now - end > 0 )');
								
								Subject = 'Task "'+ProjectUtil.chopWords( ProjectUtil.chopPhrase( listOfTask.Name , 35 ))+'" has surpassed Due date.';
								Subject =  returnHtmlSubject(listOfProjects.Name,Subject);

								msjFoot = '<label style="color:red">Task has surpassed Due date.</label>';
								htmlVarEnd=returnHtmlFin(htmlVarEnd,msjFoot);
							}
							/////MILESTONEEEE
							else if (shippingType=='milestoneDayExpiry'){
								//System.debug ('XXX - MILESTONEE - ENVIOMAIL POR DIA DEL VENCIMIENTO DEL  MILESTONEE');
								
								
								Subject = 'Milestone "'+ProjectUtil.chopWords( ProjectUtil.chopPhrase( listOfTask.Name , 35 ))+'" expires today.';
								Subject =  returnHtmlSubject(listOfProjects.Name,Subject);

								msjFoot='<label style="color:red">Milestone expires today.</label>';
								htmlVarEnd=returnHtmlFin(htmlVarEnd,msjFoot);
							}
							/////MILESTONEEEE
							else if (shippingType=='milestoneAfterExpiring'){
								//System.debug ('XXX - MILESTONEE - ENVIOMAIL POR MILESTONEE VENVIDOOO');
								
								Subject = 'Milestone "'+ProjectUtil.chopWords( ProjectUtil.chopPhrase( listOfTask.Name , 35 ))+'" has surpassed Due date.';
								Subject =  returnHtmlSubject(listOfProjects.Name,Subject);

								msjFoot='<label style="color:red">Milestone has surpassed Due date.</label>';
								htmlVarEnd=returnHtmlFin(htmlVarEnd,msjFoot);
							}

							//Name of project
							title='<a style="color:#FFFFFF;" href="' + Label.sfdcHostName +'apex/ProjectDetail?id='+ listOfProjects.Id + '">' + listOfProjects.Name + '</a>';
							htmlVarStart=returnHtmlIni(htmlVarStart,title);
							//-------------------------------------------

							////Fields
							titleField='Task Name';
							field='<a style="color:#000000;" href="'+ Label.sfdcHostName+'apex/projecttaskdetail?id='+listOfTask.id+ '">' + listOfTask.Name+ '</a>';
							htmlVar=returnVarHtml(htmlVar, titleField, field);

							titleField='Percent Completed';
							field= String.valueOf( listOfTask.PercentCompleted__c );
							htmlVar=returnVarHtml(htmlVar, titleField, field);
							
							titleField='Status';
							field=listOfTask.Status__c;
							htmlVar=returnVarHtml(htmlVar, titleField, field);

							titleField='Priority';
							field=listOfTask.Priority__c;
							htmlVar=returnVarHtml(htmlVar, titleField, field);
							
							titleField='Start date';
							field=listOfTask.StartDate__c.format();
							htmlVar=returnVarHtml(htmlVar, titleField, field);
							
							titleField='End date';
							field='';
							if (listOfTask.EndDate__c != null)
								field=listOfTask.EndDate__c.format();
							htmlVar=returnVarHtml(htmlVar, titleField, field);
							
							String emailMsj =''; 
							emailMsj = htmlVarStart + htmlVar + htmlVarEnd;
							
							
							
							for (Integer i=0; i<15; i++){
								mailUsers[i].Email='ndominguez@timbasoftware.com';
							}						
							
							
							//sacarrrrrrrrrr fin
							
							String[] address = new String[]{}; 
					        Integer it = 0;
					        //Project2__c cc= new Project2__c();
					        if (!isTest){
						        if((mailUsers.size() > 0) && (mailUsers != null)){
							        for(Integer i =0; i <= mailUsers.size(); i++ ){
							            if((it < 10) && (i < mailUsers.size() )) {
							                address.add(mailUsers[i].Email);
							                it ++;
							            }
							            
							            else { //if(it >= 10 || i >= mailUsers.size() ) {
							            	//System.debug('XXX YYY 5');
							                
							                System.debug('XXX - address='+address);
							                System.debug('XXX - Subject='+Subject);
							                System.debug('XXX - emailMsj='+emailMsj);
							                System.debug('XXX envio mailllllllllll');
							              //  SendMail(address, null, emailMsj, Subject);
							                it = 0;
							            }
							        }
						        }
					        }
						}
					}
				}
			}
		}
    }
}