package com.salesforce.gantt.util
{
	import com.salesforce.objects.Base64;
	
	import flash.utils.ByteArray;
	
	import mx.controls.Image;
	
	/**
	 * Class responsible to handle the attachments,
	 * keeping them in a map.
	 * 
	 * @author Rodrigo Birriel
	 */
	public class AttachmentHandler
	{
		private static var attachments : Object;

		/**
		 * Add a new attachment to the map, decoding the value to a byte array in base 64.
		 * 
		 * @param value 		is the source to be added to the map.
		 * @param key			is the attachment's id.
		 * @param base64Encoded is a boolen to indicate if the value is encoded in base 64.
		 */
		public static function add(value : Object, key : String, base64Encoded : Boolean = false) : void{
			var byteArray : ByteArray;
			if(!base64Encoded){
				byteArray = Base64.decode(value as String);
			}else{
				byteArray = value as ByteArray;
			}
			attachments[key] = byteArray;
		}
		
		/**
		 * Given a key return a image, wrapping the value 
		 * to this key in a image and
		 * injecting the byte array.
		 * 
		 * @param key			is the attachement's id.
		 */
		public static function find(key : String) : Image{
			var byteArray : ByteArray = attachments[key];
			return byteArrayToImage(byteArray);
		}
		
		/**
		 * Given a byte array, load an image with this source.
		 * 
		 * @param byteArray		is a byte array.
		 * @return Image		the image with the byte array.
		 */ 
		public static function byteArrayToImage(byteArray : ByteArray) : Image{
			var newImage : Image = new Image();
			newImage.load(byteArray);
			newImage.height = 32;
			newImage.width	= 32;
			return newImage;
		}
		
		/**
		 * Given a string in base 64, decode it in a byte array and then
		 * returns an image.
		 * 
		 * @param base64String	is a string in base 64
		 * @return Image		the image with the string decoded in base 64.
		 * 
		 */
		public static function base64ToImage(base64String : String) : Image{
			var byteArray : ByteArray = Base64.decode(base64String);
			return byteArrayToImage(byteArray);		
		}
	}
}