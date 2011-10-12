package com.richardhoppes.facebook.event {
	import flash.events.Event;
	
	public class AuthorizeAppEvent extends Event {
		
		public static const NO_CODE_FOUND:String = "AuthorizeAppEvent.NO_CODE_FOUND";
		public static const ACCESS_TOKEN_RECEIVED:String = "AuthorizeAppEvent.ACCESS_TOKEN_RECEIVED";
		public static const NO_ACCESS_TOKEN_RECEIVED:String = "AuthorizeAppEvent.NO_ACCESS_TOKEN_RECEIVED";
		
		private var accessToken:String;
		
		public function getAccessToken():String {
			return accessToken;
		}
		
		private var expires:Number;
		
		public function getExpires():Number {
			return expires;
		}
		
		public function AuthorizeAppEvent(type:String, accessToken:String = "", expires:Number = 0, bubbles:Boolean = false) {
			super(type, bubbles);
			this.accessToken = accessToken;
			this.expires = expires;
		}
		
		override public function clone() : Event {
			return new AuthorizeAppEvent(type, accessToken, expires, bubbles);
		}
	}
}