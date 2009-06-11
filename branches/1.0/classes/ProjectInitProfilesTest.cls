/**
* @author: Sebastian Muñoz @ 06-01-2009
*/
@isTest private class ProjectInitProfilesTest {
    

    /**
    * Test ProjectInitProfiles
    * @void
    * @static
    */
    
    static testMethod void myUnitTest(){
        GenerateEnvironmentTest.gen();
        ProjectUtil.setIsTest( true );
        Test.startTest();
    
        List<String> testProfilesNames = new List<String> {'Member Profile Test' , 'Public Profile Test' , 'Project Administrator Test'};       
        List<ProjectProfile__c> testProfiles = new List<ProjectProfile__c>();
        
        System.currentPageReference().getParameters().put( 'id', GenerateEnvironmentTest.project.Id );
        
        testProfiles = [select Id, Name from ProjectProfile__c where Name in : testProfilesNames];
  
        ProjectInitProfiles prj = new ProjectInitProfiles();
 
        if (testProfiles.size() > 0){           
            delete testProfiles;
        }

        prj.setProfilesNames(testProfilesNames);
        prj.InitializeProfiles();
        prj.saveProfiles();
        prj.getShowOverlay();
        
        Test.stopTest();
        ProjectUtil.setIsTest( false );
    }
}