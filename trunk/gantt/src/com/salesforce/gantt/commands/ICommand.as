package com.salesforce.gantt.commands
{
	import flash.events.IEventDispatcher;
	
	import mx.rpc.IResponder;
		
	public interface ICommand extends IEventDispatcher
	{
		function undo(responder : IResponder) : void;
		function redo(responder : IResponder) : void;
		function execute() : void;
	}
}