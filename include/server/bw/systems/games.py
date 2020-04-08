# -*- coding: utf-8 -*-

# This file is part of bw.

# Distributed under the terms of the last AGPL License.


__author__ = 'Jean Chassoul'


import uuid
import logging
from tornado import gen
from schematics.types import compound

from bw.schemas import games
from bw.schemas import BaseResult

from bw.tools import clean_structure

from tornado import httpclient as _http_client

curl_client = 'tornado.curl_httpclient.CurlAsyncHTTPClient'
_http_client.AsyncHTTPClient.configure(curl_client)
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
    def new_game(self, struct):
        '''
            New game event
        '''
        bucket_name = 'games'
        bucket = self.db.bucket(bucket_name)
        try:
            event = games.Game(struct)
            event.validate()
            event = clean_structure(event)
        except Exception as error:
            raise error
        try:
            #
            # this is the reminder of an old more complex and lost confused past
            #
            structure = {
                "uuid": str(event.get('uuid', str(uuid.uuid4()))),
                "game": str(event.get('game', '')),
                "status": str(event.get('status', '')),
                "labels": str(event.get('labels', '')),
                "history": str(event.get('history', '')),
                "address": str(event.get('address', '')),
                "session": str(event.get('session', '')),
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
            message = structure.get('uuid')
            game = bucket.new(message, data=structure)
            game.add_index("uuid_bin", message)
            game.add_index("game_int", int(structure["game"]))
            game.add_index("session_bin", structure["session"])
            game.store()
        except Exception as error:
            logging.error(error)
            message = str(error)
        return message

    @gen.coroutine
    def get_game(self, session, game_uuid):
        '''
            Get game
        '''
        
        # session was old account it seems its no needed at all in our current context
        # also we can query by different indexes, session is one of them
        # that is the only reason this stays here for a little longer
        
        bucket_name = 'games'
        bucket = self.db.bucket(bucket_name)
        results = bucket.get_index("uuid_bin", game_uuid)
        message = [y.data for y in (bucket.get(x) for x in results)]
        if message:
            message = message[0]
        else:
            message = {'message': 'not found'}
        return message

    @gen.coroutine
    def get_game_list(self, session, start, end, lapse, status, page_num):
        '''
            Get task list
        '''
        # page number
        page_num = int(page_num)
        page_size = self.settings['page_size']
        start_num = page_size * (page_num - 1)
        
        # howto do pagination with secondary indexes ?
        bucket_name = 'games'
        bucket = self.db.bucket(bucket_name)
        
        results = bucket.stream_index("game_int", 1, 9)
        message = [y.data for y in (bucket.get(x[0]) for x in results)]
        if message:
            message = {
                'count': 0,
                'page': page_num,
                'results': message
            }
        else:
            # init crash message
            message = {
                'count': 0,
                'page': page_num,
                'results': []
            }
        return message

    @gen.coroutine
    def modify_game(self, session, game_uuid, struct):
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
    def remove_game(self, session, game_uuid):
        '''
            Remove game
        '''
        # Missing history ?
        struct = {}
        struct['status'] = 'deleted'
        message = yield self.modify_game(session, game_uuid, struct)
        return message
