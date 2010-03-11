/** 
*@author: Nicolas Gunther - July 9, 2009
*/
public class ProjectTaskDuration {

	private String displayDuration; 
	private Double workingHours; 
	private String daysInWorkWeek; 
	
	/**
	* Class constructor
	*/
	public ProjectTaskDuration (ProjectTask__c task){
		
		Project2__c project = [select Id, DisplayDuration__c, WorkingHours__c, DaysInWorkWeek__c 
								from Project2__c 
								where Id =: task.Project__c];
		
		this.displayDuration = project.DisplayDuration__c;
		this.workingHours = project.WorkingHours__c;
		this.daysInWorkWeek = project.DaysInWorkWeek__c;
		
	}

	/**
	* Method used to validate duration entry field
	* @param ProjectTask__c task
	* @return Boolean
	*/
	public Boolean validateDurationInput(ProjectTask__c task){
		
		String regex = task.DurationUI__c;
		String result = regex.replaceAll('\\d[0-9]*[\\\\.\\d{0,2}]?[h,d,H,D]?','');
		
		if( result != '' ){
			return false;
		}
		else{
			return true;
		}
		
	}

	/**
	* Method which will calculate a tasks or milestones start date, end date, and duration values correctly when inserted
	* @param ProjectTask__c task
	* @param Project2__c projectInfo
	* @return ProjectTask__c
	*/
	public ProjectTask__c calculateTaskInsert( ProjectTask__c task ){
		
		if( task.Milestone__c == true ){
			
			task = this.verifyStartDate( task );
			task.EndDate__c = null;
			if( this.displayDuration.equals( 'Days' ) ){
				task.DurationUI__c 	= '1.0';
				task.Duration__c 	= 1.0;
			}
			else{
				task.Duration__c 	= this.workingHours; 
				task.DurationUI__c 	= '\'' + this.workingHours + '\'';
			} 
		}
		else{
			task = this.verifyStartDate( task );
			task = this.verifyEndDate( task );

			if( task.EndDate__c == null ){
				task = this.parseDuration( task );
					 				
				if( this.displayDuration.equals( 'Days' ) ){
					task.EndDate__c = this.doCalculateEndDateInDays( task, Integer.valueOf( this.daysInWorkWeek ) );
				}
				else{
					task.EndDate__c = this.doCalculateEndDateInHours( task );
				}	
			}
			else{
		 		task = this.doCalculateDuration(task);
		 		task = this.parseDuration(task);
			}
		}
		
		return task;
	}

	/**
	* Method which will calculate a task or milestones start date, end date, and duration values correctly when Updated
	* @param ProjectTask__c tempPTOld
	* @param ProjectTask__c tempPTNew
	* @param Project2__c projectInfo
	* @return ProjectTask__c
	*/
	public ProjectTask__c calculateTaskUpdate(ProjectTask__c tempPTOld, ProjectTask__c tempPTNew){
	
		if(tempPTNew.Milestone__c == true){
			
			tempPTNew = this.verifyStartDate(tempPTNew);
			tempPTNew.EndDate__c = null;
			tempPTNew.DurationUI__c = '1.0';
			tempPTNew.Duration__c = 1.0; 
		}
		else{
			
			//trial correccion for bug 4464
			if(tempPTOld.EndDate__c == tempPTNew.EndDate__c){
				tempPTNew = this.verifyStartDate2(tempPTNew);
			}
			else{
				tempPTNew = this.verifyStartDate(tempPTNew);
			}
			
			tempPTNew = this.verifyEndDate(tempPTNew);
				
		    if(tempPTNew.EndDate__c != null && tempPTOld.EndDate__c != null){
		    	if(tempPTOld.EndDate__c != tempPTNew.EndDate__c || tempPTOld.StartDate__c != tempPTNew.StartDate__c){
		 			tempPTNew = this.doCalculateDuration(tempPTNew);
		    	}
		    }
		    	
		    if(tempPTOld.DurationUI__c != tempPTNew.DurationUI__c || tempPTNew.EndDate__c == null){
		 		tempPTNew = this.parseDuration(tempPTNew);
		 		if(this.displayDuration.equals('Days')){
					tempPTNew.EndDate__c = this.doCalculateEndDateInDays(tempPTNew,Integer.valueOf(this.daysInWorkWeek));
				}
				else{
					tempPTNew.EndDate__c = this.doCalculateEndDateInHours(tempPTNew);
				}	
		    }
		}
		
		return tempPTNew;
	}
	
	/**
	* Calculate task end date
	*@param task instance
	*@return task instance with new end date
	*/
	public ProjectTask__c doCalculateEndDate (ProjectTask__c task){
		
    	if(task.Project__c != null){ 

			if(this.displayDuration.equals('Days')){
				task.EndDate__c = this.doCalculateEndDateInDays(task, Integer.valueOf(this.daysInWorkWeek));
			}else{
				task.EndDate__c = this.doCalculateEndDateInHours(task);
			}	

    	}
    	return task; 
	}
	
	/**
	* Calulates duration with start and end date
	*@param task start date
	*@param task end data
	*@retrun duration
	*/
	public ProjectTask__c doCalculateDuration (ProjectTask__c task){
		
		Integer days;
		Integer duration;
		
		if(task.Project__c != null){
			
			days = this.doExcludeNonWorkingDays(task.StartDate__c, task.EndDate__c, Integer.valueOf(this.daysInWorkWeek));
			
			if(this.displayDuration.equals('Days')){
				duration = days;
			}else{
				duration = (Decimal.valueOf(days * this.workingHours).round(System.Roundingmode.CEILING).intValue());
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
	* Calculate EndDate from Duration field in Hours
	*@param task instance
	*@param project instance
	*@return task end date 
	*/
	public Date doCalculateEndDateInHours(ProjectTask__c task){
		
		Integer hours = this.workingHours.intValue();
		Integer wdays = Integer.valueOf(this.daysInWorkWeek);
		Integer days = (Decimal.valueOf(task.Duration__c / hours).round(System.Roundingmode.CEILING).intValue());		
		
		return this.doExcludeNonWorkingDays(task.StartDate__c, wdays, days);
	
	}
	
	/**
	* Get work week days from project
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
		if(days > 1000){
			days = 1000;
		}
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
		
		while( !myDate.isSameDay(Datetime.valueOf(endDate + '00:00:00')) && days < 400){
			weekday = myDate.format('EEE');
			if(workdays.contains(weekday))
				days++;
			myDate = myDate.addDays(1);
		}
		return days;	
	}
	
	/**
	* Method for verifying start date is always on a valid working day
	* @param ProjectTask__c task
	* @param Project2__c project
	* @return ProjectTask__c
	*/
	public ProjectTask__c verifyStartDate(ProjectTask__c task){
		
		Set<String> workdays = this.getWorkDays( Integer.valueOf(this.daysInWorkWeek));
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
	public ProjectTask__c verifyStartDate2(ProjectTask__c task){
		
		Set<String> workdays = this.getWorkDays( Integer.valueOf(this.daysInWorkWeek));
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
			}	
		}
		return task;
	}
	
	/**
	* Method for verifying end date is always on a valid working day
	* @param task
	* @return task
	*/
	public ProjectTask__c verifyEndDate( ProjectTask__c task ){
		
		if( task.EndDate__c  != null ){
			Set<String> workdays 	= this.getWorkDays( Integer.valueOf(this.daysInWorkWeek ) );
			Datetime myDate 		= Datetime.valueOf( task.EndDate__c + '00:00:00' );
			Datetime myStartDate 	= Datetime.valueOf( task.StartDate__c + '00:00:00' );
			String weekday 			= '';		
			boolean isCorrect 		= false;
			
			while( isCorrect == false ){
				weekday = myDate.format( 'EEE' );
				if( workdays.contains( weekday ) ){
					isCorrect 		= true;
					task.EndDate__c = Date.newInstance( myDate.year(), myDate.month(), (myDate.day()) );
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
	public ProjectTask__c parseDuration( ProjectTask__c task ){
		String input;
		if( task.DurationUI__c != null ){
			input = task.DurationUI__c; 
		}
		else{
			input = String.valueOf( task.Duration__c ); 
		}
		
		boolean isDays  = false;
		boolean isHours = false;
		
		isDays 	= input.contains('d') || input.contains('D');
		isHours = input.contains('h') || input.contains('H');
		
		if( isDays && isHours ){
			//error msg
		}
		
		if( !isDays && !isHours ){
			//no Hour / Days conevention used
			Double inputAux  = Double.valueOf(input);
			if( input.equals('0') || input.equals('0.0') || input.equals('0.00') || inputAux == 0.0 ){
				input = '1';
			}
			
			if( !this.displayDuration.equals('Days') ){
				//to deal with decimal hour values
				Double valueAux = Math.floor( Double.valueOf( input ) ) ;
				if( valueAux == 0.0 ){
					valueAux = 1.0;
				}
				input = String.valueOf(valueAux);
			}
			else{
				input = this.calculateDurationDays( input );
			}
			this.insertRawDuration(task, this.displayDuration, input, this.workingHours, 'none');
		}
		
		if(isDays){
			input = this.replaceDays(input);
			Double valueAux = Math.floor( Double.valueOf(input) ) ;
			//ACA esta el bug!!!!
			if(valueAux == 0.0){
				input = '1.0';
			}
			this.insertRawDuration(task, this.displayDuration, input, this.workingHours, 'days');
			
			if(this.displayDuration.equals('Days')){
				input = this.calculateDurationDays(input);
			}
			else{
				input = this.calculateDurationHours(input, this.workingHours);
			}
		}
		
		if(isHours){
			input = this.replaceHours(input);
			Double valueAux = Math.floor( Double.valueOf(input) ) ;
			if(valueAux == 0.0){
				input = '1.0';
			}
			this.insertRawDuration(task, this.displayDuration, input, this.workingHours, 'hours');
			
			if(this.displayDuration.equals('Days')){
				input = this.calculateDurationDays(input, this.workingHours);
			}
			else{
				//do nothing Project already in Hours
			}
		}
		
		if(this.displayDuration.equals('Days')){
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
	* for future calculations this value will be usefull
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
	* Method for striping duration of hour / Days convention characters
	* @param String value
	* @return String
	*/
	public String replaceHours(String value){
		
		if(value.contains('h')){
			value = value.replace('h', '');
		}
		else{
			value = value.replace('H', '');
		}
		value = value.trim();	
		Double valueAux = Double.valueOf(value);
		if(value.equals('0') || value.equals('0.0') || value.equals('0.00') || valueAux == 0.0){
			value = '1';
		}
		return value;
	}
	
	/**
	* Method for striping duration of hour / Days convention characters
	* @param String value
	* @return String
	*/
	public String replaceDays(String value){
		
		if(value.contains('d')){
			value = value.replace('d', '');
		}
		else{
			value = value.replace('D', '');
		}
		value = value.trim();
		Double valueAux = Double.valueOf(value);
		if(value.equals('0') || value.equals('0.0') || value.equals('0.00') || valueAux == 0.0){
			value = '1';
		}
		return value;
	}
	
	/**
	*
	* @param String value
	* @param Double workingHours	
	* @return String
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
	* @param String value
	* @return String
	*/
	public String calculateDurationDays(String value){

		Double input1 = Double.valueOf(value); 
 		Double CompleteValue = Math.ceil(100 * input1) / 100;
		Double aux = CompleteValue * 100; 
		Integer aux2 =  Math.mod(aux.intValue(),100);
		Double aux3 = Double.valueOf(String.valueOf(aux2));
		CompleteValue = Math.floor( CompleteValue ) + 0.25 * Math.ceil( aux3 / 25 );
		
		return String.valueOf(CompleteValue);
	}
	
	/**
	*
	* @param String value
	* @param Double workingHours
	* @return String
	*/
	public String calculateDurationHours(String value, Double workingHours){
		Double days = Double.valueOf(value);
		Double hours = days * workingHours;
		value = String.valueOf(hours);
		return value;
	}
	
}