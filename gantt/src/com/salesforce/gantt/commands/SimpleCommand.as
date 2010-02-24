package com.salesforce.gantt.commands
{
	import com.salesforce.gantt.util.ErrorHandler;
	
	import flash.events.Event;
	
	import mx.rpc.IResponder;
	
	/**
	 * Class to provide a way to create new simple custom commands
	 * with out subcommands
	 * 
	 * @author Rodrigo Birriel
	 */
	public class SimpleCommand extends BaseCommand
	{
		public static const COMPLETE : String = "simpleCommandCompleted";
		public static const INCOMPLETE : String = "simpleCommandIncompleted";
		
		public function SimpleCommand()
		{
			super();
		}
		
		override public function redo(responder : IResponder) : void{
			addEventListener(SimpleCommand.COMPLETE,responder.result);
			execute();
		}
		
		override public function undo (responder : IResponder) : void{
			undoCommand.addEventListener(SimpleCommand.COMPLETE,responder.result);
			undoCommand.execute();
		}
		
		override public function set success(func : Function){
			addEventListener(SimpleCommand.COMPLETE,func);
		}
	
		override public function set failure(func : Function){
			addEventListener(SimpleCommand.INCOMPLETE,func);
		}
		
		// function used as template method
		override public function result(data:Object):void{
			if(ErrorHandler.areErrors(data)){
				dispatchEvent(new Event(SimpleCommand.INCOMPLETE));
			}else{
				actionCallBack(data);		
				dispatchEvent(new Event(SimpleCommand.COMPLETE));
			}
		}
	}
}