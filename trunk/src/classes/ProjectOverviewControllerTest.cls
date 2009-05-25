/**
*@author Miguel Soares @ 04/14/2009
*/
@isTest private class ProjectOverviewControllerTest {
	
	/**
	* Test  ProjectOverviewController
	*@void
    *@static
	*/
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
    	
    	System.currentPageReference().getParameters().put( 'filter', 'M' );
    	ProjectOverviewController po = new ProjectOverviewController();
    	
    	po.setParentId( null );
    	po.setFilter( 'M' );
    	po.projectsForTabs();
    	System.currentPageReference().getParameters().put( 'ltr', 'M' );
    	po.setLetterFilter();
    	po.filterProjects();
 
    	po.getProjectsForTabsSize();
    	po.getProjectsForTabs();
    	po.setProjects(po.getProjects());
    	po.getProfileExist();
    	po.getPaginator();
    	po.getLetterFilter();
    	
    	ProjectOverviewController.Letters ll = new ProjectOverviewController.Letters();
    	ll.setContainSites(1);
    	ll.setContainSites(0);
    	ll.getContainSites();


    	ProjectOverviewController.Project pp = new ProjectOverviewController.Project();
    	pp.name = 'name';
    	String a = pp.name;
    	pp.createDate = 'dasda';
    	a = pp.createDate;
    	pp.id = 'asd';
    	a = pp.id;
    	pp.image = 'ada';
    	pp.image = null;
    	a = pp.image;
    	pp.members = 2;
    	Integer i = pp.members;
    	pp.tasks = 2;
    	i = pp.tasks;
    	pp.milestones = 2;
    	i = pp.milestones;
  	
    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    }     	
}