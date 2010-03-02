/**
* @author Juan M. Bessonart 
* @createdDate 07/28/2008
*/
public class CustomException extends Exception {
	
	
	public static testMethod void testCustomException(){
		
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
    	
    	CustomException ce = new CustomException();
    	
    	Test.stopTest();
		ProjectUtil.setIsTest( false );
	}
}