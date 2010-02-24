package com.salesforce.gantt.commands.attachment
{
	import com.salesforce.gantt.commands.SimpleCommand;
	import com.salesforce.gantt.controller.Components;
	import com.salesforce.gantt.model.IAttachmentProperty;
	import com.salesforce.gantt.util.AttachmentHandler;
	import com.salesforce.objects.SObject;
	import com.salesforce.results.QueryResult;
	
	/**
	 * Class responsible to encapsultate the read information about attachments,
	 * make a call to the server to recover an string decoded in base 64
	 * from the server to attach a image to a object
	 * , this must implement the IAttachment interface. 
	 * 
	 * @author Rodrigo Birriel
	 */ 
	public class ReadAttachmentCommand extends SimpleCommand{
		
		private var attachmentId : String;
		private var object : IAttachmentProperty;
		
		public function ReadAttachmentCommand(attachId : String, objectWithAttachment : IAttachmentProperty){
			attachmentId = attachId;
			object = objectWithAttachment;
			
		}
		
		override public function execute(): void{
			Components.instance.salesforceService.attachmentOperation.load(attachmentId,this);	
		}
		
		override protected function actionCallBack(response : Object) : void{
			var queryResult : QueryResult = response as QueryResult;
			var record : SObject;
			if(queryResult.size > 0){
				record = queryResult.records[0];
				object.attachment = AttachmentHandler.byteArrayToImage(record.decodeBase64('Body')); 
			} 
		} 
	}
}