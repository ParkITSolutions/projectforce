/**
* @author Andres Canavesi
* @createdDate 02/02/2010
*/
public class Letter {
	
	public Boolean  isProduction 	{ set; get; }
	public String 	name            { set; get; } //letter name
	public Boolean  hasCurrencies 	{ set; get; } //true if the letter has currencies in a records list
	
	/**
    * Constructor
    * @param name
    * @param hasCurrencies
    */
	public Letter( String name, Boolean hasCurrencies ){
		this.isProduction	= ProjectUtil.isProduction;
		this.name 			= name;
		this.hasCurrencies 	= hasCurrencies;
	}
	
	/**
    * Constructor 
    */
	public Letter(){
	}
	
	/**
    * Test 
    */
    static testMethod void myUnitTest(){
    	
		GenerateEnvironmentTest.gen();
		ProjectUtil.setIsTest( true );
    	Test.startTest();
		
		Letter letter = new Letter();
		Letter letter2 = new Letter( 'b', true );
		
    	Test.stopTest();
		ProjectUtil.setIsTest( false );    	
    }
}