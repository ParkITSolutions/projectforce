/**
* @author Matias Menafra @ 12/17/2009
*/
public class Task{

	public Double duration;
	public String durationDisplay;
	public Double percentCompleted;
	public String percentCompletedDisplay;
	public String projectName;
	public String projectNameDisplay;
	public String name;
	public String nameDisplay;
	
	public Boolean canUpdate 			{ set; get; }
	public Boolean canDelete 			{ set; get; }
	public Boolean canRead 				{ set; get; }
	public Boolean canCreateAttachments { set; get; }
	public Boolean canDeleteAttachments { set; get; }
	public Boolean canCreateAssignees 	{ set; get; }
	public Boolean canDeleteAssignees 	{ set; get; }
	
	public Date 	startDate 				{ set; get; }
	public String 	startDateDisplay 		{ set; get; }
	public Date 	endDate 				{ set; get; }
	public String  	daysOverdue				{ set; get; }
	public Boolean 	overdue		 	    	{ set; get{ return settingDaysOverdue();}}
	public String 	endDateDisplay 	    	{ set; get; }
	public String 	description 			{ set; get; }
	public String 	id 						{ set; get; }
	public String 	idDisplay 				{ set; get; }
	public Integer 	indent 					{ set; get; }
	public Boolean 	isExpanded 				{ set; get; }
	public Boolean 	isMilestone 			{ set; get; }
	public String 	parentTask 				{ set; get; }
	public String 	priority 				{ set; get; }
	public String 	project 				{ set; get; }
	public Integer 	rawDuration 			{ set; get; }
	public String 	status 					{ set; get; }
	public Double 	taskPosition 			{ set; get; }
	public String 	ownerId		 			{ set; get; }
	public List<TaskAssignee> assignees 	{ set; get; }

	/**
	* Constructor 
	*/
	public Task(){
		this.canUpdate 				= false;			
		this.canDelete 				= false;		
		this.canRead 				= false;				
		this.canCreateAttachments 	= false;	
		this.canDeleteAttachments 	= false;	
		this.canCreateAssignees 	= false;	
		this.canDeleteAssignees 	= false;	
	}
	
	/**
	* Returns the number of days between today and task end date. 
	* @return Integer
	*/
	public Integer getOverdueTask(){
		return this.endDate == null ? 0 : this.endDate.daysBetween( System.today() );
	}
	
	/**
	* Return task duration as Double type
	* @return Double
	*/
	public Double getDuration(){
		return this.duration;
	}
	
	/**
	* Se duration (Double) and durationDisplay (String) properties
	* @param Double d
	* @return void
	*/
	public void setDuration( Double d ){
		this.duration = d;
		this.durationDisplay = String.valueOf( d );
	}

	/**
	* Return duration as String
	* @return String
	*/
	public String getDurationDisplay(){
		return this.durationDisplay;
	}

	/**
	* Setter for percent completed
	* @param Double p
	* @return void
	*/
	public void setPercentCompleted( Double p ){
		this.percentCompleted = p == null ? 0.0 : p;
		this.setPercentCompletedDisplay( String.valueOf( this.percentCompleted.intValue()));
	}
	
	/**
	* Getter for percent completed
	* @return Double
	*/
	public Double getPercentCompleted(){
		return this.percentCompleted;
	}
	
	/**
	* Setter for percent completed
	* @return String
	*/
	public String getPercentCompletedDisplay(){ 
		return PercentCompletedDisplay;
	}
	
	/**
	* Set the percent completed value for display.
	* @param String
	*/
	public void setPercentCompletedDisplay( String d ){
		this.percentCompletedDisplay = d;
	}
	
	/**
	* Set the project
	* @param String
	*/
	public void setProjectName( String pName ){
		this.projectName = pName;
		this.projectNameDisplay = ProjectUtil.chopPhrase( pName );
	}
	
	/**
	* Return the project name
	* @return String
	*/
	public String getProjectName(){
		return this.projectName;
	}
	
	/**
	* Return the project name of the task for display.
	* @return String
	*/
	public String getProjectNameDisplay(){
		return this.projectNameDisplay;
	}
	
	
	/**
	* Setter for the task name
	* @param String
	*/
	public void setName( String name ){
		this.name = name;
		this.nameDisplay = ProjectUtil.chopPhrase( name, 40 );
	}
	
	/**
	* Return the task name
	* @return String
	*/
	public String getName(){
		return this.name;
	}
	
	/**
	* Return the tak name for display
	* @return String
	*/
	public String getNameDisplay(){
		return this.nameDisplay; 
	}
	
	/**
	* Add an attachment 
	* @param att 
	*/
	public void addAttachment( Attachment att ){ 
		DAOFactory.getInstance().insertAttachment( att, this.id );	
	}
	
	/**
	* Setting overdue flag and days overdue message.
	*/
	private Boolean settingDaysOverdue(){
		Integer localDaysOverdue;
		if( this.endDate != null )
		localDaysOverdue = this.endDate.daysBetween( Date.today());
		 
		this.daysOverdue = localDaysOverdue + 'day(s) overdue.';
		return localDaysOverdue > 0;
	}
	
}