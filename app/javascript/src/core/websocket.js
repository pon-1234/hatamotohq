export function WebSocketClient() {
  this.autoReconnectInterval = 5 * 1000; // ms
}

WebSocketClient.prototype.open = function() {
  this.url = process.env.MIX_WS_FLEXA_URL;
  this.token = window.wsToken;

  window.WebSocket = window.WebSocket || window.MozWebSocket;
  if (this.instance) this.instance.close();
  this.instance = new WebSocket(this.url + '?token=' + this.token);
  this.instance.onopen = (e) => {
    setTimeout(() => {
      if (this.instance.readyState === WebSocket.OPEN) { this.onopen(); }
    }, 200);
  };
  this.instance.onmessage = (message, flags) => {
    this.onmessage(message.data, flags);
  };

  this.instance.onclose = (e) => {
    console.log('onclose', e);
    switch (e.code) {
    case 1003: // Force Disconnect
    case 1009: // Unauthorization
    case 1000: // CLOSE_NORMAL
      console.log('WebSocket: closed', e.code);
      $('body .talk').html('plz!!! relogin this account and try again.');
      break;
    default: // Abnormal closure
      this.reconnect(e);
      break;
    }
    this.onclose(e);
  };
};
WebSocketClient.prototype.send = function(data, option) {
  try {
    this.instance.send(data, option);
  } catch (e) {
    this.instance.emit('error', e);
  }
};

WebSocketClient.prototype.reconnect = function(e) {
  console.log(`WebSocketClient: retry in ${this.autoReconnectInterval}ms`, e);
  this.onreconnect();
  const that = this;
  setTimeout(function() {
    that.open(that.url, that.token);
  }, this.autoReconnectInterval);
};

WebSocketClient.prototype.onreconnect = function() {
  console.log('WebSocketClient: reconnect');
};
WebSocketClient.prototype.onopen = function(e) {
  console.log('WebSocketClient: open', e);
};
WebSocketClient.prototype.onmessage = function(data, flags) {
  console.log('WebSocketClient: message', data, flags);
};
WebSocketClient.prototype.onclose = function() {
  console.log('WebSocketClient: closed');
};
