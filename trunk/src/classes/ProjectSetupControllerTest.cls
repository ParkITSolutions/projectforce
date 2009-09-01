@isTest private  class ProjectSetupControllerTest {
	
	/**
    * Test customException
    */
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
    	
		ProjectSetupController ps = new ProjectSetupController();
		
		String[] foo = new String[]{ 'a' };
		ps.setSelectedProfilesList( foo );

		ps.getAllProfiles();
		ps.getSelectedProfilesList();
		ps.getSavedProfiles();
		
		
		List<Profile> profiles = new List<Profile>();
		String profilesStrList = '';
		for( Profile p : [ SELECT id, name FROM Profile limit 2 ])
			profilesStrList += p.name + '#';
			
		ps.setSelectedProfsStr( profilesStrList );
		ps.getSelectedProfsStr();
		
		// Calling saveAdmSettings() twice for inert and update.
		ps.saveAdmSettings();
		ps.saveAdmSettings();


    	Test.stopTest();
		ProjectUtil.setIsTest( false );    	
    	
    }
}