/**
*@author Miguel Soares @ 04/16/2009
*/
@isTest private class TriggersTest {
	
	/**
	* Test1
	*@void
    *@static
	*/
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();

		upsert GenerateEnvironmentTest.project;
		upsert GenerateEnvironmentTest.member;
		upsert GenerateEnvironmentTest.task;
		upsert GenerateEnvironmentTest.pred;
		upsert GenerateEnvironmentTest.assi;

    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    }         	

       	
    /**
	* Test2
	*@void
    *@static
	*/
    static testMethod void myUnitTest2(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
		
		delete GenerateEnvironmentTest.pred;
		delete GenerateEnvironmentTest.task;
		delete GenerateEnvironmentTest.member;

		
    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    }   
           	
  	/**
	* Test3
	*@void
    *@static
	*/
    static testMethod void myUnitTest3(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
    	
		delete GenerateEnvironmentTest.project;
		
    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    }   
}