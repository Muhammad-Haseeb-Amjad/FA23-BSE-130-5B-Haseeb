#!/usr/bin/env python3
"""
Simple HTTP proxy - forwards requests from LAN to local Laravel server
"""

import http.server
import socketserver
import http.client
import sys

LOCAL_HOST = "127.0.0.1"
LOCAL_PORT = 8000
PROXY_PORT = 8888

class ProxyHandler(http.server.BaseHTTPRequestHandler):
    def do_POST(self):
        self.proxy_request()
    
    def do_GET(self):
        self.proxy_request()
    
    def proxy_request(self):
        """Forward HTTP request to local server"""
        try:
            # Create connection to local server
            conn = http.client.HTTPConnection(LOCAL_HOST, LOCAL_PORT, timeout=10)
            
            # Prepare headers
            headers = dict(self.headers)
            headers['Host'] = f"{LOCAL_HOST}:{LOCAL_PORT}"
            
            # Get body for POST
            content_length = self.headers.get('Content-Length')
            body = None
            if content_length:
                body = self.rfile.read(int(content_length))
            
            # Send request
            conn.request(self.command, self.path, body, headers)
            
            # Get response
            response = conn.getresponse()
            response_body = response.read()
            
            # Send response back to client
            self.send_response(response.status)
            for header, value in response.getheaders():
                self.send_header(header, value)
            self.end_headers()
            self.wfile.write(response_body)
            
            conn.close()
            
        except Exception as e:
            self.send_response(502)
            self.send_header('Content-Type', 'text/plain')
            self.end_headers()
            self.wfile.write(f"Proxy Error: {str(e)}".encode())
    
    def log_message(self, format, *args):
        client_ip = self.client_address[0]
        print(f"[{client_ip}] {self.command} {self.path} - {format % args}")

if __name__ == "__main__":
    try:
        with socketserver.TCPServer(("0.0.0.0", PROXY_PORT), ProxyHandler) as httpd:
            print(f"✅ Proxy listening on 0.0.0.0:{PROXY_PORT}")
            print(f"📍 Forwarding to {LOCAL_HOST}:{LOCAL_PORT}")
            print(f"🌐 Access from Android: http://192.168.100.4:{PROXY_PORT}")
            print("Press Ctrl+C to stop\n")
            httpd.serve_forever()
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)
