package com.salesforce.gantt.view.validator
{
	public class PercentValidator
	{
		private var pattern : RegExp = /100|(\d{0,2}(\.(\d)?)?)/;
		private var text : String = "";
		
		public function PercentValidator(text : String)
		{
			this.text = text;
		}
		
		public function parse() : String{
			return text.match(pattern)[0];
		}

	}
}