public class ProjectNicoTestControler {
	
//	private ProjectSubscribersEmailServices  pp;
	
	public ProjectNicoTestControler(){
		  
		 System.debug('XXX entre constructor...');
	}
	
	
	public void findForExpiringTask(){
		ProjectSubscribersEmailServices pp = ProjectSubscribersEmailServices.getInstance();
		pp.findForExpiringTask();
	}
}