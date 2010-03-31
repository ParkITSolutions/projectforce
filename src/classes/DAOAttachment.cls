/**
* @author Andres Canavesi 
*/
public class DAOAttachment {


	/**
	* Constructor
	*/
	public DAOAttachment(){
		
	}
	
	public void insertAttachment( Attachment att, Id attId ){
		att.parentId = attId;
		insert att;
	}
	
	public void addAvatar( String attachmentId, String projectId ){
			
	}
	
	public void updateAvatar( String attachmentId, String projectId ){
	
	}
	
	public void deleteAvatar( String attachmentId, String projectId ){
	
	}
	
	public void deleteAttachment( String attachments ){
			List<String> attachmentIds = new List<String>();
	        
	        attachmentIds = attachments.split(':'); 
	        
	        List<Attachment> attachmentsToDelete = [select Id 
	            								  		from Attachment 
	            								  		where id in: attachmentIds];
			delete attachmentsToDelete;

	}
	
	public List<AttachmentObj> getAttachments( String id ){
		
		List<Attachment> att = [Select Id, Name, CreatedDate, CreatedBy.Name, BodyLength, Body, ContentType From Attachment Where ParentId =: id and id !=: DAOFactory.getInstance().getProjectAvatarId( id ) limit 1000];
		return ObjectFormatter.formatAttachments( att );
		
	}
	
	public List<AttachmentObj> getAttachmentsWithoutPaging( String id ){
	
		return null;
	}
	
    public  List<Attachment> getCsvExport( String fileName ){
    	return  [select Id, Name from Attachment where Name =: fileName ];
    }
	
}