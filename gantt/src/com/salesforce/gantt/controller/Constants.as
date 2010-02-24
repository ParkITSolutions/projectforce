package com.salesforce.gantt.controller
{
	import mx.managers.PopUpManager;
	
	
	public class Constants
	{
		public static const TASK_SELECT : String = "TASK_SELECT";
		public static const TASK_DESELECT : String = "TASK_DESELECT";
		
		public static const TASKS_ADDED : String = "TASKS_ADDED";
		public static const TASK_CENTER : String = "TASK_CENTER";
		public static const ADD_DEPENDENCY : String = "ADD_DDEPENDENCY";
		public static const ADD_TASK_RESOURCES : String = "ADD_TASK_RESOURCES";
		public static const TASK_CREATED_UPDATED : String = "TASK_CREATED_UPDATED";
		public static const UPDATE_RESOURCES_DEPENDENCIES : String = "UPDATE_RESOURCES_DEPENDENCIES";
		public static const TASK_NEXT_LINE : String = "TASK_NEXT_LINE";
		public static const	TASK_MODIFIED_BY_OTHER_WAY : String = "TASK_MODIFIED_BY_OTHER_WAY";
		public static const TESTING : String = "TESTING";
		
		public static const LEFT : String = 'left';
		public static const RIGHT : String = 'right'; 
		public static const UP : String = 'up';
		public static const DOWN : String = 'down';
		public static const CENTER : String = 'center'; 
		public static const RESIZE_COMPLETED_PERCENT : String = 'resizeCompletedPercent';
		
		public static const DURATION : String = 'duration';
		public static const PRIORITY : String = 'priority';
		public static const COMPLETED : String = 'completed';
		public static const NAME : String = 'name';
		public static const START_DATE : String = 'startDate';
		public static const ISMILESTONE : String = 'ismilestone';
		public static const FOUR_DIGIT_FORMAT : String = "mm/dd/yyyy";
		public static const END_DATE : String = 'endDate';
		public static const PARENT : String = 'parent';
		public static const DATABASE : String = 'database';
		
		public static const REFRESHDATES : String = 'dates';
		public static const TASKS_FILTERS : String = "TASKS_FILTERS";
		
		public static const defaultTaskName : String = 'Enter Name';
		
		public static const FIELD_REQUIRED : String = 'You must enter a value';
		public static const GREATER_DATE_ERROR : String = 'You must enter a greater value';
		
		public static const SYNCHRONIZING : String = 'synchronizing';
		public static const LOADING_END : String = 'loading_end';
		public static const LOADING_START : String = 'loading_start';
		public static const DETAILS_PANEL_MAX_WIDTH : int = 270;
		public static const DETAILS_PANEL_MIN_WIDTH : int = 18;
		public static const GRID_PANEL_MAX_WIDTH : int = 927;
		public static const GRID_PANEL_MIN_WIDTH : int = 27;
		
		public static const COLOR_TASK_PARENT_COMPLETED_FONT : int = 0x78B800;
		public static const COLOR_TASK_PARENT_COMPLETED_CUT_FONT : int = 0x888888;
		public static const COLOR_TASK_PARENT_INCOMPLETED_FONT : int = 0xADD364;
		public static const COLOR_TASK_PARENT_INCOMPLETED_CUT_FONT : int = 0xaaaaaa;
		public static const COLOR_TASK_PARENT_BORDER : int = 0xCFECF2;
		
		public static const COLOR_TASK_NORMAL_COMPLETED_FONT : int = 0x0D4E6B;
		public static const COLOR_TASK_NORMAL_COMPLETED_CUT_FONT : int = 0x888888;
		public static const COLOR_TASK_NORMAL_INCOMPLETED_FONT : int = 0xCA3433;
		public static const COLOR_TASK_NORMAL_INCOMPLETED_CUT_FONT : int = 0xaaaaaa;
		public static const COLOR_TASK_NORMAL_BORDER : int = 0xCFECF2;
		
		public static const COLOR_TASK_MILESTONE_FONT : int = 0xb5b5b5;
		public static const COLOR_TASK_MILESTONE_CUT_FONT : int = 0xaaaaaa;
		public static const COLOR_TASK_MILESTONE_BORDER : int = 0xd1d1d1;
		public static const COLOR_TASK_MILESTONE_BORDER_LEFT : int = 0xf1f1f1;
		public static const COLOR_TASK_MILESTONE_BORDER_RIGHT : int = 0x737373;
		public static const RECONNECTION : String = 'RECONNECTION';
		
		//messages
		public static const MESSAGE_SELECT_TASK : String 				= 'Please select a task.'
		public static const MESSAGE_MILESTONE_NOT_OPERATION : String	= 'This operation can not be applied on a milestone.'
		public static const FIELDS_ARE_REQUIRED : String				= 'Please fill the required fields';
		public static const MESSAGE_CHOOSE_TASK : String				= 'Choose a task...';
		public static const MESSAGE_CHOOSE_ANOTHER_TASK : String		= 'Please choose another task...';
		public static const MESSAGE_CHOOSE_MEMBER : String				= 'Choose a team member...';
		
		public static const PROGRESS_BAR_LOADING :String 	= 'Loading...';
		public static const PROGRESS_BAR_SYNC	: String	= 'Synchronizing...';
		public static const PROGRESS_BAR_CONNECTING : String= 'Connecting...';	
	
		public static const DURATION_DAYS : String 	= 'Days';
		public static const DURATION_HOURS : String = 'Hours';
		public static const MILLISECONDS_PER_DAY : Number	= 1000*24*60*60;
		
		public static const MAX_LENGTH_TASK_NAME_MSG : String = 'Warning: Max length reached ('+MAX_LENGTH_TASK_NAME+').';
		public static const MAX_LENGTH_TASK_DESCRIPTION_MSG : String = 'Warning: Max length reached ('+MAX_LENGTH_TASK_DESCRIPTION+').';
		
		//defaults values for static fields in task
		public static const DEFAULT_DAYS_WORK_WEEK : Number = 7;
		public static const DEFAULT_WORKING_HOURS : Number 	= 8;
		
		public static const ACTION_ADD_WRITING : String	= 'writing';
		public static const ACTION_ADD_BEFORE : String	= 'before';
		public static const ACTION_ADD_AFTER : String	= 'after';
		public static const ACTION_ADD_CHILD : String	= 'child';
		public static const ACTION_ADD_FIRST : String	= 'first';
		public static const ACTION_ADD_LAST : String	= 'last';
		public static const ACTION_ADD_CUT : String		= 'cut';
		public static const ACTION_ADD_COPY : String	= 'copy';
		
		public static const YEAR : int	=	365;
		public static const MONTH :int  =	30;
		public static const WEEK : int	=	7;
		public static const DAY : int	=	1;
		
		public static const MAX_LENGTH_TASK_NAME : int = 80;
		public static const MAX_LENGTH_TASK_DESCRIPTION : int = 3000;
		
	}
}