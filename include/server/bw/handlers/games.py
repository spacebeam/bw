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

from bw.schemas import games as models
from bw.systems import games

from bw.tools import str2bool, check_json
from bw.handlers import BaseHandler
from collections import OrderedDict


class Handler(games.Games, BaseHandler):
    '''
        HTTP request handlers
    '''

    @gen.coroutine
    def head(self,
             session=None,
             game_uuid=None,
             start=None,
             end=None,
             lapse='hours',
             page_num=1):
        '''
            Get games
        '''
        # request query arguments
        query_args = self.request.arguments
        # getting pagination ready
        page_num = int(query_args.get('page', [page_num])[0])
        # rage against the finite state machine
        status = 'all'
        # init message on error
        message = {'error':True}
        # init status that match with our message
        self.set_status(400)
        # check if we're list processing
        if not game_uuid:
            message = yield self.get_game_list(session,
                                               start,
                                               end,
                                               lapse,
                                               status,
                                               page_num)
            self.set_status(200)
        else:
            game_uuid = game_uuid.rstrip('/')
            message = yield self.get_game(session, game_uuid)
            self.set_status(200)
        # so long and thanks for all the fish
        self.finish(message)

    @gen.coroutine
    def get(self,
            session=None,
            game_uuid=None,
            start=None,
            end=None,
            lapse='hours',
            page_num=1):
        '''
            Get games
        '''
        # request query arguments
        query_args = self.request.arguments
        # getting pagination ready
        page_num = int(query_args.get('page', [page_num])[0])
        # rage against the finite state machine
        status = 'all'
        # init message on error
        message = {'error':True}
        # init status that match with our message
        self.set_status(400)
        # check if we're list processing
        if not game_uuid:
            message = yield self.get_game_list(session,
                                               start,
                                               end,
                                               lapse,
                                               status,
                                               page_num)
            self.set_status(200)
        else:
            game_uuid = game_uuid.rstrip('/')
            message = yield self.get_game(session, game_uuid)
            self.set_status(200)
        # so long and thanks for all the fish
        self.finish(message)

    @gen.coroutine
    def post(self):
        '''
            Create game
        '''
        struct = yield check_json(self.request.body)
        format_pass = (True if struct and not struct.get('errors') else False)
        if not format_pass:
            self.set_status(400)
            self.finish({'JSON':format_pass})
            return
        # create new game struct
        game_uuid = yield self.new_game(struct)
        # complete message with receive uuid.
        message = {'uuid':game_uuid}
        self.set_status(201)
        self.finish(message)

    @gen.coroutine
    def patch(self, game_uuid):
        '''
            Modify game
        '''
        struct = yield check_json(self.request.body)
        format_pass = (True if not dict(struct).get('errors', False) else False)
        if not format_pass:
            self.set_status(400)
            self.finish({'JSON':format_pass})
            return
        account = self.request.arguments.get('account', [None])[0]
        if not account:
            # if not account we try to get the account from struct
            account = struct.get('account', None)
        result = yield self.modify_game(account, game_uuid, struct)
        if not result:
            self.set_status(400)
            system_error = errors.Error('missing')
            error = system_error.missing('game', game_uuid)
            self.finish(error)
            return
        self.set_status(200)
        self.finish({'message': 'update completed successfully'})

    @gen.coroutine
    def delete(self, game_uuid):
        '''
            Delete game
        '''
        query_args = self.request.arguments
        account = query_args.get('account', [None])[0]
        result = yield self.remove_game(account, game_uuid)
        if not result:
            self.set_status(400)
            system_error = errors.Error('missing')
            error = system_error.missing('game', game_uuid)
            self.finish(error)
            return
        self.set_status(204)
        self.finish()

    @gen.coroutine
    def options(self, game_uuid=None):
        '''
            Resource options
        '''
        self.set_header('Access-Control-Allow-Origin', '*')
        self.set_header('Access-Control-Allow-Methods', 'HEAD, GET, POST, PATCH, DELETE, OPTIONS')
        self.set_header('Access-Control-Allow-Headers', ''.join(('Accept-Language,',
                        'DNT,Keep-Alive,User-Agent,X-Requested-With,',
                        'If-Modified-Since,Cache-Control,Content-Type,',
                        'Content-Range,Range,Date,Etag')))
        # allowed http methods
        message = {
            'Allow': ['HEAD', 'GET', 'POST', 'PATCH', 'DELETE', 'OPTIONS']
        }
        # resource parameters
        parameters = {}
        # mock your stuff
        stuff = False
        while not stuff:
            try:
                stuff = models.Game.get_mock_object().to_primitive()
            except Exception as error:
                pass
        for k, v in stuff.items():
            if v is None:
                parameters[k] = str(type('none'))
            else:
                parameters[k] = str(type(v))
        # after automatic madness return description and parameters
        parameters['labels'] = 'array/string'
        # end of manual cleaning
        POST = {
            "description": "Create a new game",
            "parameters": OrderedDict(sorted(parameters.items(), key=lambda t: t[0]))
        }
        # filter single resource
        if not game_uuid:
            message['POST'] = POST
        else:
            message['Allow'].remove('POST')
            message['Allow'].append('PATCH')
            message['Allow'].append('DELETE')
        self.set_status(200)
        self.finish(message)
