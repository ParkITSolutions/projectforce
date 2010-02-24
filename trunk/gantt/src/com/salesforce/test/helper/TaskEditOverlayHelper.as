package com.salesforce.test.helper
{
	import com.salesforce.test.IdReference;
	
	import mx.containers.Panel;
	import mx.core.Application;
	import mx.events.ListEvent;
	import mx.events.NumericStepperEvent;
	
	import net.sourceforge.seleniumflexapi.commands.CheckBoxCommands;
	import net.sourceforge.seleniumflexapi.commands.ClickCommands;
	import net.sourceforge.seleniumflexapi.commands.DateCommands;
	import net.sourceforge.seleniumflexapi.commands.PropertyCommands;
	import net.sourceforge.seleniumflexapi.commands.SelectCommands;
	import net.sourceforge.seleniumflexapi.commands.StepperCommands;
	import net.sourceforge.seleniumflexapi.commands.TextCommands;
	import net.sourceforge.seleniumflexapi.utils.AppTreeParser;
	
	public class TaskEditOverlayHelper extends BaseHelper
	{
		public static const LOW_PRIORITY : String = "2";
		public static const MEDIUM_PRIORITY : String = "1";
		public static const HIGH_PRIORITY : String = "0";
		public static const UNIT_HOURS : String = "0";
		public static const UNIT_DAYS : String = "1";
		public static const UNIT_WEEKS : String = "2";
		public static const TYPE_START_TO_FINISH : String = "0";
		public static const TYPE_FINISH_TO_START : String = "1";
		public static const TYPE_START_TO_START : String = "2";
		public static const TYPE_FINISH_TO_FINISH : String = "3";
		
		private static var appTreeParser :AppTreeParser = SeleniumFlexAPI.seleniumFlexAPI.appTreeParser;
		private static var _instance : TaskEditOverlayHelper;
		
		//private var taskEditOverlay :Canvas = Application.application.mainView.editTaskPanelWrapper;
		private var taskDetail : Panel = Application.application.mainView.editTaskPanel;
		//private var taskDependencies : Panel = Application.application.mainView.dependencies;
		//public static var taskResources  = Application.application.mainView.taskResources;
		//public static var assigneeComboBox : ComboBox = taskResources.assigneeComboBox;		
		
		function TaskEditOverlayHelper()
		{
		}
		
		public static function get instance() : TaskEditOverlayHelper{
			if (_instance == null){
				_instance = new TaskEditOverlayHelper();
			}
			return _instance;
		}
		
		public function isVisible() : Boolean{
			var result : Boolean = getResult(new PropertyCommands(appTreeParser).getFlexVisible(IdReference.TASK_EDIT_OVERLAY,null)); 
			return result;
		}
	
		public function selectStartDateToday() : String{
			new ClickCommands(appTreeParser).flexClick(IdReference.TASK_EDIT_TAB_START_DATE_TODAY,null);
			return new PropertyCommands(appTreeParser).getFlexProperty(IdReference.TASK_EDIT_TAB_START_DATE_FIELD,"selectedDate");
		}
		
		public function selectStartDate(day : String) : String{
			new DateCommands(appTreeParser).flexDate(IdReference.TASK_EDIT_TAB_START_DATE_FIELD,day);
			return new PropertyCommands(appTreeParser).getFlexProperty(IdReference.TASK_EDIT_TAB_START_DATE_FIELD,"selectedDate");
		}
		
		public function selectEndDate(day : String) : String{
			new DateCommands(appTreeParser).flexDate(IdReference.TASK_EDIT_TAB_DUE_DATE_FIELD,day);
			return new PropertyCommands(appTreeParser).getFlexProperty(IdReference.TASK_EDIT_TAB_DUE_DATE_FIELD,"selectedDate");
		}
		
		public function selectEndDateToday() : String{
			new ClickCommands(appTreeParser).flexClick(IdReference.TASK_EDIT_TAB_DUE_DATE_TODAY,null);
			return new PropertyCommands(appTreeParser).getFlexProperty(IdReference.TASK_EDIT_TAB_DUE_DATE_FIELD,"selectedDate");
		}
		
		public function addDependency() : void{
			new ClickCommands(appTreeParser).flexClick(IdReference.TASK_DEPENDENCY_TAB_ADD_DEPENDENCY_BUTTON,null);	
		}
		
		public function addAssignee() : void{
			new ClickCommands(appTreeParser).flexClick(IdReference.TASK_ASSIGNEE_TAB_ADD_ASSIGNEE_BUTTON,null);	
		}
		
		public function selectAssignee(option : String = "0") : void{
			waitForElement(IdReference.TASK_ASSIGNEE_TAB_ASSIGNEE_COMBO);
			validCommand = getResult(new SelectCommands(appTreeParser).flexSelectIndex(IdReference.TASK_ASSIGNEE_TAB_ASSIGNEE_COMBO,option));
			if(validCommand){
				dispatchEvent(new ListEvent(ListEvent.CHANGE));
			}
		}
		
		public function selectDependencyName(option : String = "0") : void{
			waitForElement(IdReference.TASK_DEPENDENCY_TAB_NAME_COMBO);
			validCommand = getResult(new SelectCommands(appTreeParser).flexSelectIndex(IdReference.TASK_DEPENDENCY_TAB_NAME_COMBO,option));
			if(validCommand){
				dispatchEvent(new ListEvent(ListEvent.CHANGE));
			}
		}
		
		public function selectDependencyLag(option : String = "0") : String{
			validCommand = getResult(new StepperCommands(appTreeParser).flexStepper(IdReference.TASK_DEPENDENCY_TAB_LAG_STEPPER,option));
			if(validCommand){
				dispatchEvent(new NumericStepperEvent(NumericStepperEvent.CHANGE));
			}
			return new StepperCommands(appTreeParser).getFlexStepper(IdReference.TASK_DEPENDENCY_TAB_LAG_STEPPER,null);
		}
		
		public function selectDependencyUnit(option : String = "0") : void{
			validCommand = getResult(new SelectCommands(appTreeParser).flexSelectIndex(IdReference.TASK_DEPENDENCY_TAB_UNIT_COMBO,option));
			if(validCommand){
				dispatchEvent(new ListEvent(ListEvent.CHANGE));
			}
		}
		
		public function selectDependencyType(option : String = "0") : void{
			validCommand = getResult(new SelectCommands(appTreeParser).flexSelectIndex(IdReference.TASK_DEPENDENCY_TAB_TYPE_COMBO,option));
			if(validCommand){
				dispatchEvent(new ListEvent(ListEvent.CHANGE));
			}
		}
		
		public function clickTaskDetailTab() : void{
			validCommand = getResult(new ClickCommands(appTreeParser).flexClick(IdReference.TASK_EDIT_TAB,null));
		}
		
		public function clickDependecyTab() : void{
			validCommand = getResult(new ClickCommands(appTreeParser).flexClick(IdReference.TASK_DEPENDENCY_TAB,null));
		}
		
		public function clickAssigneesTab() : void{
			validCommand = getResult(new ClickCommands(appTreeParser).flexClick(IdReference.TASK_ASSIGNEE_TAB,null));			
		}
		
		public function clickDeleteDependency() : void{
			new ClickCommands(appTreeParser).flexClick(IdReference.TASK_DEPENDENCY_TAB_DELETE_BUTTON,null);
		}
		
		public function clickDeleteAssignee() : void{
			new ClickCommands(appTreeParser).flexClick(IdReference.TASK_ASSIGNEE_TAB_DELETE_BUTTON,null);
		}
		
		public function insertTaskDuration(value : int) : void{
			new TextCommands(appTreeParser).flexType(IdReference.TASK_EDIT_TAB_DURATION_FIELD,value.toString());
			//taskDetail.durationEditForm.text = value.toString();
		}
		
		public function insertTaskName(value : String) : void{
			new TextCommands(appTreeParser).flexType(IdReference.TASK_EDIT_TAB_NAME_FIELD,value);
			//taskDetail.nameTaskEditForm.setFocus();
			//taskDetail.nameTaskEditForm.text = value;
		}
		
		public function insertTaskPriority(option : String = "0") : void{
			new SelectCommands(appTreeParser).flexSelect(IdReference.TASK_EDIT_TAB_PRIORITY_FIELD,option);
		}
		
		public function insertTaskDescription(value : String) : void{
			new TextCommands(appTreeParser).flexType(IdReference.TASK_EDIT_TAB_DESCRIPTION_FIELD,value);
		}
		
		public function insertTaskCompleted(value : String) : void{
			new SelectCommands(appTreeParser).flexSelect(IdReference.TASK_EDIT_TAB_COMPLETED_FIELD,value);
		}
		
		public function convertToMilestone(milestone : Boolean = true) : void{
			new CheckBoxCommands(appTreeParser).flexCheckBox(IdReference.TASK_EDIT_TAB_MILESTONE_FIELD,milestone.toString());
		}
		
		public static function validDuration() : Boolean {
			var command : TextCommands = new TextCommands(appTreeParser);
			var duration : Number = Number(command.getFlexParseInt(IdReference.TASK_EDIT_TAB_DURATION_FIELD,null));
			return duration > 0;
			
		}
		
		public static function save() : void{
			new ClickCommands(appTreeParser).flexClick(IdReference.TASK_EDIT_OVERLAY_SAVE_BUTTON,null);
		}
		
		public static function cancel(): void{
			new ClickCommands(appTreeParser).flexClick(IdReference.TASK_EDIT_OVERLAY_CANCEL_BUTTON,null);
		}
		
		public function errorTaskName(): Boolean{
			var taskNameField : String = new TextCommands(appTreeParser).getFlexText(IdReference.TASK_EDIT_TAB_NAME_FIELD,null);
			var taskNameErrorFieldVisible : Boolean = getResult(new PropertyCommands(appTreeParser).getFlexVisible(IdReference.TASK_EDIT_TAB_NAME_REQUIRED_FIELD,null));
	
			var error : Boolean = taskNameField == '' && taskNameErrorFieldVisible;
			return error;
		}
		
		public function errorDescription(): Boolean{
			var descriptionNameField : String = new TextCommands(appTreeParser).getFlexText(IdReference.TASK_EDIT_TAB_DESCRIPTION_FIELD,null);
			var descriptionTaskErrorFieldVisible : Boolean = getResult(new PropertyCommands(appTreeParser).getFlexVisible(IdReference.TASK_EDIT_TAB_DESCRIPTION_REQUIRED_FIELD,null));		
		
			var error : Boolean = descriptionNameField == '' && descriptionTaskErrorFieldVisible;
			return error;
		}
		
		public static function tabTaskDetailIsVisible() : Boolean{
			var validResult : String = new PropertyCommands(appTreeParser).getFlexVisible(IdReference.TASK_EDIT_OVERLAY,null);
			return validResult == "true";
		}
		
		public static function tabAssignesIsVisible() :Boolean {
			var validResult : String = new PropertyCommands(appTreeParser).getFlexVisible(IdReference.TASK_ASSIGNEE_OVERLAY,null);
			return validResult == "true";
		}
		
		public static function tabDependencyIsVisible() : Boolean {
			var validResult : String = new PropertyCommands(appTreeParser).getFlexVisible(IdReference.TASK_DEPENDENCY_OVERLAY,null);
			return validResult == "true";
		}
		
		public function enabledTaskDueDate() : Boolean{
			validCommand = getResult(new PropertyCommands(appTreeParser).getFlexEnabled(IdReference.TASK_EDIT_TAB_DUE_DATE_FIELD,null));
			return validCommand;
		}
		
		public function enabledTaskDuration() : Boolean{
			validCommand = getResult(new PropertyCommands(appTreeParser).getFlexEnabled(IdReference.TASK_EDIT_TAB_DURATION_FIELD,null));
			return validCommand;
		}
		
	}
}