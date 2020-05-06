# -*- coding: utf-8 -*-

# This file is part of bw.

# Distributed under the terms of the last AGPL License.


__author__ = 'Jean Chassoul'


import zmq
import logging

from tornado import gen

from tornado import httpclient as _http_client

_curl_client = 'tornado.curl_httpclient.CurlAsyncHTTPClient'
_http_client.AsyncHTTPClient.configure(_curl_client)
http_client = _http_client.AsyncHTTPClient()


@gen.coroutine
def run_collector(context, port):
    # Socket to receive messages on
    receiver = context.socket(zmq.PULL)
    custom_port = int(port) + 1
    receiver.bind("tcp://*:{0}".format(custom_port))
    logging.info("Listen PULL collector on tcp://*:{0}".format(custom_port))
    while True:
        m = yield receiver.recv()
        logging.warning(m)
        yield gen.sleep(0.0020)


@gen.coroutine
def run_producer(context, host, port):
    # Socket to send messages on
    sender = context.socket(zmq.PUSH)
    sender.bind("tcp://*:{0}".format(port))
    # Socket with access to the collector: used to syncronize the batch
    collect = context.socket(zmq.PUSH)
    logging.info('Connecting to ZMQ tcp://localhost:{0}'.format(port + 1))
    collect.connect("tcp://localhost:{0}".format(port + 1))
    # 1,2,3 testing, testing!
    logging.info("Signal the collector to syncronize the batch")
    while True:
        yield collect.send(b'0')
        # games = yield check_active_games()
        # for g in games.get('results'):
        #    status = yield processing_game_status(host, g)
        #    workload = yield produce_game_workload(host, g)
        #    total_work = len(workload)
        #    for x in range(total_work):
        #        workload[x]['game_ref'] = g
        #        workload[x]['current_leg'] = x + 1
        #        workload[x]['total_batch'] = total_work
        #        sender.send_json(json.dumps(workload[x]))
        #        if x  == total_work - 1:
        #            logging.info('that was the last item from current game')
        # Give the system time to deliver
        yield gen.sleep(5.000)
