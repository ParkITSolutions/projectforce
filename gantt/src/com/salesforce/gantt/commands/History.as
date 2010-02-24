package com.salesforce.gantt.commands
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.IResponder;
	
	public class History extends EventDispatcher implements IResponder
	{
		public static var COMPLETE : String = "historyComplete";
		/** the array of commands in memory that could be undone **/
		private var commands : ArrayCollection = new ArrayCollection();
		/** the index in the array pointing to the last command **/
		private var count : int = -1;  
		
		/**
		 * Adds a new command to the array
		 */
		public function addCommand( command : ICommand ) : void
		{
			clean();
			count = commands.length;
			commands.addItem(command);
		}

		/**
		 * Undoes the last command in the array
		 */		
		public function undo(responder : IResponder) : void
		{
			commands.getItemAt(count).undo(responder);
			count --;
		}
	
		/**
		 * Redoes the last command in the array
		 * 
		 */	 
		public function redo(responder : IResponder) : void
		{
			count ++;
			commands.getItemAt(count).redo(responder);
		}
		
		/**
		 * Checks if possible undoes the present command
		 */ 
		public function checkUndo() : Boolean{
			return count > -1; 
		}
		
		public function result(response : Object) : void{
			dispatchEvent(new Event(History.COMPLETE));
		}
		
		public function fault(response : Object) : void{
			throw new Error("Not implemented yet...");
		}
		
		/**
		 * Checks if possible redoes the present command
		 */  
		public function checkRedo() : Boolean{
			return count + 1 < commands.length;
		}
		
		public function init() : void{
			count = -1;
			commands.removeAll();
		}
		
		/**
		 * Cleans the history, removing all the commands after the counter index
		 */
		private function clean() : void{
			remove(count+1);
		}
		
		/**
		 * Removes the commands from the collections from index i to commands.length.
		 */ 
		private function remove(i : int) : void{
			while(i<commands.length){
				commands.removeItemAt(i);
			}
		}
		
	}
}