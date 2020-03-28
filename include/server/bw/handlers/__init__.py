# -*- coding: utf-8 -*-

# This file is part of bw.

# Distributed under the terms of the last AGPL License.
# The full license is in the file LICENCE, distributed as part of this software.


__author__ = 'Jean Chassoul'


import uuid
import logging
import ujson as json
from tornado import gen
from tornado import web

# ?

from mango.tools import clean_structure, validate_uuid4
from mango.tools import get_search_item, get_search_list
from tornado import httpclient as _http_client


_http_client.AsyncHTTPClient.configure('tornado.curl_httpclient.CurlAsyncHTTPClient')
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
        # System cache
        self.cache = self.settings.get('cache')
        # Page settings
        self.page_size = self.settings.get('page_size')
        # Application domain
        self.domain = self.settings.get('domain')

    def set_default_headers(self):
        '''
            default headers
        '''
        self.set_header("Access-Control-Allow-Origin", self.settings.get('domain', '*'))

    @gen.coroutine
    def get(self):
        message = {'ping': 'pong'}
        self.set_status(200)
        self.finish(message)
