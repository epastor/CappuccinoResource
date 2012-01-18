@import <Foundation/CPObject.j>

@implementation CPURLConnectionWithCallback : CPURLConnection{
	id sender;
	function successCallback;
	function errorCallback;
	function authenticateCallback;
}

+ (CPURLConnection)connectionWithRequest:(CPURLRequest)aRequest sender:(id)senderInstance successCallback:(function)successCallbackInstance
{
	var me = [[self alloc] initWithRequest:aRequest delegate:nil];
	me.sender = senderInstance;
	me.successCallback = successCallbackInstance;
	return me;
}

+ (CPURLConnection)connectionWithRequest:(CPURLRequest)aRequest sender:(id)senderInstance successCallback:(function)successCallbackInstance errorCallback:(function)errorCallbackInstance
{
	var me = [[self alloc] initWithRequest:aRequest delegate:nil];
	me.sender = senderInstance;
	me.successCallback = successCallbackInstance;
	me.errorCallback = errorCallbackInstance;
	return me;
}

+ (CPURLConnection)connectionWithRequest:(CPURLRequest)aRequest sender:(id)senderInstance successCallback:(function)successCallbackInstance errorCallback:(function)errorCallbackInstance authenticateCallback:(function) authenticateCallbackInstance
{
	var me = [[self alloc] initWithRequest:aRequest delegate:nil];
	me.sender = senderInstance;
	me.successCallback = successCallbackInstance;
	me.errorCallback = errorCallbackInstance;
	me.authenticateCallback = authenticateCallbackInstance;
	return me;
}


- (void)_readyStateDidChange {
	[super _readyStateDidChange];
	
	if (_HTTPRequest.readyState() === CFHTTPRequest.CompleteState)
	{
		var statusCode = _HTTPRequest.status(),
		URL = [_request URL];
		if (statusCode === 401 && [CPURLConnectionDelegate respondsToSelector:@selector(connectionDidReceiveAuthenticationChallenge:)]){
			if( authenticateCallback ){
					authenticateCallback.call( sender,  _HTTPRequest.responseText()  );
			}
		}else{
			if (!_isCanceled)
			{
				if( statusCode === 200 && successCallback ){
					successCallback.call( sender,  _HTTPRequest.responseText()  );
				}else if( statusCode != 200 && errorCallback ){
					errorCallback.call( sender, statusCode,  _HTTPRequest.responseText()  );
				}
			}
		}
	}
}