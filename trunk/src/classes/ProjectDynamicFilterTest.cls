@isTest private  class ProjectDynamicFilterTest {



	/**
    * Test customException
    */
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();

		ProjectDynamicFilter.SFField innCls = new ProjectDynamicFilter.SFField();
		
		innCls.name    = 'name' ; 		//Set
		String bugOfHolding = innCls.name;	//Get
		
		innCls.fieldType =	'type';
		bugOfHolding= innCls.fieldType;

    	Test.stopTest();
		ProjectUtil.setIsTest( false );    	
    	
    }    	
}