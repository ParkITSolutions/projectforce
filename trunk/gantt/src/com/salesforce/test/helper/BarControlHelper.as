package com.salesforce.test.helper
{

	import com.salesforce.test.IdReference;
	
	import flash.events.MouseEvent;
	
	import mx.events.ListEvent;
	
	import net.sourceforge.seleniumflexapi.commands.ClickCommands;
	import net.sourceforge.seleniumflexapi.commands.PropertyCommands;
	import net.sourceforge.seleniumflexapi.commands.SelectCommands;
	import net.sourceforge.seleniumflexapi.commands.WaitForCommands;
	
	public class BarControlHelper extends BaseHelper
	{
		private static var _instance : BarControlHelper;
		
		public static const ABOVE : String = "0";
		public static const BELOW : String = "1";
		public static const SUBTASK : String = "2";

		function BarControlHelper(){
		}
		
		public static function get instance() : BarControlHelper{
			if(_instance == null){
				_instance = new BarControlHelper();
			}
			return _instance;
		}
		
		public function clickInsertTask(option : String): void{
			validCommand = new Boolean(new SelectCommands(appTreeParser).flexSelectIndex(IdReference.MENU_INSERT_TASK_COMBO,option));
			if(validCommand){
				dispatchEvent(new ListEvent(ListEvent.CHANGE));	
			}	
		}
		
		public function clickDelete() : void{
			validCommand = new Boolean(new ClickCommands(appTreeParser).flexClick(IdReference.MENU_DELETE_BUTTON,null));
			if(validCommand){
				dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
		}
		
		public function clickEdit() : void{
			validCommand = getResult(new ClickCommands(appTreeParser).flexClick(IdReference.MENU_EDIT_BUTTON,null));
			if(validCommand){
				dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
		}
		
		public function clickUndo() : void{
			wait();
			validCommand = getResult(new ClickCommands(appTreeParser).flexClick(IdReference.MENU_UNDO_BUTTON,null));
			if(validCommand){
				dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
		}
		
		public function clickRedo() : void{
			wait();
			validCommand = getResult(new ClickCommands(appTreeParser).flexClick(IdReference.MENU_REDO_BUTTON,null));
			if(validCommand){
				dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
		}
		
		public function clickIndent() : void{
			validCommand = getResult(new ClickCommands(appTreeParser).flexClick(IdReference.MENU_INDENT_INDENT_BUTTON,null));
			if(validCommand){
				dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
		}
		
		public function clickOutdent() : void{
			new ClickCommands(appTreeParser).flexClick(IdReference.MENU_INDENT_OUTDENT_BUTTON,null);
		}
		
		public function overlayDeleteIsVisible() : Boolean{
			return new Boolean(new PropertyCommands(appTreeParser).getFlexVisible(IdReference.DELETE_OVERLAY,null))	
		}
		
		public function cancelDelete() : void{
			validCommand = new Boolean(new ClickCommands(appTreeParser).flexClick(IdReference.DELETE_OVERLAY_CANCEL_DELETE_BUTTON,null));
			if(validCommand){
				dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
		}
		
		public function confirmDelete() : void{
			validCommand = new Boolean(new ClickCommands(appTreeParser).flexClick(IdReference.DELETE_OVERLAY_CONT_DELETE_BUTTON,null));
			if(validCommand){
				dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
		}
	}
}