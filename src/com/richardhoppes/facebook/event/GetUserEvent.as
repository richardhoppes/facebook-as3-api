package com.richardhoppes.facebook.event {
	import flash.events.Event;
	
	public class GetUserEvent extends Event {
		
		public static const USER_DATA_RECEIVED:String = "GetUserEvent.USER_DATA_RECEIVED";
		public static const NO_USER_DATA_RECEIVED:String = "GetUserEvent.NO_USER_DATA_RECEIVED";
		
		private var rawResponse:String;
		
		public function getRawResponse():String {
			return rawResponse;
		}
		
		private var user:Object;
		
		public function getUser():Object {
			return user;
		}
		
		public function GetUserEvent(type:String, user:Object = null, rawResponse:String = null, bubbles:Boolean = false) {
			super(type, bubbles);
			this.user = user;
			this.rawResponse = rawResponse;
		}
		
		override public function clone() : Event {
			return new GetUserEvent(type, user, rawResponse, bubbles);
		}
	}
}