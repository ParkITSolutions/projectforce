/**
*@author Matias Menafra @ 12/17/2009
*/
public class Task {
	
	public String 	description 		{ set; get; }
	public Double 	duration 			{ set; get; }
	public String 	durationDisplay 	{ set; get; }
	public String 	id 					{ set; get; }
	public String 	idDisplay 			{ set; get; }
	public Integer 	indent 				{ set; get; }
	public Boolean 	isExpanded 			{ set; get; }
	public Boolean 	isMilestone 		{ set; get; }
	public String 	parentTask 			{ set; get; }
	public Double 	percentCompleted 	{ set; get; }
	public String 	priority 			{ set; get; }
	public String 	project 			{ set; get; }
	public String 	projectName			{ set; get; }
	public Integer 	rawDuration 		{ set; get; }
	public String 	status 				{ set; get; }
	public Double 	taskPosition 		{ set; get; }
	public String 	name 				{ set; get; }
	public Date 	startDate 			{ set; get; }
	public String 	startDateDisplay 	{ set; get; }
	public Date 	endDate 			{ set; get; }
	public String 	endDateDisplay 	    { set; get; }
	public List<ProjectMember> 	assignees 	{ set; get; }
	
	/**
	* Constructor
	*/
	public Task(){
	
	}
	
	public void markComplete(){
	
	}
	
	public Integer getOverdueTask(){
		return this.endDate != null ? this.endDate.daysBetween(System.today()) : 0 ;
	}
}