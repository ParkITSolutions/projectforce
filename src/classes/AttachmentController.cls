public class AttachmentController {
	  
	  
	public Id parentId 	 		{ set; get; }
	public Boolean error 		{ set; get; }
	public Attachment newAttach { set; get; }

	/**
	*Class constructor
	*/
	public AttachmentController(){
		this.parentId = System.currentPageReference().getParameters().get('pId');
	
	}
	

	public void action(){}

	public PageReference saveAttachment(){
		
		PageReference pr = Page.Attachment;
		if( this.parentId != null ){
			Attachment tempAtt = new Attachment();
			tempAtt.parentId = this.parentId;
			tempAtt.name = 'miguel';
		}else{
			
		}
		
		return pr;
	}
}