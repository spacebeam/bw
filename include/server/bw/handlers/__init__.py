# -*- coding: utf-8 -*-

# This file is part of bw.

# Distributed under the terms of the last AGPL License.


__author__ = 'Jean Chassoul'


from tornado import gen
from tornado import web

from tornado import httpclient as _http_client

_curl_client = 'tornado.curl_httpclient.CurlAsyncHTTPClient'
_http_client.AsyncHTTPClient.configure(_curl_client)
http_client = _http_client.AsyncHTTPClient()


class BaseHandler(web.RequestHandler):
    '''
        Daemon d'armi e ganti
    '''

    def initialize(self, **kwargs):
        '''
            init base handler
        '''
        super(BaseHandler, self).initialize(**kwargs)
        # System database
        self.db = self.settings.get('db')
        # Page settings
        self.page_size = self.settings.get('page_size')
        # Application domain
        self.domain = self.settings.get('domain')

    def set_default_headers(self):
        '''
            default headers
        '''
        self.set_header("Access-Control-Allow-Origin",
                        self.settings.get('domain', '*'))

    @gen.coroutine
    def get(self):
        message = {'ping': 'pong'}
        self.set_status(200)
        self.finish(message)
