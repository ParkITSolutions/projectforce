/**
*@author Matias Menafra @ 12/17/2009
*/
public class Task {
	
	public String 	description 		{ set; get; }
	public String 	duration 			{ set; get; }
	public Integer 	durationDisplay 	{ set; get; }
	public Id 		id 					{ set; get; }
	public Integer 	indent 				{ set; get; }
	public Boolean 	isExpanded 			{ set; get; }
	public Boolean 	isMilestone 		{ set; get; }
	public String 	parentTask 			{ set; get; }
	public Double 	percentComplete 	{ set; get; }
	public String 	priority 			{ set; get; }
	public String 	project 			{ set; get; }
	public String 	projectName			{ set; get; }
	public Integer 	rawDuration 		{ set; get; }
	public String 	status 				{ set; get; }
	public Double 	taskPosition 		{ set; get; }
	public String 	name 				{ set; get; }
	public Date 	startDate 			{ set; get; }
	public String 	formatedStartDate 	{ set; get; }
	public Date 	endDate 			{ set; get; }
	public String 	formatedEndDate 	{ set; get; }
	
	/**
	* Constructor
	*/
	public Task(){
	
	}
	
	public void markComplete(){
	
	}
	
}