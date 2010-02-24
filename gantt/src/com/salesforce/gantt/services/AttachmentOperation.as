package com.salesforce.gantt.services
{
	import com.salesforce.Connection;
	
	import mx.rpc.IResponder;
	
	/**
	 * Class responsible for connecting to salesforce Api to
	 * to handle the attachments's operations.
	 * 
	 * @author : Rodrigo Birriel 
	 * 
	 */
	public class AttachmentOperation extends BaseOperation
	{
	
		public function AttachmentOperation(){
			super();
		}
		
		public function load(attachmentId : String, ar : IResponder) : void{
			
			var query : String = "SELECT Id, Body FROM Attachment WHERE Id = '"+attachmentId+"'";
			connection.query(query,ar);
		}
		
		
	}
}