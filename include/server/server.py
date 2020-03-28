# -*- coding: utf-8 -*-

# This file is part of bw.

# Distributed under the terms of the last AGPL License.
# The full license is in the file LICENCE, distributed as part of this software.


__author__ = 'Jean Chassoul'


import uuid
import riak
import sys
import logging

from functools import partial
from zmq.eventloop.future import Context
from zmq.eventloop.ioloop import IOLoop

from tornado import ioloop
from tornado import gen, web
from bw.handlers import BaseHandler as StatusHandler
from bw.handlers import games
from bw.tools import options
from bw.tools import zstreams 


@gen.coroutine
def run(port):
    context = Context()
    yield zeromq.run_collector(context, port)


def main():
    '''
        bw main function
    '''
    # bw daemon options
    opts = options.options()
    # Riak key-value storage
    db = riak.RiakClient(host=opts.riak_host, pb_port=8087)
    # System uuid
    system_uuid = uuid.uuid4()
    # System spawned 
    logging.info('bw {0} spawned'.format(system_uuid))
    # debug riak settings
    logging.info('Riak server: {0}:{1}'.format(opts.riak_host, opts.riak_port))
    # application web daemon
    application = web.Application(
        [
            (r'/status/?', StatusHandler),
            (r'/games/page/(?P<page_num>\d+)/?', games.Handler),
            (r'/games/(?P<game_uuid>.+)/?', games.Handler),
            (r'/games/?', games.Handler),
        ],
        db=db,
        debug=opts.debug,
        domain=opts.domain,
        page_size=opts.page_size
    )
    # Listen daemon on custom port
    collect_port = int(opts.port) + 1
    # ?
    application.listen(collect_port)
    logging.info('Listen on http://{0}:{1}'.format(opts.host, collect_port))
    # Setting up the ZeroMQ integration
    IOLoop.current().spawn_callback(
        partial(run, opts.streams_port, )
    )
    # Start the eventloop
    ioloop.IOLoop.instance().start()


if __name__ == '__main__':
    '''
        Just when I thought I was out, they pull me back in!
    '''
    main()
