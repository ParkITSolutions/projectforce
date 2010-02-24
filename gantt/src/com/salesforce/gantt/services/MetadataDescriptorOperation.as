package com.salesforce.gantt.services
{
	import mx.rpc.IResponder;
	
	/**
	 * Class responsible for connecting to salesforce Api to
	 * to retrieve Custom Objects metadata.
	 * 
	 * @author : Rodrigo Birriel 
	 * 
	 */
	public class MetadataDescriptorOperation extends BaseOperation{
		
		public function MetadataDescriptorOperation(){
		}
		
		public function loadSObjectDescriptor(customObjectName : String, ar : IResponder) : void{
			connection.describeSObject(customObjectName,ar)
		}
		
		public function loadLayoutDescriptor(customObjectName : String, ar : IResponder) : void{
			connection.describeLayout(customObjectName,null,ar);
		}
	}
}