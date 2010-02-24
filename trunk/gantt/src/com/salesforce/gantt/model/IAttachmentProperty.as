package com.salesforce.gantt.model
{
	import mx.controls.Image;
	
	/**
	 * Interface used by any object which contains an image as attribute
	 * 
	 * @author Rodrigo Birriel
	 */ 
	public interface IAttachmentProperty
	{
		function set attachment(image : Image) : void;
		function get attachment() : Image;
	}
}