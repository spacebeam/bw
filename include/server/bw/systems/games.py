# -*- coding: utf-8 -*-

# This file is part of bw.

# Distributed under the terms of the last AGPL License.


__author__ = 'Jean Chassoul'


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
            message = event["uuid"]
            game = bucket.new(message, data=event)
            game.add_index("uuid_bin", message)
            game.add_index("game_int", event["game"])
            game.add_index("session_bin", event["session"])
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
        #
        # cool and all but wtf with session, start, end, lapse and status?
        #
        r = []
        message = {
            'count': 0,
            'page': page_num,
            'results': r}
        upper_limit = 58806 * 3
        page_num = int(page_num)
        page_size = self.settings['page_size']
        start_num = page_size * (page_num - 1)
        end_num = start_num + page_size
        bucket_name = 'games'
        bucket = self.db.bucket(bucket_name)
        query = bucket.stream_index("game_int", 1, upper_limit)
        for x in query:
            for y in x:
                r.append(y)
        message['count'] = len(r)
        message['results'] = [
            y.data for y in (bucket.get(x) for x in r[start_num:end_num])
        ]
        return message

    @gen.coroutine
    def modify_game(self, session, game_uuid, struct):
        '''
            Modify game
        '''
        bucket_name = 'games'
        bucket = self.db.bucket(bucket_name)
        results = bucket.get_index("uuid_bin", game_uuid)
        message = [y for y in (bucket.get(x) for x in results)]
        if message:
            message = message[0]
        else:
            message = {'message': 'not found'}
        message.data.update(struct)
        try:
            event = games.Game(message.data)
            event.validate()
        except Exception as error:
            raise error
        message.store()
        message = {'update_complete': True}
        return message.get('update_complete', False)

    @gen.coroutine
    def remove_game(self, session, game_uuid):
        '''
            Remove game
        '''
        # Missing history !
        struct = {}
        struct['status'] = 'deleted'
        message = yield self.modify_game(session, game_uuid, struct)
        return message
