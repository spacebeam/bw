# -*- coding: utf-8 -*-

# This file is part of bw.

# Distributed under the terms of the last AGPL License.


__author__ = 'Jean Chassoul'


import uuid
import riak
import logging

from tornado import ioloop
from tornado import web
from bw.handlers import BaseHandler as StatusHandler
from bw.handlers import games
from bw.tools import options


# missing sessions resource

# missing zmq integration


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
    # Listen daemon on port
    application.listen(opts.port)
    logging.info('Listen on http://{0}:{1}'.format(opts.host, opts.port))
    # Start the eventloop
    ioloop.IOLoop.instance().start()


if __name__ == '__main__':
    '''
        Just when I thought I was out, they pull me back in!
    '''
    main()
