/**
* @author Matias Menafra  
* @dateCreated 12/17/2009
*/
public class Project {

	private Integer workingHours;

	public String 	id						{ set; get; }
	public String 	access 					{ set; get; }
	public Boolean 	allowCPU 				{ set; get; }
	public Boolean 	allowPPU 				{ set; get; }
	public String 	daysWorkWeek 			{ set; get; }
	public String 	daysWorkWeekFormated 	{ set; get; }
	public String 	description 			{ set; get; }
	public String 	displayDuration 		{ set; get; }
	public String 	image 					{ set; get; }
	public String 	name 					{ set; get; }
	public String 	picture 				{ set; get; }
	public String 	priority 				{ set; get; }
	public String 	createdBy 				{ set; get; }
	public Date 	createdDate 			{ set; get; }
	public String 	prjType 				{ set; get; }
	public List<ProjectTask__c> tasks 		{ set; get; }
	public List<AttachmentObj> attachments  { set; get; }			
	
	/**
	* Constructor
	* @param id
	*/
	public Project( String id ){
		this.id = id;
	}
	
	/**
	* Constructor
	*/
	public Project(){
		
	}
	
	/**
	* gets tasks for a project. Used for Listing Tasks, returns a Paginator
	* @param filter
	* @param orderBy
	* @param orderAsc
	* @param letter letter to filter
	* @return tasks
	*/
	public ApexPages.StandardSetController getTasks( String filter, String orderBy, Boolean orderAsc, String letter ){
		
		return DAOFactory.getInstance().getTasksByProject( this.id, filter, orderBy, orderAsc, letter );
	}
	
	/**
	* gets members for a project. Used for Listing members, returns a Paginator
	* @param filter
	* @param orderBy
	* @param orderAsc
	* @param letter letter to filter
	* @return tasks
	*/
	public ApexPages.StandardSetController getMembers( String filter, String orderBy, Boolean orderAsc, String letter ){
		
		return DAOFactory.getInstance().getMembersByProject( this.id, filter, orderBy, orderAsc, letter );
	}
	
	/**
	* sets project info
	*/
	public void setInfo(){
		
	 	Project project = DAOFactory.getInstance().getProjectInfo( this.id );
	 	this.name = project.Name;
	}
	
	/**
	* sets tasks in inner list
	* @param tasksIds
	*/
	public void setTasks( String tasksIds ){
		
		this.tasks = DAOFactory.getInstance().getTasks( tasksIds );
	}
	
	/**
	* puts all tasks percentages in 100%
	*/
	public void markCompleteTasks(){
		
		haveTasksPermissions( this.tasks );
		List<ProjectTask__c> tasks = new List<ProjectTask__c>();
		
		for( ProjectTask__c task: this.tasks ){
			task.PercentCompleted__c = 100;
			tasks.add( task );
		}
				
		ProjectUtil.setTaskDependenciesFlag( false );
				
		try{
			update tasks;
		}catch( Exception e ){
			throw new CustomException('Updateing error. It may be because there are tasks that have children.');
		}finally{
			ProjectUtil.setTaskDependenciesFlag( true );
		}
	}
	
	/**
	* checks if all given tasks can be modified by the current user.
	* @param tasks a ProjectTask__c list
	*/
	public void haveTasksPermissions( List<ProjectTask__c> tasks ){
		
		List<ProjectTask__c> tasksError = new List<ProjectTask__c>();
		if( !DAOFactory.getInstance().isCRMAdministrator() ){
			if( !DAOFactory.getInstance().isProjectAdministrator(this.id) ){
				for( ProjectTask__c task : tasks ){
					if( task.OwnerId == Userinfo.getUserId() || DAOFactory.getInstance().isTaskAssigned(task)){
						throw new CustomException('Insufficient privileges to update task(s)');
					}
				}
			}
		}
	}
	
	/**
	* @return workingHours
	*/
	public Integer getWorkingHours(){
		return this.workingHours;	
	}
	
	/**
	* @param d
	*/
	public void setWorkingHours( Double value ){
		this.workingHours = value.intValue();
	}

	/**
	* Set avatar for the project 
	*@param Attacment
	*/	
	public void setAvatar( Attachment avatar ){
		
		avatar.ParentId = this.id;
		insert avatar;
		
		Project2__c pr = [ SELECT Id, Picture__c FROM Project2__c WHERE Id =: this.id LIMIT 1 ];
		pr.Picture__c = avatar.id;
		update pr;
	}
	
	/**
	* Add an attachment 
	* @param attachment
	*/	
	public void addAttachment( Attachment att ){
		att.ParentId = this.id;
		insert att;
		
	}
	
	/**
	* @return workingHours
	*/
	public ProjectTask__c getTaskByCustomId( String customId ){
		return DAOFactory.getInstance().getTaskByCustomId( customId );
	}
	
	/**
	* 
	* @return attachments
	*/
	public List<AttachmentObj> getAttachments(){
		
		this.attachments = DAOFactory.getInstance().getAttachments( this.id );
		
		return this.attachments;
	}
	
	/**
    * Test 
    */
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
		
		Test.setCurrentPageReference( new PageReference( 'Page.ProjectDetail' ) );
		System.currentPageReference().getParameters().put( 'id', GenerateEnvironmentTest.project.id );

		
    	Test.stopTest();
		ProjectUtil.setIsTest( false );    	
    }
}