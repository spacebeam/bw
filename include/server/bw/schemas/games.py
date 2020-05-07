# -*- coding: utf-8 -*-

# This file is part of bw.

# Distributed under the terms of the last AGPL License.


__author__ = 'Jean Chassoul'


import uuid
import datetime

from schematics import models
from schematics import types
from schematics.types import compound


class Game(models.Model):
    '''
        Game Data Structure
    '''
    uuid = types.UUIDType(default=uuid.uuid4)
    game = types.IntType(required=True)
    status = types.StringType(choices=['new',
                                       'starting',
                                       'in-progress',
                                       'completed',
                                       'deleted'], default='new')
    labels = types.DictType(types.StringType)
    history = compound.ListType(types.StringType())
    address = types.IPAddressType()
    session = types.UUIDType()
    bots = types.StringType(required=True)
    map = types.StringType(required=True)
    replay = types.StringType()
    home = types.StringType()
    home_is_winner = types.BooleanType(default=False)
    home_crashed = types.BooleanType(default=False)
    home_timed_out = types.BooleanType(default=False)
    home_building_score = types.IntType()
    home_razing_score = types.IntType()
    home_unit_score = types.IntType()
    away = types.StringType()
    away_is_winner = types.BooleanType(default=False)
    away_crashed = types.BooleanType(default=False)
    away_timed_out = types.BooleanType(default=False)
    away_building_score = types.IntType()
    away_razing_score = types.IntType()
    away_unit_score = types.IntType()
    created_by = types.UUIDType()
    created_at = types.DateTimeType(default=datetime.datetime.utcnow)
    last_update_by = types.UUIDType()
    last_update_at = types.TimestampType()
