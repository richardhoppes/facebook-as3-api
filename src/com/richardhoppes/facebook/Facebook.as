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
package com.richardhoppes.facebook {
	
	import com.adobe.serialization.json.JSON;
	import com.richardhoppes.facebook.event.AuthorizeAppEvent;
	import com.richardhoppes.facebook.event.GetUserEvent;
	
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	
	/**
	 * Facebook service.  Used for facebook authentication.
	 * @author Richard Hoppes
	 */
	public class Facebook extends EventDispatcher { 
		
		//---------------------------------------------------------------------
		//
		//  Constructor
		//
		//---------------------------------------------------------------------
		public function Facebook() {
			super();
		}
		
		//---------------------------------------------------------------------
		//
		//  Static Constants
		//
		//---------------------------------------------------------------------
		public static const DIALOG_OAUTH_URL:String = "https://www.facebook.com/dialog/oauth";
		public static const OAUTH_ACCESS_TOKEN_URL:String = "https://graph.facebook.com/oauth/access_token";
		public static const USER_INFO:String = "https://graph.facebook.com/me";
		
		//---------------------------------------------------------------------
		//
		//  Public Properties
		//
		//---------------------------------------------------------------------
		
		private var _appId:String;
		public function set appId(appId:String):void {
			_appId = appId;
		}
		public function get appId():String {
			return _appId;
		}
		
		private var _appSecret:String;
		public function set appSecret(appSecret:String):void {
			_appSecret = appSecret
		}
		public function get appSecret():String {
			return _appSecret;
		}
		
		private var _userAuthenticationCallback:String;
		public function set userAuthenticationCallback(userAuthenticationCallback:String):void {
			_userAuthenticationCallback = userAuthenticationCallback;
		}
		public function get userAuthenticationCallback():String {
			return _userAuthenticationCallback;
		}
		
		private var _appAuthorizationCallback:String;
		public function set appAuthorizationCallback(appAuthorizationCallback:String):void {
			_appAuthorizationCallback = appAuthorizationCallback;
		}
		public function get appAuthorizationCallback():String {
			return _appAuthorizationCallback;
		}
		
		//---------------------------------------------------------------------
		//
		//  Public Methods
		//
		//---------------------------------------------------------------------
		
		/**
		 * Get the URL your user will use to authenticate with Facebook.
		 *  
		 * @param display determines which display mode for the Facebook authentication dialog.  (e.g. page, popup, iframe, touch, or wap)  
		 * 
		 * @see https://developers.facebook.com/docs/authentication/ 
		 * 
		 */
		public function getUserAuthenticationUrl(display:String = "touch"):String {
			return DIALOG_OAUTH_URL + "?client_id=" + _appId + "&display=" + display + "&redirect_uri=" + escape(_userAuthenticationCallback);
		}
		
		/**
		 * Authorize your application
		 * Once your user authenticates via the Facebook dialog, the URL you specify for _userAuthenticationCallback will be called.  
		 * If authentication was successful, &code= will be present in the redirect URI, and it's value will be used to authorize your app.
		 *  
		 * @param userAuthenticationBrowserLocation browser location after user is redirected from the Facebook authentication dialog
		 * 
		 */
		public function authorizeApp(userAuthenticationBrowserLocation:String):void {
			
			// Get code
			var codePattern:RegExp = /code=([^&]*)/;
			var codeObject:Object = codePattern.exec(userAuthenticationBrowserLocation);
			
			// Get error and error reason 
			var errorPattern:RegExp = /error=([^&]*)/;
			var errorObject:Object = errorPattern.exec(userAuthenticationBrowserLocation);
			var errorReasonPattern:RegExp = /error_reason=([^&]*)/;
			var errorReasonObject:Object = errorReasonPattern.exec(userAuthenticationBrowserLocation);
			
			// 1. If code was found, attempt to authorize app
			// 2. Else If error was found, dispatch event with error details and ERROR type
			if (codeObject != null && codeObject[1]) {
				var requestURL:String = OAUTH_ACCESS_TOKEN_URL + "?code=" + codeObject[1] + "&client_secret=" + _appSecret + "&client_id=" + _appId + "&redirect_uri=" + escape(_appAuthorizationCallback);
				
				var request:URLRequest = new URLRequest(requestURL);
				request.method = URLRequestMethod.GET;
				
				var loader:URLLoader = new URLLoader(request);
				loader.addEventListener( Event.COMPLETE, authorizeApp_loadCompleteHandler);
				loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			} else if (errorObject != null && errorObject[1] && errorReasonObject != null && errorReasonObject[1]) {
				dispatchEvent(new AuthorizeAppEvent(AuthorizeAppEvent.ERROR, "", 0, errorObject[1], errorReasonObject[1]));
			} 
		}
		
		/**
		 * Get user's information
		 *  
		 * @param accessToken token received after app has been authorized
		 * 
		 */
		public function getUserInfo(accessToken:String):void {
			var requestURL:String = USER_INFO + "?access_token=" + accessToken;
			
			var request:URLRequest = new URLRequest(requestURL);
			request.method = URLRequestMethod.GET;
			
			var loader:URLLoader = new URLLoader(request);
			loader.addEventListener( Event.COMPLETE, getUserInfo_loadCompleteHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}
		
		//---------------------------------------------------------------------
		//
		//  Handler Methods
		//
		//---------------------------------------------------------------------
		private function authorizeApp_loadCompleteHandler(event:Event):void {

			// Get access token
			var accessTokenPattern:RegExp = /access_token=([^&]*)/;
			var accessTokenObject:Object = accessTokenPattern.exec(event.currentTarget.data as String);
			
			// Get expiration timestamp
			var expiresTokenPattern:RegExp = /expires=([^&]*)/;
			var expiresTokenObject:Object = expiresTokenPattern.exec(event.currentTarget.data as String);

			if (accessTokenObject != null && accessTokenObject[1]) {
				dispatchEvent(new AuthorizeAppEvent(AuthorizeAppEvent.ACCESS_TOKEN_RECEIVED, accessTokenObject[1], Number(expiresTokenObject[1])));
			} else {
				dispatchEvent(new AuthorizeAppEvent(AuthorizeAppEvent.NO_ACCESS_TOKEN_RECEIVED));
			}
		}
		
		private function getUserInfo_loadCompleteHandler(event:Event):void {
			var user:Object = JSON.decode(event.currentTarget.data as String);
			if(user != null && user.id != null) {
				dispatchEvent(new GetUserEvent(GetUserEvent.USER_DATA_RECEIVED, user, event.currentTarget.data as String));
			} else {
				dispatchEvent(new GetUserEvent(GetUserEvent.NO_USER_DATA_RECEIVED));
			}
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void {
			throw new IOError("IO Error", event.errorID);
		}

	}
}