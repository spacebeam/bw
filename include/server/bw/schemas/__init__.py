# -*- coding: utf-8 -*-

# This file is part of bw.

# Distributed under the terms of the last AGPL License.


__author__ = 'Jean Chassoul'


from schematics import models
from schematics import types
from schematics.types import compound


class BaseResult(models.Model):
    '''
        Base result
    '''
    count = types.IntType()
    page = types.IntType()
    results = compound.ListType(types.StringType())
