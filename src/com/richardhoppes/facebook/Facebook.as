package com.richardhoppes.facebook {
	import com.adobe.serialization.json.JSON;
	import com.richardhoppes.facebook.event.*;
	
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	
	public class Facebook extends EventDispatcher { 
		
		public static const DIALOG_OAUTH_URL:String = "https://www.facebook.com/dialog/oauth";
		public static const OAUTH_ACCESS_TOKEN_URL:String = "https://graph.facebook.com/oauth/access_token";
		public static const USER_INFO:String = "https://graph.facebook.com/me";
		
		private var _appId:String;
		private var _appSecret:String;
		private var _userAuthenticationCallback:String;
		private var _appAuthorizationCallback:String;
		
		public function Facebook() {
		}		
		
		public function set appId(appId:String):void {
			_appId = appId;
		}
		
		public function set appSecret(appSecret:String):void {
			_appSecret = appSecret
		}
		
		public function set userAuthenticationCallback(userAuthenticationCallback:String):void {
			_userAuthenticationCallback = userAuthenticationCallback;
		}
		
		public function set appAuthorizationCallback(appAuthorizationCallback:String):void {
			_appAuthorizationCallback = appAuthorizationCallback;
		}
		
		
		public function getUserAuthenticationUrl(display:String = "touch"):String {
			return DIALOG_OAUTH_URL + "?client_id=" + _appId + "&display=" + display + "&redirect_uri=" + escape(_userAuthenticationCallback);
		}
		
		public function authorizeApp(userAuthenticationCallbackLocation:String):void {
			
			// Get code
			var codePattern:RegExp = /code=(.*)/;
			var codeObject:Object = codePattern.exec(userAuthenticationCallbackLocation);
			
			// If code was found, attempt to authorize app
			if (codeObject != null && codeObject[1]) {
				var requestURL:String = OAUTH_ACCESS_TOKEN_URL + "?code=" + codeObject[1] + "&client_secret=" + _appSecret + "&client_id=" + _appId + "&redirect_uri=" + escape(_appAuthorizationCallback);
				
				var request:URLRequest = new URLRequest(requestURL);
				request.method = URLRequestMethod.GET;
				
				var loader:URLLoader = new URLLoader(request);
				loader.addEventListener( Event.COMPLETE, authorizeApp_loadCompleteHandler);
				loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			} else {
				dispatchEvent(new AuthorizeAppEvent(AuthorizeAppEvent.NO_CODE_FOUND));
			}
		}
		
		private function authorizeApp_loadCompleteHandler(event:Event):void {
			
			// Get access token
			var accessTokenPattern:RegExp = /access_token=([^&]*)/;
			var accessTokenObject:Object = accessTokenPattern.exec(event.currentTarget.data as String);
			
			// Get access token
			var expiresTokenPattern:RegExp = /expires=([^&]*)/;
			var expiresTokenObject:Object = expiresTokenPattern.exec(event.currentTarget.data as String);

			if (accessTokenObject != null && accessTokenObject[1]) {
				dispatchEvent(new AuthorizeAppEvent(AuthorizeAppEvent.ACCESS_TOKEN_RECEIVED, accessTokenObject[1], Number(expiresTokenObject[1])));
			} else {
				dispatchEvent(new AuthorizeAppEvent(AuthorizeAppEvent.NO_ACCESS_TOKEN_RECEIVED));
			}
		}

		public function getUserInfo(token:String):void {
			var requestURL:String = USER_INFO + "?access_token=" + token;
			
			var request:URLRequest = new URLRequest(requestURL);
			request.method = URLRequestMethod.GET;
			
			var loader:URLLoader = new URLLoader(request);
			loader.addEventListener( Event.COMPLETE, getUserInfo_loadCompleteHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
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