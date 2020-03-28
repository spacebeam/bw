# -*- coding: utf-8 -*-

# This file is part of bw.

# Distributed under the terms of the last AGPL License.
# The full license is in the file LICENCE, distributed as part of this software.


__author__ = 'Jean Chassoul'


import uuid
import logging
import ujson as json
from tornado import gen
from schematics.types import compound

from bw.schemas import games
from bw.schemas import BaseResult

from mango.tools import clean_structure, clean_results

from tornado import httpclient as _http_client


_http_client.AsyncHTTPClient.configure('tornado.curl_httpclient.CurlAsyncHTTPClient')
http_client = _http_client.AsyncHTTPClient()


class GamesResult(BaseResult):
    '''
        List result
    '''
    results = compound.ListType(compound.ModelType(games.Game))


class Games(object):
    '''
        Games
    '''

    @gen.coroutine
    def get_game(self, account, game_uuid):
        '''
            Get game
        '''
        # init got response list
        got_response = []
        # init crash message
        message = {'message': 'not found'}
        
        return message

    @gen.coroutine
    def get_game_list(self, account, start, end, lapse, status, page_num):
        '''
            Get task list
        '''
        # page number
        page_num = int(page_num)
        page_size = self.settings['page_size']
        start_num = page_size * (page_num - 1)
        # init got response list
        got_response = []
        # init crash message
        message = {
            'count': 0,
            'page': page_num,
            'results': []
        }
        
        return message

    @gen.coroutine
    def new_game(self, struct):
        '''
            New game event
        '''
        search_index = 'bw_game_index'
        bucket_type = 'bw_game'
        bucket_name = 'games'
        try:
            event = games.Game(struct)
            event.validate()
            event = clean_structure(event)
        except Exception as error:
            raise error
        try:
            structure = {
                "uuid": str(event.get('uuid', str(uuid.uuid4()))),
                "game": str(event.get('game', '')),
                "status": str(event.get('status', '')),
                "labels": str(event.get('labels', '')),
                "history": str(event.get('history', '')),
                "address": str(event.get('address', '')),
                "session ": str(event.get('session', '')),
                "bots": str(event.get('bots', '')),
                "map": str(event.get('map', '')),
                "replay": str(event.get('replay', '')),
                "home": str(event.get('home', '')),
                "home_is_winner": str(event.get('home_is_winner', '')),
                "home_crashed": str(event.get('home_crashed', '')),
                "home_timed_out": str(event.get('home_timed_out', '')),
                "home_building_score": str(event.get('home_building_score', '')),
                "home_razing_score": str(event.get('home_razing_score', '')),
                "home_unit_score": str(event.get('home_unit_score', '')),
                "away": str(event.get('away', '')),
                "away_is_winner": str(event.get('away_is_winner', '')),
                "away_crashed": str(event.get('away_crashed', '')),
                "away_timed_out": str(event.get('away_timed_out', '')),
                "away_building_score": str(event.get('away_building_score', '')),
                "away_razing_score": str(event.get('away_razing_score', '')),
                "away_unit_score": str(event.get('away_unit_score', '')),
                "created_by": str(event.get('created_by', '')),
                "created_at": str(event.get('created_at', '')),
                "last_update_by": str(event.get('last_update_by', '')),
                "last_update_at": str(event.get('last_update_at', '')),
            }
            result = ()
            message = structure.get('uuid')
        except Exception as error:
            logging.error(error)
            message = str(error)
        return message

    @gen.coroutine
    def modify_game(self, account, game_uuid, struct):
        '''
            Modify game
        '''
        # riak search index
        search_index = 'bw_game_index'
        # riak bucket type
        bucket_type = 'bw_game'
        # riak bucket name
        bucket_name = 'games'
        # got callback response?
        got_response = []
        # yours truly
        message = {'update_complete':False}
        
        return message.get('update_complete', False)

    @gen.coroutine
    def remove_game(self, account, game_uuid):
        '''
            Remove game
        '''
        # Missing history ?
        struct = {}
        struct['status'] = 'deleted'
        message = yield self.modify_game(account, game_uuid, struct)
        return message
