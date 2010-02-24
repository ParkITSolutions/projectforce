package com.salesforce.gantt.view.components.form.custom
{
	import com.salesforce.gantt.controller.Components;
	import com.salesforce.gantt.controller.SOTaskConstants;
	import com.salesforce.gantt.model.Calendar;
	import com.salesforce.gantt.model.UiTask;
	import com.salesforce.gantt.view.components.form.SFormItem;
	import com.salesforce.gantt.view.components.form.scomponent.SReference;
	import com.salesforce.gantt.view.validator.DurationValidator;
	
	import flash.events.Event;
	
	import mx.containers.Form;
	
	/**
	 * Class responsible for adding custom validation, binding and hiding some components
	 * from the form.
	 * 
	 */   
	public class CustomComponentsBinder
	{
		private var form : Form;
		private var selectedTask : UiTask;
		
		public function CustomComponentsBinder( form : Form,selectedTask : UiTask){
			this.form = form;
			this.selectedTask = selectedTask;
		}
		
		public function bind() : void {
			var milestoneFormItem : SFormItem = getByName(SOTaskConstants.ISMILESTONE);
			var startDateFormItem : SFormItem = getByName(SOTaskConstants.STARTDATE);
			var endDateFormItem : SFormItem = getByName(SOTaskConstants.ENDDATE);
			var durationFormItem : SFormItem = getByName(SOTaskConstants.DURATION);
			var priorityFormItem : SFormItem = getByName(SOTaskConstants.PRIORITY);
			var completedFormItem : SFormItem = getByName(SOTaskConstants.COMPLETED);
			
			// depending on the selected task if is a parent add the binding among milestoneItem checkBox and the 
			// priority, endDate, duration property named enabled.
			if(selectedTask.isEditable()){
				priorityFormItem.addEnableBinding(milestoneFormItem);
				endDateFormItem.addEnableBinding(milestoneFormItem);
				durationFormItem.addEnableBinding(milestoneFormItem);
			}
			
			// depending on the selected task if is a parent enable/disable the following items:
			// startDate, endDate, duration, milestone, complete percentage. 
			startDateFormItem.component.enabled = selectedTask.isEditable();
			endDateFormItem.component.enabled = selectedTask.isEditable();
			durationFormItem.component.enabled = selectedTask.isEditable();
			milestoneFormItem.component.enabled = selectedTask.isEditable();
			completedFormItem.component.enabled = selectedTask.isEditable();
			
			durationValidator();
			
			populateParentTaskList();
			
		}
		
		public function hide(isNew : Boolean) : void{
			var projectFormItem : SFormItem = getByName(SOTaskConstants.PROJECT);
			var idFormItem : SFormItem = getByName(SOTaskConstants.CID);
			var parentFormItem : SFormItem = getByName(SOTaskConstants.PARENT);
			
			// if the task is new hide the select parent option.
			if(isNew){
				form.removeChild(parentFormItem);
			}
			form.removeChild(projectFormItem);
			form.removeChild(idFormItem);
		}
		
		private function getByName(name : String) : SFormItem{
			return SFormItem(form.getChildByName(SFormItem.SFORM_PREFIX+name));
		}
		
		private function populateParentTaskList() : void{
			var parentTask : SFormItem = getByName(SOTaskConstants.PARENT);
			parentTask.component.value = selectedTask.heriarchy.parent;
			var sReference : SReference = SReference(parentTask.component);
			/*
			 TODO hardcoded title and headerColumn
			 */
			sReference.title = "Tasks";
			sReference.headerColumn = "Task Name";
			//FIXME remove the reference to Components
			sReference.dataProvider = Components.instance.tasks.possibleParentTasks(selectedTask,true);
		}		
		
		private function durationValidator() : void{
			
			var startDateFormItem : SFormItem = getByName(SOTaskConstants.STARTDATE);
			var endDateFormItem : SFormItem = getByName(SOTaskConstants.ENDDATE);
			var durationFormItem : SFormItem = getByName(SOTaskConstants.DURATION);
			
			var durationValidator : DurationValidator = new DurationValidator();
			durationValidator.required = false;
			durationValidator.source = durationFormItem.component;
			durationValidator.property = "text";
			durationValidator.triggerEvent = Event.CHANGE;
			
			durationFormItem.component.addEventListener(Event.CHANGE, 
					function(){
						//FIXME
						var duration : Number = DurationValidator.convert(String(durationFormItem.component.value),selectedTask.project.durationInHours);
						if(selectedTask.project.durationInHours){
							duration = selectedTask.project.convertToDays(duration);
						}
						endDateFormItem.component.value = Calendar.nextWorkDate(startDateFormItem.component.value as Date,duration);
					}
			)
			
			
			var dateListener : Function = function(){
						var duration : Number;
						var startDate : Date = startDateFormItem.component.value as Date;
						var endDate : Date = endDateFormItem.component.value as Date;
						if(Calendar.less(endDate, startDate)){
 							endDateFormItem.component.value = startDateFormItem.component.value;
 						}
						duration = Calendar.workingDays(startDate,endDate);
				
						if(selectedTask.project.durationInHours){
 							duration = selectedTask.project.convertToHours(duration);
 						}
 						durationFormItem.component.value = String(duration); 
					};
			startDateFormItem.component.addEventListener(Event.CHANGE,dateListener);
			endDateFormItem.component.addEventListener(Event.CHANGE,dateListener);
		}

	}
}