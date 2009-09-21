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
	* Calulate duration with start and end date
	*@param task start date
	*@param task end data
	*@retrun duration
	*/
	public ProjectTask__c doCalculateDuration (ProjectTask__c task){
		
		Integer days;
		Integer duration;
		
		if(task.Project__c != null){
			
			Project2__c project = [select Id, DisplayDuration__c, WorkingHours__c, DaysInWorkWeek__c from Project2__c where Id =: task.Project__c limit 1];		
			
			days = this.doExcludeNonWorkingDays(task.StartDate__c, task.EndDate__c, Integer.valueOf(project.DaysInWorkWeek__c));
			
			if(project.DisplayDuration__c.equals('Days')){
				duration = days;
			}else{
				duration = (Decimal.valueOf(days * project.WorkingHours__c).round(System.Roundingmode.CEILING).intValue());
			}			
 
			task.Duration__c = duration;
			task.DurationUI__c = String.valueOf(duration);
		
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
		
		Double aux = math.ceil( (task.Duration__c!=null)?task.Duration__c:1);		
		Integer days = aux.intValue();
		
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
			weekday = myDate.format('EEE');
			if(!workdays.contains(weekday))
				days++;
			myDate = myDate.addDays(1);
		}
		
		if(days == 0){
			return Date.newInstance(myDate.year(), myDate.month(), (myDate.day()));	
		}
		return Date.newInstance(myDate.year(), myDate.month(), (myDate.day() - 1));	
	}
	
	/**
	* Exclude non working days and return duration (in days)
	*@param task start date
	*@param task end date
	*@param working days
	*@return task duration in days
	*/
	public Integer doExcludeNonWorkingDays (Date startDate, Date endDate, Integer wdays){
		
		Set<String> workdays = this.getWorkDays(wdays);
		Datetime myDate = Datetime.valueOf(startDate + '00:00:00');
		Integer days = 1;
		String weekday = '';
		
		while( !myDate.isSameDay(Datetime.valueOf(endDate + '00:00:00')) && days < 400 ){
			weekday = myDate.format('EEE');
			if(workdays.contains(weekday))
				days++;
			myDate = myDate.addDays(1);
		}
		return days;	
	
	}
	
	/**
	*
	*/
	public ProjectTask__c verifyStartDate(ProjectTask__c task, Project2__c project){
		
		Set<String> workdays = this.getWorkDays( Integer.valueOf(project.DaysInWorkWeek__c ));
		Datetime myDate = Datetime.valueOf(task.StartDate__c + '00:00:00');
		Datetime myEndDate;
		if(task.EndDate__c != null){
			myEndDate = Datetime.valueOf(task.EndDate__c + '00:00:00');
		}
		
		String weekday = '';		
		boolean isCorrect = false;
		
		while(isCorrect == false){
			weekday = myDate.format('EEE');
			if(workdays.contains(weekday)){ 
				isCorrect = true;
				task.StartDate__c = Date.newInstance(myDate.year(), myDate.month(), (myDate.day()));
				if(task.EndDate__c != null){
					task.EndDate__c = Date.newInstance(myEndDate.year(), myEndDate.month(), (myEndDate.day()));
				}
			}
			else{
				myDate = myDate.addDays(1);
				if(task.EndDate__c != null){
					myEndDate = myEndDate.addDays(1);
				}
			}	
		}
		
		return task;
	}
	
	/**
	*
	*/
	public ProjectTask__c verifyEndDate(ProjectTask__c task, Project2__c project){
		if(task.EndDate__c  != null){
			Set<String> workdays = this.getWorkDays( Integer.valueOf(project.DaysInWorkWeek__c ) );
			Datetime myDate = Datetime.valueOf(task.EndDate__c + '00:00:00');
			Datetime myStartDate = Datetime.valueOf(task.StartDate__c + '00:00:00');
			String weekday = '';		
			boolean isCorrect = false;
			
			while(isCorrect == false){
				weekday = myDate.format('EEE');
				if(workdays.contains(weekday)){
					isCorrect = true;
					task.EndDate__c = Date.newInstance(myDate.year(), myDate.month(), (myDate.day()));
				}
				else{
					myDate = myDate.addDays(1);
				}	
			}
		}
		return task;
	}
	
	/**
	*Method used to parse the duration entry. Taking into account the Hours / Days convention
	*@param task
	*@return ProjectTask__c
	*@author Matias Menafra
	*/
	public ProjectTask__c parseDuration(ProjectTask__c task){
		String input;
		if(task.DurationUI__c != null){
			input = task.DurationUI__c; 
		}
		else{
			input = String.valueOf(task.Duration__c); 
		}
		
		Project2__c project = [select Id, DisplayDuration__c, WorkingHours__c, DaysInWorkWeek__c 
								from Project2__c 
								where Id =: task.Project__c limit 1];
			
		boolean isDays  = false;
		boolean isHours = false;
		
		isDays = input.contains('d') || input.contains('D');
		isHours = input.contains('h') || input.contains('H');
		
		if(isDays && isHours){
			//error msg
		}
		
		if(!isDays && !isHours){
			//no Hour / Days conevention used
			if( !project.DisplayDuration__c.equals('Days') ){
				//to deal with decimal hour values
				Double valueAux = Math.floor( Double.valueOf(input) ) ;
				input = String.valueOf(valueAux);
			}
			else{
				input = this.calculateDurationDays(input);
			}
			this.insertRawDuration(task, project.DisplayDuration__c, input, project.WorkingHours__c, 'none');
		}
		
		if(isDays){
			input = this.replaceDays(input);
			this.insertRawDuration(task, project.DisplayDuration__c, input, project.WorkingHours__c, 'days');
			
			if(project.DisplayDuration__c.equals('Days')){
				input = this.calculateDurationDays(input);
			}
			else{
				input = this.calculateDurationHours(input, project.WorkingHours__c);
			}
		}
		
		if(isHours){
			input = this.replaceHours(input);
			this.insertRawDuration(task, project.DisplayDuration__c, input, project.WorkingHours__c, 'hours');
			
			if(project.DisplayDuration__c.equals('Days')){
				input = this.calculateDurationDays(input, project.WorkingHours__c);
			}
			else{
				//do nothing Project already in Hours
			}
		}
		
		if(project.DisplayDuration__c.equals('Days')){
			task.Duration__c = Double.valueOf(input);
			task.DurationUI__c = input;
		}
		else{
			task.Duration__c = task.RawDuration__c;
			task.DurationUI__c = String.valueOf( task.RawDuration__c );
		}
    	return task;
	}
	
	/**
	* Method to syncronize and store the Duration value always as a hour value.
	* for future calculations thes value will be usefull
	*@param task
	*@param displayType
	*@param duration
	*@param workingHours
	*@param param 
	*@return void
	*@author Matias Menafra
	*/
	public void insertRawDuration(ProjectTask__c task, String displayType, String duration, Double workingHours, String param){
		
		Integer value;
		Double durValue = Double.valueOf(duration);
		
		if(param == 'none'){
			if( displayType.equals('Days') ){
				Double hours = Double.valueOf( duration ) * workingHours;
				value = hours.intValue();
			}
			else{
				value = durValue.intValue();
			}
		}
		
		if(param == 'days'){
			Double hours = Double.valueOf( duration ) * workingHours;
			hours = Math.Ceil(hours);
			value = hours.intValue();
		}
		
		if(param == 'hours'){
			if( displayType.equals('Days') ){
				value = durValue.intValue();
			}
			else{
				value = durValue.intValue();
			}
		}
		
		task.RawDuration__c = value;
	}
	
	/**
	*
	*/
	public String replaceHours(String value){
		
		if(value.contains('h')){
			value = value.replace('h', '');
		}
		else{
			value = value.replace('H', '');
		}
		value = value.trim();	
		
		return value;
	}
	
	/**
	*
	*/
	public String replaceDays(String value){
		
		if(value.contains('d')){
			value = value.replace('d', '');
		}
		else{
			value = value.replace('D', '');
		}
		value = value.trim();
		
		return value;
	}
	
	/**
	*
	*/
	public String calculateDurationDays(String value, Double workingHours){
		
		Double input1 = Double.valueOf(value); 
		Integer workHours = workingHours.intValue();
		Double CompleteValue = (input1 / workHours);
		CompleteValue = Math.ceil(100*CompleteValue) / 100;
		
		Double aux = CompleteValue * 100; 
		Integer aux2 =  Math.mod(aux.intValue(),100);
		Double aux3 = Double.valueOf(String.valueOf(aux2));
		CompleteValue = Math.floor( CompleteValue ) + 0.25 * Math.ceil( aux3 / 25 );
		
		return String.valueOf(CompleteValue);
	}
	
	/**
	*
	*/
	public String calculateDurationDays(String value){
		//TODO terminar de corregir metodo para dias!!!!
		Double input1 = Double.valueOf(value); 
 		Double CompleteValue = Math.ceil(100 * input1) / 100;
		System.debug('------------------------- input1 : '+input1);
		System.debug('------------------------- CompleteValue : '+CompleteValue);
		Double aux = CompleteValue * 100; 
		System.debug('------------------------- aux : '+aux);
		Integer aux2 =  Math.mod(aux.intValue(),100);
		System.debug('------------------------- aux2 : '+aux2);
		Double aux3 = Double.valueOf(String.valueOf(aux2));
		System.debug('------------------------- aux3 : '+aux3);
		CompleteValue = Math.floor( CompleteValue ) + 0.25 * Math.ceil( aux3 / 25 );
		System.debug('------------------------- CompleteValue : '+CompleteValue);
		
		return String.valueOf(CompleteValue);
	}
	
	/**
	*
	*/
	public String calculateDurationHours(String value, Double workingHours){
		
		Double days = Double.valueOf(value);
		Double hours = days * workingHours;
		value = String.valueOf(hours);
		
		return value;
	}
	
}