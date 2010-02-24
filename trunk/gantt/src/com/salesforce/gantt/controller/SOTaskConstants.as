package com.salesforce.gantt.controller
{
	public class SOTaskConstants
	{
		private static const suffix : String			= '__c';
		public static const ID : String 				= 'Id';
		public static const CID : String				= 'Id'+suffix;
		public static const NAME : String				= 'Name';
		public static const STARTDATE : String			= 'StartDate'+suffix;
		public static const ENDDATE : String			= 'EndDate'+suffix;
		public static const DURATION : String			= 'DurationUI'+suffix;
		public static const POSITION : String			= 'TaskPosition'+suffix;
		public static const COMPLETED : String			= 'PercentCompleted'+suffix;
		public static const ISMILESTONE : String		= 'Milestone'+suffix;
		public static const PRIORITY : String			= 'Priority'+suffix;
		public static const PARENT: String				= 'ParentTask'+suffix;
		public static const DESCRIPTION: String			= 'Description'+suffix;
		public static const LASTMODIFIEDDATE : String	= 'LastModifiedDate';
		public static const STATUS : String				= 'Status'+suffix;
		public static const INDENT : String				= 'Indent'+suffix;
		public static const IMAGE : String				= 'Image'+suffix;
		public static const TYPE : String				= 'type';
		public static const PROJECT : String			= 'Project'+suffix;
		public static const PROPERTIES : String			= 'properties';
	}
}