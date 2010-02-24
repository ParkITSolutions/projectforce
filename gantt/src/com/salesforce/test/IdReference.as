package com.salesforce.test
{
	public class IdReference
	{
		// menu
		public static const MENU_INSERT_TASK_COMBO : String 					= "newTaskDropDown";
		public static const MENU_DELETE_BUTTON : String 						= "delete_button";
		public static const MENU_EDIT_BUTTON : String 							= "edit_button";
		public static const MENU_UNDO_BUTTON : String 							= "undo_button";
		public static const MENU_REDO_BUTTON : String 							= "redo_button";
		public static const MENU_INDENT_INDENT_BUTTON : String					= "indent_button";
		public static const MENU_INDENT_OUTDENT_BUTTON : String					= "outdent_button";
		// chart
		// tasklist
		// chartOverview
		// task renderer
		
		// task edit overlay
		public static const TASK_EDIT_OVERLAY : String							= "editTaskPanelWrapper";
		public static const TASK_EDIT_OVERLAY_SAVE_BUTTON : String				= "saveBtn";
		public static const TASK_EDIT_OVERLAY_CANCEL_BUTTON : String			= "cancelBtn";
		
		// task detail tab
		public static const TASK_EDIT_TAB : String								= "taskDetailLabelTab";
		public static const TASK_EDIT_TAB_START_DATE_TODAY : String				= "startDateToday";
		public static const TASK_EDIT_TAB_DUE_DATE_TODAY : String				= "endDateToday";	
		public static const TASK_EDIT_TAB_START_DATE_FIELD : String				= "startDateFieldEditForm";
		public static const TASK_EDIT_TAB_DUE_DATE_FIELD : String				= "endDateFieldEditForm";
		public static const TASK_EDIT_TAB_DURATION_FIELD : String				= "durationEditForm";
		public static const TASK_EDIT_TAB_NAME_FIELD : String					= "nameTaskEditForm";
		public static const TASK_EDIT_TAB_PRIORITY_FIELD : String				= "priorityTaskEditForm";
		public static const TASK_EDIT_TAB_DESCRIPTION_FIELD : String			= "descriptionTask";
		public static const TASK_EDIT_TAB_COMPLETED_FIELD : String				= "completedEditForm";
		public static const TASK_EDIT_TAB_MILESTONE_FIELD : String				= "isMilestoneEditForm";
		public static const TASK_EDIT_TAB_NAME_REQUIRED_FIELD : String			= "nameTaskEditFormRequired";
		public static const TASK_EDIT_TAB_DESCRIPTION_REQUIRED_FIELD : String	= "descriptionTaskRequired";
		
		// task dependency tab
		public static const TASK_DEPENDENCY_OVERLAY : String					= "taskLinksPanelWrapper";
		public static const TASK_DEPENDENCY_TAB : String						= "taskDependencyLabelTab";
		public static const TASK_DEPENDENCY_TAB_ADD_DEPENDENCY_BUTTON : String	= "dependenciesAddDependecyButton";
		public static const TASK_DEPENDENCY_TAB_NAME_COMBO : String				= "dependenciesNameCombo";
		public static const TASK_DEPENDENCY_TAB_UNIT_COMBO : String				= "dependenciesUnitCombo";
		public static const TASK_DEPENDENCY_TAB_LAG_STEPPER : String			= "dependenciesLagStepper";
		public static const TASK_DEPENDENCY_TAB_TYPE_COMBO : String				= "dependenciesTypeCombo";
		public static const TASK_DEPENDENCY_TAB_DELETE_BUTTON : String			= "dependenciesDeleteButton";
		
		// task assignees tab
		public static const TASK_ASSIGNEE_OVERLAY : String						= "addAsigneesPanelWrapper";
		public static const TASK_ASSIGNEE_TAB :String							= "taskAsigneesLabelTab";
		public static const TASK_ASSIGNEE_TAB_ADD_ASSIGNEE_BUTTON : String		= "taskResourcesAddAssigneeButton";
		public static const TASK_ASSIGNEE_TAB_ASSIGNEE_COMBO : String			= "assigneeComboBox";
		public static const TASK_ASSIGNEE_TAB_DELETE_BUTTON : String			= "taskResourceDeleteButton";
		
		// navigator tab
		public static const NAVIGATOR_TAB : String								= "tab_handler_overview";
		public static const NAVIGATOR_OVERVIEW : String							= "barChartOverview"
		
		// delete overlay
		public static const DELETE_OVERLAY : String 							= "deleteDialog";
		public static const DELETE_OVERLAY_CANCEL_DELETE_BUTTON	: String 		= "cancelDeleteBtn";
		public static const DELETE_OVERLAY_CONT_DELETE_BUTTON : String 			= "continueAndDeleteBtn";

		// swirling overlay
		public static const SWIRLING_OVERLAY : String							= "dragProgress";
	}
}