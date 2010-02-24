/**
*@author Nicolas Gunther - 03/23/2009
*@modify : Sebastian Munoz (smunoz@timbasoftware.com)
*/   
public class ProjectDetailAttachmentController {

	private String project = null;
	
	private List<AttachmentInfo> attachments = new List<AttachmentInfo>();
	
	private UserPermissions userPermissions = ProjectDetailController.userPermission.clone();
	
	private String idToDelete;
	
	private String emptyValue;
	
	private Integer numberOfItemsToShowSummary; //number of items displaying on project detail
	
	public void dummyRefresh () {}
		
	public Set<Id> idsToDelSet = new Set<Id>();
   
    public String idsToDel = ':';

    
	 /**
    * Set of Integers to control pagination
    */
    private Integer totalItemsNumber;
    private Integer numberOfItemsToShow = 10;
    private Integer cntPagination = 0;
    private Integer currentPagination = 1;
    private Integer firstRow = 0;
   
    /**
    * Set of Booleans to show or not prev / next links
    */
    private boolean prevPageLinkShow = false;
    private boolean prevPageShow  = false;
    private boolean nextPageLinkShow  = false;
    private boolean nextPageShow  = false;
    
    private String domain;
	
	public ProjectDetailAttachmentController (){
		domain = ProjectUtil.getDomain();
		numberOfItemsToShowSummary = 5;
	}
	
	 public void setIdsToDel( String ids ){ 
    	idsToDel = ids;
    }

    public String getIdsToDel(){
    	return idsToDel;
    }
    
   	//massive deleting
    public void deleteChecked(){
    	for( String attachId : idsToDel.split( ':' )){
    		
    		Attachment attach = [select Id from Attachment where Id =: attachId];
			delete attach;
	
    	}
    	
    	idsToDel='';
    }
	
	 /**
    * Generates number of pages
    */
    public void genCntPagination() {
        cntPagination = (totalItemsNumber - (Math.mod(totalItemsNumber, numberOfItemsToShow))) / numberOfItemsToShow;
        if (Math.mod(totalItemsNumber, numberOfItemsToShow) != 0 ) {
            cntPagination++;
        }  
    }
    
    /**
    * Returns true if we should show next page link
    *@return Boolean
    */
    public boolean getNextPageLinkShow () {
        if((currentPagination == cntPagination) || (cntPagination == 0)){  
            nextPageLinkShow = false;
        } else {
            nextPageLinkShow = true;
        }         
        return nextPageLinkShow;
    }
	
	/**
    * Set previous page
    */
    public void prevPage () {
        currentPagination--;
        firstRow = firstRow - numberOfItemsToShow; 
    }
    
    /**
    * Set next page
    */
    public void nextPage () {
        currentPagination++;
        firstRow = firstRow + numberOfItemsToShow;        
    }
	
	/**
    *Returns true if we should show next page
    *@return Boolean
    */
    public boolean getNextPageShow () {
        if((currentPagination == cntPagination) || (cntPagination == 0)){
            nextPageShow = true;
        } else {
            nextPageShow = false;
        }
        return nextPageShow;
    }
    
	/**
    * Returns true if should show prev page
    *@return Boolean
    */
    public boolean getPrevPageShow () {
        if(currentPagination == 1){
            prevPageShow = true;
        } else {
            prevPageShow = false;
        }
        return prevPageShow;
    }
	
	 /**
    * Returns true if should show prev page link
    *@return Boolean
    */
    public boolean getPrevPageLinkShow () {
        if(currentPagination == 1){
            prevPageLinkShow = false;      
        } else {
            prevPageLinkShow = true;
        }
        return prevPageLinkShow;
    }
    
	 /**
    * Get the current page
    *@return Integer
    */
    public Integer getCurrentPagination () {
        return currentPagination;
    }
    
    /**
    *@return Integer
    */
    public Integer getNumberOfItemsToShowSummary() {
        return numberOfItemsToShowSummary;
    }
	
	
	 /**
    * Get the number of pages
    *@return Integer
    */
    public Integer getCntPagination () {
        return cntPagination;
    }
	
	/**
    * Get the number of first row in page
    *@return Integer
    */
    public Integer getFirstRow () {
        return firstRow;
    }
    
    /**
    *Returns the Task list size
    *@return Integer
    */
    public Integer getTotalItemsNumber(){   
        return totalItemsNumber;
    }
    
     /**
    * Get the number of items to show
    *@return Integer
    */
    public Integer getNumberOfItemsToShow () {
        return numberOfItemsToShow;
    }
	
	/**
	*@return String
	*/
	public String getDomain(){
		return this.domain;
	}

	/**
	*@param String project id
	*@return void
	*/
	public void setProject(String id){
		
		this.project = id;
		
		readAttachments();
		
		this.totalItemsNumber = attachments.size();
		
		genCntPagination();
	}
	
	/**
	*@return String project id
	*/
	public String getProject(){
		return project;
	}
	
	/**
	*@return List<AttachmentInfo> formated attachment list
	*/
	public List<AttachmentInfo> getAttachments(){
		return attachments;
	}
	/*
	*@return Boolean
	*/
	public Boolean getAttachmentCount(){
		return attachments.size() > 0;
	}
	
	public String getEmptyValue(){
    	return '';
    }
    
    public void setEmptyValue(String value ){ 
    	this.EmptyValue = value;
    }
    
    public String getIdToDelete(){
    	idToDelete = this.EmptyValue;
    	return this.idToDelete;
    }
    
    public void setIdToDelete(String value ){ 
		String attachId = value;
    }
	
	/**
	* Read user permissions
	*@return void
	*/
	public void genPermissions() {
		userPermissions.setId(UserInfo.getUserId());
		userPermissions.setProject(project);
		userPermissions.setObjectType('Project');
		userPermissions.setPermissions();		
	}
	
	/**
	*@return UserPermissions
	*/
	public UserPermissions getUserPermissions () {
		//Refresh user permissions
		genPermissions();
		return userPermissions;
	}	
                          
	/**
	*readAttachments();
	*@return void
	*/
	public void readAttachments(){
		
		List<Attachment> attachmentsList = new List<Attachment>();
		this.project = System.currentPageReference().getParameters().get('id');
		if(project != null){
			attachmentsList = [select name, id, parentid, ContentType, BodyLength, 
								LastModifiedDate, LastModifiedBy.Name, CreatedById
								from attachment 
								where parentid =: project
								order by LastModifiedDate desc];
		}
		
		
		
		loadAttachmentList(attachmentsList);
		
		totalItemsNumber = attachments.size();
		
		genCntPagination();
		
	}       
	
	/**
	* Load attachment list
	*@param List<Attachment> attachment list
	*@return void
	*/
	public void loadAttachmentList(List<Attachment> attachs){
		List<AttachmentInfo> attachList = new List<AttachmentInfo>();
		String avatarId;
		
		//Get current Avatar
		//avatarId = [ select Picture__c from Project2__c where Id =: project limit 1 ].Picture__c ;

		List<Project2__c> pic = new List<Project2__c>();
		pic = [ select Picture__c from Project2__c where Id =: project limit 1 ] ;
		if( pic.size() > 0 ) 
		avatarId = pic[0].Picture__c;
		
		for (Attachment item: attachs){	
			
			if(item.id != avatarId  && item.Name != 'pf__export.csv'){
	            
	            AttachmentInfo info = new AttachmentInfo();
	            
	            info.setId(item.Id);
	            info.setName(item.Name);
	            info.setAttachment(item);
	            info.setIsOwner(item.CreatedById == UserInfo.getUserId());
	            info.setBodyWeight(item.BodyLength);
	            
	            String ContentType = item.ContentType;
	            String image = '';
	            
	            if (ContentType == null ) {
	            	
	            	// Using extension
	            	Integer extPos = item.Name.lastIndexOf('.') + 1;
	            	String extension = item.Name.substring(extPos);
	            	
	            	// containsKey does a case sensitive comparison
	            	extension = extension.toLowerCase();
	           		Map<String, String> typesExt = new Map<String, String>{
	           			'rar' => 'rar.gif', 
	           			'xls' => 'xls.gif', 
	           			'ppt' => 'ppt.gif', 
	           			'avi' => 'video.gif', 
	           			'mpg' => 'video.gif', 
	           			'mpeg' => 'video.gif', 
	           			'flv' => 'video.gif', 
	           			'mp3' => 'audio.gif', 
	           			'doc' => 'doc.gif'
	       			};
	           		
	           		if(typesExt.containsKey(extension)) {
	           			image = typesExt.get(extension);
	           		}else {
	           			image = 'generic.gif';
	           		}
	            
	            }else{
	           		
	           		// Using mime type
	           		Map<String, String> typesMime = new Map<String, String>{
	           			'image/jpeg' => 'images.gif', 
	           			'image/pjpeg' => 'images.gif', 
	           			'image/png' => 'images.gif', 
	           			'image/x-png' => 'images.gif', 
	           			'image/gif' => 'images.gif', 
	           			'image/bmp' => 'images.gif', 
	           			'text/plain' => 'txt.gif', 
	           			'application/pdf' => 'pdf.gif', 
	           			'application/msword' => 'doc.gif', 
	           			'application/x-zip-compressed' => 'zip.gif', 
	           			'audio/wav' => 'audio.gif', 
	           			'audio/mpeg' => 'audio.gif', 
	           			'video/mpeg' => 'video.gif', 
	           			'video/avi' => 'video.gif'
	       			};	
	           		
	           		if(typesMime.containsKey(ContentType)) {
	           			image = typesMime.get(ContentType);
	           		}else {
	           			image = 'generic.gif';
	           		}
	            
	            }
	            
	            info.setAttachImage(image);
	            attachList.add(info);
			}
        }
		
		attachments = attachList;
	
	}

	/**
	* Delete Attachment
	*@return void
	*/
	public void deleteAttach (){
		String attachId = this.getIdToDelete();
		
		if(attachId != null && attachId != ''){
			
			Attachment attach = [select Id from Attachment where Id =: attachId];
			delete attach;
			readAttachments();
			
			this.totalItemsNumber = attachments.size();
   			cntPagination = 0;
    		currentPagination = 1;
     		firstRow = 0;
    
    		prevPageLinkShow = false;
    		prevPageShow  = false;
    		nextPageLinkShow  = false;
    		boolean nextPageShow  = false;
    
			genCntPagination();
			
			
		}	
		
		deleteChecked();	
	}
	                                    
	
	/**
	* Inner Class AttachmentInfo
	*/ 
	public class AttachmentInfo {
        
        String name;
        String attachImage;
		String id;
		Attachment attach;
		String bodyWeight;
		Boolean isOwner = false;
		
		public String shortName {
			set {}
			get {
				if(this.name.length() > 45){
					return this.name.substring(1,40)+'... '+this.name.substring(this.name.lastIndexOf('.'));
				}
				else{
					return this.name;
				}
			}
		}
		
        /**
        *@return String Attach id
        */
        public String getId () {
        	return id;
        }        
        
        /**
        *@param String Attach id
        *@return void
        */
        public void setId (String id) {
        	this.id = id;
        }
        
        /**
        *@return String Attach name
        */        
        public String getName() {
                return name;
        }

        /**
        *@param String Attach name
        *@return void
        */
        public void setName(String name) {
                this.name = name;
        }  
        
        
        /*
        *@Return String Attach bodyWeight
        */
        public String getBodyWeight(){
        	return bodyWeight;
        }
        
        /**
        *@param String attach type icon
        *@return void
        */
        public void setBodyWeight (Integer attachWeight) {
        	if((attachWeight / 1024) > 0)
        	{
				this.bodyWeight = String.valueOf( attachWeight / 1024 ) + ' Kb' ; 
        	}
        	else
        	{
        		this.bodyWeight = String.valueOf( attachWeight ) + ' b';
        	}
        	
        }     
        
        
        
		/**
		*@return String attach type icon
		*/       
        public String getAttachImage() {
                return attachImage;
        }

        /**
        *@param String attach type icon
        *@return void
        */
        public void setAttachImage (String attachImage) {
                this.attachImage = attachImage;
        }          

        /**
        *@param Attachment attach
        *@return void
        */
        public void setAttachment (Attachment attach) {
                this.attach = attach;
        }
        
        /**
        *@return Attachment
        */
        public Attachment getAttachment() {
                return attach;
        }
        
        /**
        *@param boolean b is owner
        *@return void
        */
        public void setIsOwner(Boolean b){
        	this.isOwner = b;
        }
        
        /**
        *@retrun boolean is owner
        */
        public Boolean getIsOwner(){
        	return isOwner;
        }                 
	}
}