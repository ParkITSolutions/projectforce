/**
*@author Ignacio Toledo @ 4/1/2009
*/
public class ProjectCreateNewTaskController {
	
	public ProjectTask__c theTask = new ProjectTask__c();
	//Param is the projectId
	public String param = System.currentPageReference().getParameters().get('id');
	//idTask is only for edit
   	public String idTask = System.currentPageReference().getParameters().get('task');
	// max picture size bytes
  	public String assignees = '';
	// Attachments
   	public List<Attachment> attachList = new List<Attachment>(); 
	public List<Integer> errorAttachList = new List<Integer>();
	List<assingTo> resultMem = new List<assingTo>();
	// Sharing rules
	public UserPermissions userPermissions = new UserPermissions();
	//Inner class for manage dates
	dateMyFormat dateMy = new dateMyFormat();
	assingTo assign = new assingTo();
	String ProjectPicture = '';
    Boolean validSizePicture = true;
    public Boolean validTypePicture = true;
	List<myAttachment> resultAt = new List<myAttachment>();
	public Attachment document = new Attachment();
   	public final Integer MAX_SIZE = 5240000;
   	//Project list path
	public PageReference URL_TO_LIST = Page.ProjectTasksList;
	public Boolean errorInDates = false;
	
	
	public Boolean getErrorInDates(){ return errorInDates; }
	/**
	* Constructor
	*/
	public ProjectCreateNewTaskController(){
   		genPermissions();
   		String qtEdit = System.currentPageReference().getParameters().get('ed');  		
   		String qtName = System.currentPageReference().getParameters().get('qtname');
   		String qtStartDate = System.currentPageReference().getParameters().get('qtsd');  
		String qtDueDate = System.currentPageReference().getParameters().get('qtdd');
		String qtEstimate = System.currentPageReference().getParameters().get('qte');
		
		String isMilestone = System.currentPageReference().getParameters().get('qmname');

		if(isMilestone != null){
			qtName = System.currentPageReference().getParameters().get('qmname');
			qtDueDate = System.currentPageReference().getParameters().get('qmdd');
			theTask.Milestone__c = true;
		}
		
   		
   		if(qtStartDate != '' && qtStartDate != null){
   			
   			String[] startList = qtStartDate.split('/', 3);
   			Date startDate = Date.valueOf(startList[2] + '-' + startList[0] + '-' + startList[1]);
   			theTask.StartDate__c = startDate;
		}
		
		if(qtDueDate != '' && qtDueDate != null){
   			String[] dueList = qtDueDate.split('/', 3);
   			Date dueDate = Date.valueOf(dueList[2] + '-' + dueList[0] + '-' + dueList[1]);
   			theTask.EndDate__c = dueDate;
		}
		if(qtEstimate != '' && qtEstimate != null){
   			theTask.Duration__c = Integer.valueOf(qtEstimate);
		} 	
   	
   		theTask.Name = qtName;
   				
   		if(idTask == null){
   			if(param != null){
   				theTask.Project__c = param;
   			}	
   		}
   		
   		if(param != null && idTask != null) {
   			getTaskForEdit(param, idTask);
   			Boolean canEdit = false;
   			
   			for(assingTo assignee :getAssignMember()) {
   				if(assignee.getIdMember() == UserInfo.getUserId()) canEdit = true;
   			}
   		}
   		if(qtEdit == 'true'){
   			genTempTask();
   		}
	}
   	public String getProjectId(){
   		return param;	
   	}
   	public Boolean getValidSizePicture(){
    	return validSizePicture;
    }
    public Boolean getValidTypePicture(){
    	return validTypePicture;
    }	
   	
	/**
	* Return a List of Attachments
	*@return List<myAttachment>
	*/
   	public List<myAttachment> getAttachmentList(){
   		return resultAt;
   	}
	
	public String ParentName { get; set; }
	
	/**
	*@return String
	*/
	public String getAssignees(){
		return assignees;
	}
	
	/**
	*@param String
	*/
	public void setAssignees (String s){ 
		assignees = s;
	}
	
	/**
   	*@return List<assingTo>
   	*/
   	public List<assingTo> getAssignMember() {
  	 	return resultMem;
   	}
	
	/**
	*@return UserPermissions
	*/
	public UserPermissions getUserPermissions () {
		return userPermissions; 
	}
	
	/**
	*@return dateMyFormat
	*/
	public dateMyFormat getdateMy(){ 
		return dateMy;
	}
	
	/**
	*@return assingTo
	*/
	public assingTo getassingTo(){ 
		return assign;
	}
    
	/**
	*@return ProjectTask__c
	*/
    public ProjectTask__c getTask(){
    	return theTask; 
    }
    
	/**
	*@param ProjectTask__c
	*/
    public void setTask(ProjectTask__c value) {
    	theTask =  value;
    }
    
	/**
	*@param String
	*/
    public void setParam(String p){
    	param = p;
    }
    
    String typeOfAction = 'Add New';
    
	/**
	*@return String
	*/
    public String getTypeOfAction(){
		return typeOfAction;
	}
	
	/**
	* Return the Namespace Prefix
	*@return String
	*/
	public String getNamespace () {
        return ProjectUtil.getNamespace();
    }
	
	/**
	*@return inputs file erros index
	*/
	public List<Integer> getErrorAttachList(){
		return errorAttachList;
	}
	
	public Attachment att1 = new Attachment();
	
	/**
	*@return Attachment
	*/
	public Attachment getAtt1 () {
		return att1;
	}
	
	public Attachment att2 = new Attachment();
	
	/**
	*@return Attachment
	*/
	public Attachment getAtt2 () {
		return att2;
	}
	
	public Attachment att3 = new Attachment();
	
	/**
	*@return Attachment
	*/
	public Attachment getAtt3 () {
		return att3;
	}
	
	public Attachment att4 = new Attachment();
	
	/**
	*@return Attachment
	*/
	public Attachment getAtt4 () {
		return att4;
	}
	
	public Attachment att5 = new Attachment();
	
	/**
	*@return Attachment
	*/
	public Attachment getAtt5 () {
		return att5;
	}
	
	public Attachment att6 = new Attachment();
	
	/**
	*@return Attachment
	*/
	public Attachment getAtt6 () {
		return att6;
	}
	
	public Attachment att7 = new Attachment();
	
	/**
	*@return Attachment
	*/
	public Attachment getAtt7 () {
		return att7;
	}
	
	public Attachment att8 = new Attachment();
	
	/**
	*@return Attachment
	*/
	public Attachment getAtt8 () {
		return att8;
	}
	
	public Attachment att9 = new Attachment();
	
	/**
	*@return Attachment
	*/
	public Attachment getAtt9 () {
		return att9;
	}
	
	public Attachment att10 = new Attachment();
	
	/**
	*@return Attachment
	*/
	public Attachment getAtt10 () {
		return att10;
	}
	
	
	/**
	* Generate user permissions
	*@void
	*/
	public void genPermissions() {
		userPermissions.setId(UserInfo.getUserId());
		userPermissions.setProject(param);
		userPermissions.setObjectType('Project');		
		userPermissions.setPermissions();		
	}
	
	/**
	* Generate a TempTask
	*@void
	*/
	public void genTempTask(){
		//Get Params
		String taskAsignee = System.currentPageReference().getParameters().get('qtaid');
		
		if(taskAsignee == null)
			taskAsignee = System.currentPageReference().getParameters().get('qmaid');
		
		if(taskAsignee != null && taskAsignee != '-1')
			dateMy.setMember(taskAsignee);
	}	
	
	/**
	* Return an Options List with Members in
	*@return List<SelectOption>
	*/
	public List<SelectOption> getMembers() {
    	List<ProjectMember__c> projectMembers = new List<ProjectMember__c>();  
  	 	List<SelectOption> options = new List<SelectOption>();
  	 	if(param != null){
	  	 	projectMembers = [Select t.Project__c, t.User__r.Name, t.Name, t.User__c, t.Id From ProjectMember__c t where t.Project__c =: param];  
	  	 	options.add(new SelectOption('Choose a Project Member', 'Choose a Project Member'));
	  	 	for(ProjectMember__c c: projectMembers) {
	    		options.add(new SelectOption(c.User__c, c.User__r.Name)); 
	 		}
  	 	}
  	 	return options;
   	}
   	
	/**
	* Return an Options List with Percents in
	*@return List<SelectOption>
	*/
   	public List<SelectOption> getPercent() {
  	 	List<SelectOption> percents = new List<SelectOption>();
  	 	for(Integer i = 0; i < 101; i=i+5){
  	 		percents.add(new SelectOption(String.valueOf(i)+'.0', String.valueOf(i)+'%'));
  	 	}
  	 	return percents;
   	}
   	
	/**
	* Return an Options List with Percents in
	*@return List<SelectOption>
	*/
   	public List<SelectOption> getPercentDedicated() {
  	 	List<SelectOption> percentsD = new List<SelectOption>();
  	 	for(Integer i = 0; i<101; i=i+5){
  	 		percentsD.add(new SelectOption(String.valueOf(i)+'.0', String.valueOf(i)+'%'));
  	 	}
  	 	return percentsD;
   	}
   	
   	/**
   	* Save Task
   	*@void
   	*/
   	public void save(){
   		if(theTask.Id == null){
   			if(userPermissions.getCanCreate()){
   				theTask.Project__c = param;
   				insert theTask;
   			}else{
   				throw new CustomException('Insufficient Privileges');
   			}
   		}else {
   			if(canUpdate()){
   				update theTask;
   			}else{
   				throw new CustomException('Insufficient Privileges');
   			}
   		}
   	}
   	
   	/**
   	*@return Boolean
   	*/
   	public boolean canUpdate(){
   		Boolean canEdit = false;
   		for(assingTo assignee :getAssignMember()){
   			if(assignee.getIdMember() == UserInfo.getUserId()) canEdit = true;	
   		}
   		return (userPermissions.getCanManage() || canEdit );
   	}
   	
   	/**
   	* Save Asignees
   	* Format: userId:percentage;userId:percentage
   	*@void
   	*/
   	public void saveAssignees(){

   		List<String> assigns = assignees.split(';');
   		if(assigns.size() == 0)
   			return;
   			   		
   		List<ProjectAssignee__c> assignsToDel = new List<ProjectAssignee__c>();
   		List<ProjectAssignee__c> assignsToSave = new List<ProjectAssignee__c>();
   		
   		assignsToDel = [select Id from ProjectAssignee__c where ProjectTask__c =: theTask.Id]; 
   		
   		//Add first Assignee
   		ProjectAssignee__c assign = new ProjectAssignee__c();
   		assign.User__c = dateMy.getMember();
   		assign.Project__c = param;
   		assign.PercentDedicated__c = dateMy.getPercent(); 
   		assign.ProjectTask__c = theTask.Id;   		
   		assignsToSave.add(assign);
   		
   		//Add other assignees
   		List<String> auxAssign = new List<String>(); 
   		for(Integer it = 0; it < assigns.size(); it++){
   			auxAssign = assigns[it].split(':');
   			if(auxAssign.size() == 2){
	   			assign = new ProjectAssignee__c();
	   			assign.User__c = auxAssign[0];
	   			assign.Project__c = param;
	   			assign.PercentDedicated__c = Double.valueOf(auxAssign[1]); 
	   			assign.ProjectTask__c = theTask.Id;
	   			assignsToSave.add(assign);
   			}
   		}
   		if(assignsToSave.size() > 0)
   			insert assignsToSave;
   			
   	    // For order of operation purposes we have to move the 
   	    // delete to after the insert so on an edit we have a clear picture of 
   	    // used to be the assignee.
   	    // Other option is to create a real update :)
   	    if(assignsToDel.size() > 0)
   			delete assignsToDel;
   	}
   	
   	/**
   	* Get Task for Edit
   	*@param String myParam
   	*@param String task
   	*@void
   	*/
   	public void getTaskForEdit(String myParam, String MyidTask) {
		setAttachment(MyidTask);
		typeOfAction = 'Edit';
		
		Map<String, Schema.SObjectField> projectFields = Schema.SObjectType.ProjectTask__c.fields.getMap();
	    
	    String fields = '';
	    String query = 'select ';
	    
	    //Set Object Fields
	    for(Schema.SObjectField field : projectFields.values()){
	    	if(field != null)
	    		fields += (field + ', ');  	
	    }
	    
	    //Execute Dynamic SOQL
	    query += fields.substring(0, (fields.length() - 2)) + ', p.ParentTask__r.Name, ';
	    query += '(Select User__c, PercentDedicated__c From ProjectsAssignees__r)';
	    query += ' from ProjectTask__c p where Id = \'' + MyidTask + '\'';
	    theTask = Database.query(query);		
 	      		
		if(theTask.ProjectsAssignees__r.size() > 0 && theTask.ProjectsAssignees__r[0] != null ){
			dateMy.setMember(theTask.ProjectsAssignees__r[0].User__c);
			dateMy.setPercent(theTask.ProjectsAssignees__r[0].PercentDedicated__c);
		}
		if(theTask.ParentTask__r.Name != null && theTask.ParentTask__r.Name != ''){	
   			ParentName = theTask.ParentTask__r.Name;
   		}
   		
   		if( fields.indexOf( 'StartDate__c') != -1 && fields.indexOf( 'EndDate__c') != -1){
   		
   			Date startDate = theTask.StartDate__c;
   			Date endDate = theTask.EndDate__c;
   			
   			this.errorInDates = ( startDate  > endDate ) ? true : false;
   		}
   		
		for(ProjectAssignee__c t: theTask.ProjectsAssignees__r){  
			assingTo assignMem = new assingTo();
			assignMem.setPercent(t.PercentDedicated__c); 
			assignMem.setIdMember(t.User__c);
			resultMem.add(assignMem);
		}
		dateMy.setHours(theTask.Duration__c);
		dateMy.setlastModify(theTask.LastModifiedDate);
		dateMy.setcreateDate(theTask.CreatedDate);
   	}
   	
	/**
	* Return an Options List with Priorities in
	*@return List<SelectOption>
	*/
   	public List<SelectOption> getPriority() {
  	 	List<SelectOption> priority = new List<SelectOption>(); 
  	 	priority.add(new SelectOption('Medium','Medium'));	 	
  	 	priority.add(new SelectOption('High', 'High')); 	 	
  	 	priority.add(new SelectOption('Low','Low'));
  	 	return priority;
   	}
   	
   	/**
   	*@param String idTask
   	*/
   	public void setAttachment(String taskId){
   		List<Attachment> res = new List<Attachment>();
   		res = [Select Name, Id, ParentId, ContentType, BodyLength From Attachment where ParentId =: taskId ];
   		if(res.size() > 0){
   			for(Attachment t: res){
				myAttachment at = new myAttachment();
				at.setBodyLenght(t.BodyLength);
				at.setIdAttachment(t.Id);
				at.setContentType(t.ContentType);
				at.setNameAttachment(t.Name);
				resultAt.add(at);
			}
   		}
   	}
   	
   	/**
	* Save attachments and project type
	*@return PageReference
	*/
   	public PageReference saveAttachmentsAndAccess(){
   		    	
    	attachList.clear(); 
   		if(theTask.Milestone__c)
   			theTask.StartDate__c = theTask.EndDate__c;
   			
   		if (att1.Name != null && att1.Name != '') {
   			att1.ParentId = theTask.Id;
   			attachList.add(att1);
   			att1=new Attachment();
   		}

   		if (att2.Name != null && att2.Name != '') {
   			att2.ParentId = theTask.Id;
   			attachList.add(att2);
   			att2=new Attachment();
   		}
   		if (att3.Name != null && att3.Name != '') {
   			att3.ParentId = theTask.Id;
   			attachList.add(att3);
   			att3=new Attachment();
   		}
   		if (att4.Name != null && att4.Name != '') {
   			att4.ParentId = theTask.Id;
   			attachList.add(att4);
   			att4=new Attachment();
   		}
   		if (att5.Name != null && att5.Name != '') {
   			att5.ParentId = theTask.Id;
   			attachList.add(att5);
   			att5=new Attachment();
   		}
   		if (att6.Name != null && att6.Name != '') {
   			att6.ParentId = theTask.Id;
   			attachList.add(att6);
   			att6=new Attachment();
   		}
   		if (att7.Name != null && att7.Name != '') {
   			att7.ParentId = theTask.Id;
   			attachList.add(att7);
   			att7=new Attachment();
   		}
   		if (att8.Name != null && att8.Name != '') {
   			att8.ParentId = theTask.Id;
   			attachList.add(att8);
   			att8=new Attachment();
   		}
   		if (att9.Name != null && att9.Name != '') {
   			att9.ParentId = theTask.Id;
   			attachList.add(att9);
   			att9=new Attachment();
   		}
   		if (att10.Name != null && att10.Name != '') {
   			att10.ParentId = theTask.Id;
   			attachList.add(att10);
   			att10=new Attachment();
   		} 

   		errorAttachList = new List<Integer>();
   		errorAttachList = ProjectUtil.validateFileSize(attachList);
   		   		  		   		
   		if(errorAttachList.size() > 0){
   			return null;
   		}else{
   			insert attachList;	
   		}
   			
  		//Save Assignees
  		saveAssignees();
   		
   		PageReference forward = URL_TO_LIST;
   		forward.getParameters().put('id', theTask.Project__c);
   		forward.setRedirect(true);
   		return forward;
    }
	
	
	/**
   	* Inner class for assignTo type
   	*@class
   	*/
   	public class assingTo {
   		
   		public Integer percent;
		public String idMember;
 		
 		/**
 		*@return Integer
 		*/
   		public Integer getPercent() {
      		return percent;
        }
        
 		/**
 		*@param Double
 		*/
        public void setPercent(Double per){
        	if(per == null){
        		percent = 0;
        	}else{
        		percent = per.IntValue();
        	}
        }
        
 		/**
 		*@return String
 		*/
        public String getIdMember() {
      		return idMember;
        }
        
 		/**
 		*@param String
 		*/
        public void setIdMember(String idm){
        	idMember = idm;
        }
   	}
   	
    /**
   	* Inner Class myAttachment
   	*@class
   	*/
    public class myAttachment {
   		
   		public String nameAttachment = '';
		public String contentType = '';
		public String idAttachment = '';
		public Integer bodyLenght = 0;
 		
 		/**
 		*@return Integer
 		*/
   		public Integer getBodyLenght(){
      		return bodyLenght;
        }
        
 		/**
 		*@return String
 		*/
        public String getidAttachment(){
      		return idAttachment;
        }
        
 		/**
 		*@return String
 		*/
        public String getContentType(){
      		return contentType;
        }
        
 		/**
 		*@return String
 		*/
        public String getNameAttachment(){
      		return nameAttachment;
        }
        
 		/**
 		*@param Integer
 		*/
        public void setBodyLenght(Integer len){
        	bodyLenght = len;
        }
        
 		/**
 		*@param String
 		*/
        public void setIdAttachment(String idA){
        	idAttachment = idA;
        }
        
 		/**
 		*@param String
 		*/
        public void setContentType(String mime){
        	if(mime == 'image/jpeg' || mime ==  'image/png'  || mime == 'image/gif'  || mime == 'image/bmp'){
        		contentType = 'imageType';
        	}else if(mime == 'application/pdf'){
        		contentType = 'pdfType';
        	}else if(mime == 'text/plain'){
        		contentType = 'txtType';
        	}else if(mime == 'application/msword'){
        		contentType = 'docType';
        	}else if(mime == 'application/x-zip-compressed'){
        		contentType = 'zipType';
        	}else {	
        		contentType = 'unknowType';
        	}
        }
        
 		/**
 		*@param String
 		*/
        public void setNameAttachment(String n){
        	nameAttachment = n;
        }
   	}

   	/*
   	*Inner Class dateMyFormat
   	*@class
   	*/
  	public class dateMyFormat {
   		
   		protected Integer hours = 	0;
   		protected String member = UserInfo.getUserId();
   		protected String lastModify = '';
   		protected String createDate = '';
   		protected Double percentD = 100.0;
   		
 		/**
 		*@return String
 		*/
   		public String  getLastModify() {
   			return lastModify;
   		} 
   		
 		/**
 		*@param Datetime
 		*/
   		public void setLastModify(Datetime lastM){
   			lastModify = lastM.format('MM/dd/yy hh:mm');
   		}  
   		
 		/**
 		*@return String
 		*/
   		public String getCreateDate() {
   			return createDate;
   		}
   		
 		/**
 		*@param Datetime
 		*/
   		public void setCreateDate(Datetime cre){
   			createDate = cre.format('MM/dd/yy hh:mm' );
   		}  
   		
 		/**
 		*@return Integer
 		*/
   		public Integer getHours() {
      		return hours;
        }
        
 		/**
 		*@param Double
 		*/
        public void setHours(Double hou){
        	hours = hou.intValue();
        }
   		
 		/**
 		*@return String
 		*/
   		public String getMember() {
      		return member;
        }
        
 		/**
 		*@param String
 		*/
        public void setMember(String mem){
        	member = mem;
        }
        
 		/**
 		*@return Double
 		*/
        public Double getPercent() {
      		return percentD;
        }
        
 		/**
 		*@param Double
 		*/
        public void setPercent(Double per){
        	percentD = per;
        }
   	}
	
	
}