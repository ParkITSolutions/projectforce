package com.salesforce.gantt.view.validator
{
	import com.salesforce.gantt.model.Project;
	import com.salesforce.gantt.model.Task;
	
	import mx.validators.Validator;
	
	/**
	 * Class responsible for extracting a valid duration from a text.
	 * 
	 * @author Rodrigo Birriel
	 */ 
	public class DurationValidator extends Validator
	{		
		public static var pattern:RegExp = /\d+(\.\d*)?([H|h|D|d])?/;
		/**
		 * Given an input text, extracts a valid String
		 * @param durationField : a string to match.
		 * @return a valid String.
		 */ 

		public function DurationValidator() {
            // Call base class constructor. 
            super();
        }

		public static function parse(durationField : String) : String{
			var result : Object = pattern.exec(durationField);
			if(result){
				durationField = result[0];	
			}else{
				durationField = '';
			}
			return durationField;
		}
		
		override protected function doValidation(value:Object) : Array{
			var result : Array = super.doValidation(value);
			var resultParsed : Object = pattern.exec(value.toString());
			if(resultParsed){
				source.text = resultParsed[0];
			}else{
				source.text = '';
			}
			return result;
		}
		
		/**
		 * Given an correct duration format , convert it to 
		 * a number depending on if it has suffix H (hours) or D (days)
		 * @param durationField : a string to convert.
		 * @return a valid Number.
		 */ 
		public static function convert(durationField : String, condition : Boolean) : Number{
			var suffix : String = durationField.charAt(durationField.length-1);
			suffix = suffix.toUpperCase();
			var length : Number = durationField.length;
			if(suffix == "H" || suffix == "D" || suffix == "."){
				length = durationField.length-1;		
			}
			
			var num : Number = Number(durationField.substr(0,length));
			
			if(suffix == 'D'){
				if(condition){
					//num = Task.convertToHours(num);	
				}
			}else if(suffix == 'H'){
				if(!condition){
					//num = Task.convertToDays(num,true);
				}		
			}
			return num;
		}
		
	}
}
