package com.salesforce.gantt.view.validator
{
	public class NumberValidator
	{
			
		private var pattern : RegExp = /100|(\d{0,}(\.(\d{0,})?)?)/;
		private var text : String = "";
		
		public function NumberValidator(text : String, precision : int,digits: int)
		{
			this.text = text;
		}
		
		public function parse() : String{
			return text.match(pattern)[0];
		}

	}
}