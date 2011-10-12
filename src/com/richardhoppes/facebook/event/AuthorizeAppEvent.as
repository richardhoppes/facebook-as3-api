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
	
	public class AuthorizeAppEvent extends Event {
		
		public static const ACCESS_TOKEN_RECEIVED:String = "AuthorizeAppEvent.ACCESS_TOKEN_RECEIVED";
		public static const NO_ACCESS_TOKEN_RECEIVED:String = "AuthorizeAppEvent.NO_ACCESS_TOKEN_RECEIVED";
		public static const ERROR:String = "AuthorizeAppEvent.ERROR";
		
		private var accessToken:String;
		
		public function getAccessToken():String {
			return accessToken;
		}
		
		private var expires:Number;
		
		public function getExpires():Number {
			return expires;
		}
		
		private var error:String;
		
		public function getError():String {
			return error;
		}
		
		private var errorReason:String;
		
		public function getErrorReason():String {
			return errorReason;
		}
		
		public function AuthorizeAppEvent(type:String, accessToken:String = "", expires:Number = 0, error:String = "", errorReason:String = "", bubbles:Boolean = false) {
			super(type, bubbles);
			this.accessToken = accessToken;
			this.expires = expires;
			this.error = error;
			this.errorReason = errorReason;
		}
		
		override public function clone() : Event {
			return new AuthorizeAppEvent(type, accessToken, expires, error, errorReason, bubbles);
		}
	}
}