package com.salesforce.gantt.model
{
	import com.salesforce.gantt.controller.Components;
	[Bindable]
	
	public class Calendar
	{
		public static var startDate : Date = new Date();
		public static var endDate : Date = new Date();
		public static var daysInWorkWeek : Number;
		
		/**
		 * Increase a period of days a date
		 */
		public static function add(date : Date, days : Number): Date 
		{
			return new Date(date.getTime() + days * 24 * 60 * 60 * 1000);
		}
		
		/**
		 * Add hours to a date
		 */
		public static function addHours(date : Date, hours : Number): Date 
		{
			return new Date(date.getTime() + hours * 60 * 60 * 1000);
		}
		
		/**
		 * Convierte una fecha a un valor, el cual multiplicado por la escala representa la posicion left en el gantt
		 */
		 public static function toDay(date : Date) : Number
	     {
	     	return Math.round( (date.getTime() - startDate.getTime() ) / 1000 / 60 / 60 / 24);
	     }
	     /**
		 * Converts days to milliseconds
		 * days the number  of days to convert to millisecond
		 */
	     public static function toMillis (days : Number) : Number
	     {
	    	return ( days * 24 * 60 * 60 * 1000 );
	     }
	     /**
		 * formats the date object to a String 
		 * format is the format that the date will be returned as:
		 * 1. mm/dd/yyyy
	     * 2. mm/dd/yy
	     * 3. database (default) for example 2007-06-15T16:37:00.000Z
		 */
		 	     
	     public static function toString (date : Date, format : String = "database") : String
	     {
	     	var month : int = date.getMonth() + 1;
			var concatMonth : String = "";
			if(month<10)
			{
				concatMonth = "0";
			}
			var concatDay : String = "";
			if(date.getDate()<10)
			{
				concatDay = "0";
			}
			if(format == "mm/dd/yyyy")
	 	 	{
				return concatMonth + month.toString() + "/" + concatDay + date.getDate().toString() + "/" + date.getFullYear().toString();
	 	 	}
	 	 	else if(format == "mm/dd/yy")
	 	 	{
				return concatMonth + month.toString() + "/" + concatDay + date.getDate().toString() + "/" + date.getFullYear().toString().substr(2, 2);
	 	 	}
	 	 	else if(format == "database")
	 	 	{
				return date.getFullYear().toString()+"-"+concatMonth+month.toString()+"-"+concatDay+date.getDate().toString()+"T00:00:00.000Z";
	 	 	}
	  	    return '';	
	     } 
	     /**
	     * Return true if a date is a weekend day
	     * Otherwise false
	     * @param date
	     */
	     public static function isWeekend(date : Date) : Boolean
	     {
	     	var isWeekendDay : Boolean = false;
	     	var day : int;
	     	day = (date.getDay() + 6) % 7;
	     	isWeekendDay = day >= daysInWorkWeek;
	     	
	     	return isWeekendDay;
	     }	
	     /**
	     * Return true if the date is the first day of the month
	     * Otherwise false
	     * @param date
	     * @return a boolean
	     */
	     public static function isFirstDayOfTheMonth(date : Date) : Boolean
	     {
	     	var dateTemp : Date = add(date, -1);
	     	return (dateTemp.getMonth() != date.getMonth());
	     }
	     
	     /**
	     *  Add the days to the duration when there are weekend days
	     * @param start 	: start date
	     * @param end 		: end date
	     * @return a new duration with days added for weekend
	     */
	     public static function addDaysForWeekend(start : Date,end : Date) : int{
	     	var temp : Date = new Date(start.getTime());
	     	var duration : int = 1;
	     	while(!equals(temp,end)){
	     		if(isWeekend(temp)){
	     			duration++;
	     		}
	     		duration++;
	     		temp = add(temp,1);
	     	}
	     	return duration ;
	     }
	     
		 public static function durationInDays(start : Date,end : Date) : Number{
		 	var strictStartDate : Date = new Date(start.getFullYear(),start.getMonth(),start.getDate());
		 	var strictEndDate : Date = new Date(end.getFullYear(),end.getMonth(),end.getDate());
		 	var days : Number = (Math.ceil((strictEndDate.getTime() - strictStartDate.getTime())/(24*60*60*1000)))+1;
		 	return days;
		 }	
		 
		 /**
		 *  Two date are equals when they have the same year,month,day
		 * @param day1
		 * @param day2
		 * @return a value true or false
		 */ 
		 public static function equals(day1 : Date,day2 : Date) : Boolean{
		 	var equal : Boolean = day1.getFullYear() == day2.getFullYear() && 
		 						  day1.getMonth() == day2.getMonth() &&
		 						  day1.getDate() == day2.getDate();
		 	return equal;
		 }
		 
		 /**
		 * Returns if the date day1 is less than date day2
		 * @param day1
		 * @param day2
		 * @return a value true or false
		 */ 
		 public static function less(day1 : Date,day2 : Date) : Boolean{
		 	var less : Boolean = day1.getFullYear() <= day2.getFullYear();
		 	less &&= day1.getMonth() <= day2.getMonth();
		 	less &&= day1.getDate() < day2.getDate();
		 	//var less : Boolean = day1.getTime() < day2.getTime();
		 	return less;
		 }
		 
		 
		 /**
		 * Calculate the next workday
		 * @param date
		 * @param days
		 * @return int : returns the next workday
		 */
		 public static function addWorkDay(date : Date,days : int) : Date{
		 	var nextDay : Date = new Date(date.getTime());
		 	while(isWeekend(nextDay)){
		 		nextDay = add(nextDay,days);
		 	}
		 	return nextDay;
		 } 
		 
		 /**
		 * Calculate the next work day given a duration of workdays
		 * @param start : the start date
		 * @param duration : a period of workdays in days
		 * @return Date : returns the next work day after a duration
		 */
		public static function nextWorkDate(start : Date, duration : Number) : Date{
			return calcWorkDate(start,duration,+1);
		}
		
		 /**
		 * Calculate the previous work day given a duration of workdays
		 * @param start : the end date
		 * @param duration : a period of workdays in days
		 * @return Date : returns the previous work day after a duration
		 */
		public static function previousWorkDate(end : Date, duration : Number) : Date{
			return calcWorkDate(end,duration,-1);
		}
		
		/**
		 * Calculate the working days given a range of dates
		 * @param start : the start date
		 * @param end : the end date
		 * @return int : returns the working days
		 */
		public static function workingDays(start : Date, end : Date) : int{
			var nextDate : Date = new Date(start.getTime());
			var workingDays : int = 1;
			while(less(nextDate,end)){
				nextDate = add(nextDate,1);	
				if(!isWeekend(nextDate)){
					workingDays++;
				};
			}; 		
			return workingDays;
		}
		
		/*
		* Checks if the difference between last task's endDate and fist task's start date is
		* grater than 1 month.
		*
		*@return True in case the difference is grater than a month.
		*/
		public static function isMoreOfAMonth() :Boolean{
			//return ((Calendar.toDay(TaskDate.endDate) - Calendar.toDay(TaskDate.startDate)) > 31);
			//TODO remove coupling with tasks collection
			var firstTask : Task = Components.instance.tasks.firstTask();
			return ((Calendar.toDay(Calendar.endDate) - Calendar.toDay(firstTask.startDate)) > 31);
		}
		
		private static function calcWorkDate(date : Date,duration : Number, towards : int ) : Date{
			var workDate : Date = new Date(date.getTime());
			var workDays : int = Math.ceil(duration) - 1;
			while(workDays>0){
				workDate = add(workDate,towards);	
				if(!isWeekend(workDate)){
					workDays--;
				};
			};
			return workDate;
		}
		    
	}
}