/**
 * Copyright (c) 2011 Richard Hoppes.
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy of 
 * this software and associated documentation files (the "Software"), to deal in 
 * the Software without restriction, including without limitation the rights to 
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies 
 * of the Software, and to permit persons to whom the Software is furnished to do 
 * so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all 
 * copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE. 
 * */
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