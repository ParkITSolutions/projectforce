public class ConfirmOverlayController {
	
	private String title;
	private String messageToUser;
	private String actionIds;
	private String actionName;
	private String refreshPanels;
	private String postAction;
	
	/**
	*Constructor
	*/
	public ConfirmOverlayController(){
		
	}
	
	/**
	* Action for accept button
	*/
	public void action(){
		
		if(this.actionName == 'DeleteTasks'){
			
			DAOFactory.getInstance().removeTasks(this.actionIds);
			
			this.postAction = 'DeleteTasks';
			
			System.debug('### refreshPanels: '+this.refreshPanels);
			
		}
		
		if(this.actionName == 'SecondAction'){
			
			this.actionIds = 'Second overlay action ids';
			this.postAction = 'SecondAction';
			
		}
		
	}
	
	public void cancel(){
	
	}
	
	public void postFunction(){
		
	}
	
	/* Getters and setters*/
	
	public String getTitle(){
		return this.title;
	}
	public void setTitle(String value){
		this.title = value;
	}
	
	public String getMessageToUser(){
		return this.messageToUser;
	}
	public void setMessageToUser(String value){
		this.messageToUser = value;
	}
	
	public String getActionIds(){
		return this.actionIds;
	}
	public void setActionIds(String value){
		this.actionIds = value;
	}
	
	public String getActionName(){
		return this.actionName;
	}
	public void setActionName(String value){
		this.actionName = value;
	}
	
	public String getRefreshPanels(){
		return this.refreshPanels;
	}
	public void setRefreshPanels(String value){
		this.refreshPanels = value;
	}
	
	public String getPostAction(){
		return this.postAction;
	}
	public void setPostAction(String value){
		this.postAction = value;
	}
	
	/* End of getters and setters*/

}