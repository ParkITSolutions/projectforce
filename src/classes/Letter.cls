/**
* @author Andres Canavesi
* @createdDate 02/02/2010
*/
public class Letter {
	
	public String name            	{ set; get; } //letter name
	public Boolean  hasCurrencies 	{ set; get; } //true if the letter has currencies in a records list
	
	public Letter( String name, Boolean hasCurrencies ){
		this.name 			= name;
		this.hasCurrencies 	= hasCurrencies;
	}
	
	public Letter(){
	
	}
}