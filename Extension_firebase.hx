package;

#if cpp
import cpp.Lib;
#elseif neko
import neko.Lib;
#end

#if (android && openfl)
import openfl.utils.JNI;
#end


class Extension_firebase {
	
	
	public static function sampleMethod (inputValue:Int):Int {
		
		#if (android && openfl)
		
		var resultJNI = extension_firebase_sample_method_jni(inputValue);
		var resultNative = extension_firebase_sample_method(inputValue);
		
		if (resultJNI != resultNative) {
			
			throw "Fuzzy math!";
			
		}
		
		return resultNative;
		
		#else
		
		return extension_firebase_sample_method(inputValue);
		
		#end
		
	}
	
	
	private static var extension_firebase_sample_method = Lib.load ("extension_firebase", "extension_firebase_sample_method", 1);
	
	#if (android && openfl)
	private static var extension_firebase_sample_method_jni = JNI.createStaticMethod ("org.haxe.extension.Extension_firebase", "sampleMethod", "(I)I");
	#end
	
	
}