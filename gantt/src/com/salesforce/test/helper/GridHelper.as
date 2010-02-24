package com.salesforce.test.helper
{
	import com.salesforce.gantt.controller.Components;
	
	import flash.events.EventDispatcher;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import mx.controls.TextInput;
	import mx.core.Application;
	import mx.events.ListEvent;
	
	public class GridHelper extends EventDispatcher
	{
		private static  var _instance : GridHelper; 
		private var taskList = Application.application.mainView.taskList;
		private var writingTextInput : TextInput= taskList.writingText;
		private var validCommand : Boolean = false;
		
		
		public static function get instance() : GridHelper{
			if(_instance == null){
				_instance = new GridHelper();
			}
			return _instance;
		}
		
		//TODO watch the hardcode of this function.
		public function selectedCellToNewTask() : void{
			taskList.setSelectionModeCell(-1,4);
			var focusEvent : FocusEvent = new FocusEvent(FocusEvent.FOCUS_IN);
			validCommand = new Boolean(writingTextInput.dispatchEvent(focusEvent));
			var lastIndex : int = Components.instance.tasks.length();
			taskList.taskListAdvancedDataGrid.dispatchEvent(new ListEvent(ListEvent.ITEM_CLICK,false,false,-1,lastIndex));
			taskList.rowG=lastIndex;
			if(validCommand){
				dispatchEvent(focusEvent);
			}
		};
		
		public function selectRowNewTaskCreated() : void{
			clickRow(Components.instance.tasks.length()-1);
		}
		public function clickRow(row : int, col : int = -1) : void{
			var listEvent : ListEvent = new ListEvent(ListEvent.ITEM_CLICK,true,false,col,row);
			validCommand = new Boolean(taskList.taskListAdvancedDataGrid.dispatchEvent(listEvent));
			taskList.rowG = row;
			taskList.colG = col;
			if(validCommand){
				dispatchEvent(listEvent);
			}
		}
		
		public function editSelectedCell(row : int ,col : int): void{
			clickRow(row,col);
			var enterEvent : KeyboardEvent = new KeyboardEvent(KeyboardEvent.KEY_DOWN,true,false,0,Keyboard.ENTER);
			writingTextInput.dispatchEvent(enterEvent);
			dispatchEvent(enterEvent);
		}
		
		public function doubleClickCell(row : int ,col : int) : void{
			clickRow(row,col);
			var doubleClickEvent : MouseEvent = new MouseEvent(MouseEvent.DOUBLE_CLICK);
			validCommand = new Boolean(writingTextInput.dispatchEvent(doubleClickEvent));
			if(validCommand){
				dispatchEvent(doubleClickEvent);
			}
		}
		
		public function clickCell(row : int ,col : int) : void{
			clickRow(row,col);
			var clickEvent : MouseEvent = new MouseEvent(MouseEvent.CLICK);
			validCommand = new Boolean(writingTextInput.dispatchEvent(clickEvent));
			if(validCommand){
				dispatchEvent(clickEvent);
			}
		}
		
		public function insertText(text : String) :void{
			writingTextInput.text = text;
		}

		public function saveEditionEnterKey() : void{
			var keyboardEvent : KeyboardEvent = new KeyboardEvent(KeyboardEvent.KEY_DOWN,true,false,0,Keyboard.ENTER); 
			validCommand = new Boolean(writingTextInput.dispatchEvent(keyboardEvent));
			if(validCommand){
				dispatchEvent(keyboardEvent);	
			}
		}
		
		public function getText() : String{
			return writingTextInput.text;
		}
		
		public function getRowTaskCreated() : int{
			return taskList.visibleTasks.length-2;
			dispatchEvent(new ListEvent(ListEvent.ITEM_CLICK));
		}
		
		public function show() : void{
			
		}
	}
}