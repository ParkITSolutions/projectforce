/**
*@author: Nicolas Gunther - July 9, 2009
*/
public class ProjectTaskDuration {

	/**
	* Class constructor
	*/
	public ProjectTaskDuration (){
	}

	/**
	* Calculate task end date
	*@param task instance
	*@return task instance with new end date
	*/
	public ProjectTask__c doCalculateEndDate (ProjectTask__c task){
		
    	if(task.Project__c != null){

			Project2__c project = [select Id, DisplayDuration__c, WorkingHours__c, DaysInWorkWeek__c from Project2__c where Id =: task.Project__c];

			if(project.DisplayDuration__c.equals('Days')){
				task.EndDate__c = this.doCalculateEndDateInDays(task, Integer.valueOf(project.DaysInWorkWeek__c));
			}else{
				task.EndDate__c = this.doCalculateEndDateInHours(task, project);
			}	

    	}
    	return task; 
	}
	
	/**
	* Calculate EndDate from Duration field in Days
	*@param task instance
	*@param number of work days
	*@retrun task end date
	*/
	public Date doCalculateEndDateInDays (ProjectTask__c task, Integer wdays){
	
		Integer days = task.Duration__c.intValue();
		return this.doExcludeNonWorkingDays(task.StartDate__c, wdays, days);
	
	}
	
	/**
	*@param task instance
	*@param project instance
	*@return task end date
	*/
	public Date doCalculateEndDateInHours(ProjectTask__c task, Project2__c project){
		
		Integer hours = project.WorkingHours__c.intValue();
		Integer wdays = Integer.valueOf(project.DaysInWorkWeek__c);
		Integer days = (Decimal.valueOf(task.Duration__c / hours).round(System.Roundingmode.CEILING).intValue());		
		System.debug('ROCK> W: ' + wdays + ' D: ' + days);
		return this.doExcludeNonWorkingDays(task.StartDate__c, wdays, days);
	
	}
	
	/**
	* Get work week days
	*@param number of workdays
	*@return work days names
	*/
	public Set<String> getWorkDays(Integer days){
		List<String> weekdays = new List<String>{'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'};
		Set<String> workdays = new Set<String>();
		
		for(Integer i = 0; i < days; i++){
			workdays.add(weekdays[i]);	
		}
		
		return workdays;
	}
	
	/**
	* Exclude non working days and retrun end date
	*@param task start date
	*@param working days
	*@param duration in days
	*@return task end date
	*/
	public Date doExcludeNonWorkingDays (Date startDate, Integer wdays, Integer days){
		
		Set<String> workdays = this.getWorkDays(wdays);
		Datetime myDate = Datetime.valueOf(startDate + '00:00:00');
		String weekday = '';		
		
		for(Integer i = 0; i < days; i++){
			myDate = myDate.addDays(1);
			weekday = myDate.format('EEE');
			if(!workdays.contains(weekday)){
				days++;
				System.debug('ROCK> Este no va:' + weekday);
			}else{
				System.debug('ROCK> Este va:' + weekday);
			}
		}
		return Date.newInstance(myDate.year(), myDate.month(), myDate.day());	
	}
	
}