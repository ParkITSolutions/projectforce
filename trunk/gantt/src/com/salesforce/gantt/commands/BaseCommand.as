package com.salesforce.gantt.commands
{
	import flash.events.EventDispatcher;
	
	import mx.rpc.IResponder;
	
	/**
	 * Abstract Class to provide a way to create new custom commands.
	 * Implements IResponder to execute the action result/fault in the callback.
	 * 
	 * @author Rodrigo Birriel
	 */
	public class BaseCommand extends EventDispatcher implements ICommand,IResponder
	{
		protected var newObject : Object;
		protected var oldObject : Object;
		
		protected var undoCommand : BaseCommand;
		
		public function redo(responder : IResponder) : void{
		}
		
		public function undo(responder : IResponder) : void{
		}
		
		public function execute() : void{
			throw new Error( 'You forgot to override this method...!!!');
		}
		
		public function result(data : Object) : void{
			throw new Error( 'You forgot to override this method...!!!');
		}
		
		public function fault(data : Object) : void{
			throw new Error( 'You forgot to override this method...!!!');
		}
		
		public function set success(func : Function){
		}
		
		public function set failure(func : Function){	
		}
		
		// method implemented by subclasses to put the code used 
		// in the result method.
		protected function actionCallBack(response : Object) : void{
			throw new Error('This class is abstract...');	
		}

	}
}