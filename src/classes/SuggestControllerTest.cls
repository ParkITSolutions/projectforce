@isTest private class SuggestControllerTest {
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
    	
        System.currentPageReference().getParameters().put('input', 'Test');
        System.currentPageReference().getParameters().put('teamId', GenerateEnvironmentTest.project.Id);
        System.currentPageReference().getParameters().put('class', 'Competency');
        SuggestController suggets = new SuggestController();
        
        System.currentPageReference().getParameters().put('class', 'colleagueNames');
        suggets = new SuggestController();            

        System.currentPageReference().getParameters().put('class', 'Employer');
        suggets = new SuggestController();
        
        System.currentPageReference().getParameters().put('class', 'School');
        suggets = new SuggestController();
            
        suggets.getSuggestion();
        
        SuggestController.Suggestions suggClass = new SuggestController.Suggestions();
        suggClass.getName();
        suggClass.getId();    	
    	
    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    }     	
}