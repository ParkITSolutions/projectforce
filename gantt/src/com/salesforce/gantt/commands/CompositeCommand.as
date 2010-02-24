package com.salesforce.gantt.commands
{
	import com.salesforce.gantt.util.ErrorHandler;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.IResponder;
	
	/**
	 * Class is a container responsible to handle their command children, 
	 * attaching a listener when each child command finished to execute it,
	 * then dispatch a event when this instance finished to execute their children.
	 *
	 * @author Rodrigo Birriel
	 */
	public class CompositeCommand extends BaseCommand
	{
		public static const COMPLETE : String = "compositeCommandComplete";
		public static const INCOMPLETE : String = "compositeCommandIncompleted";
		
		protected var commands : ArrayCollection;
		
		public function CompositeCommand()
		{
			super();
			commands = new ArrayCollection();
		}
		
		/**
		 * Add a new command to the container, attaching a listener when
		 * the execution is completed or not.
		 * 
		 * @param child 	command to be added. 
		 */ 
		public function addCommand(command : ICommand) : void{
			var successEvent : String;
			var faultEvent : String;
			if(command is SimpleCommand){
				successEvent = SimpleCommand.COMPLETE;
				faultEvent = SimpleCommand.INCOMPLETE;
			}else{
				successEvent = CompositeCommand.COMPLETE;
				faultEvent = CompositeCommand.INCOMPLETE;
			}
			commands.addItem(command);
			command.addEventListener(successEvent,nextCommand);
			command.addEventListener(faultEvent,incompleteCommand);			
		}
		
		override public function undo (responder : IResponder) : void{
			undoCommand.addEventListener(CompositeCommand.COMPLETE,responder.result);
			undoCommand.execute();
		}
		
		
		override public function redo(responder : IResponder) : void{
			addEventListener(CompositeCommand.COMPLETE,responder.result);
			execute();
		}
		
		override public function set success(func : Function){
			addEventListener(CompositeCommand.COMPLETE,func);
		}
		
		override public function set failure(func : Function){
			addEventListener(CompositeCommand.INCOMPLETE,func);
		}
		
		override public function execute() : void{
			nextCommand();
		}
		
		// function used as template method
		override public function result(data:Object):void{
			if(ErrorHandler.areErrors(data)){
				dispatchEvent(new Event(CompositeCommand.INCOMPLETE));
			}else{
				actionCallBack(data);
				//nextCommand();
			}
		}
		
		protected function nextCommand(event : Event = null) : void{
			var command : ICommand;
			if(commands.length > 0){
				command = ICommand(commands.removeItemAt(0));
				command.execute();
				trace("executing subcommands...");
			}else{
				trace("finished to execute subcommands...");
				dispatchEvent(new Event(CompositeCommand.COMPLETE));
			}
		}
		
		protected function incompleteCommand(event : Event) : void{
			dispatchEvent(event);
		}
		
	}
}