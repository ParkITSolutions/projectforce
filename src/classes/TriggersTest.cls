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

		try{
			upsert GenerateEnvironmentTest.pred;
		}catch (Exception e){}
		
		upsert GenerateEnvironmentTest.assi;

    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    }         	

       	
    /**
	* Test2
	*@void
    *@static
	*/
    static testMethod void myUnitTest3(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
		
		upsert GenerateEnvironmentTest.assi;
        delete GenerateEnvironmentTest.assi;
        try{
 			delete GenerateEnvironmentTest.pred;
        }catch (Exception e){}
        
		delete GenerateEnvironmentTest.task;
		
    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    }   
           	
  	/**
	* Test3
	*@void
    *@static 
	*/
    static testMethod void myUnitTest4(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
    	
		delete GenerateEnvironmentTest.member;
		
    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    }   

  	/**
	* Test4
	*@void
    *@static
	*/
    static testMethod void myUnitTest5(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
    	
		delete GenerateEnvironmentTest.project;
		
    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    }   

  	/**
	* Test6
	*@void
    *@static
	*/
    static testMethod void myUnitTest6(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
    	
		Project2__c p = new Project2__c();
		p = GenerateEnvironmentTest.project; // Old p
		// New p
		p.PublicProfile__c 		= 	null;
		p.NewMemberProfile__c	=	null;
		update p;	
		
		p = GenerateEnvironmentTest.project; // Old p		
		// New p
		p.PublicProfile__c 		= 	null;
		update p;	
		
    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    }   
  	/**
	* Test6
	*@void
    *@static
	*/
    static testMethod void myUnitTest7(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();	

		Project2__c project = new Project2__c();
        project.name = 'Project 1 name';
        project.description__c = 'Open';
        project.Access__c = 'Description ...';
        project.priority__c = 'High';
        project.DisplayDuration__c = 'Days';
        project.WorkingHours__c = 8.0;
        project.DaysInWorkWeek__c = '5';
        project.Type__c = 'open';
        //project.PublicProfile__c = profList[ 0 ].Id;
        //project.NewmemberProfile__c = profList[ 1 ].Id;
		insert project;
        project.PublicProfile__c = GenerateEnvironmentTest.profList[ 0 ].Id;
		update project;
		
		
    	Test.stopTest();
		ProjectUtil.setIsTest( false );
    }   

}