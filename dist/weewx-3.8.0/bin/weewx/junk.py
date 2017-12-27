# -*- coding: utf-8 -*-

import Cheetah.Template
import Cheetah.Filters

import weewx.units

class Temperature(object):
    
    def __str__(self):
        return "called from __str___ 15°C"
    
    def __unicode__(self):
        return u"called from __unicode__ 15°C"
    
t = Temperature()
print t

template = """The temperature is $temperature"""
encoding = 'utf8'
searchList = {'temperature':t}
text = Cheetah.Template.Template(
    template,
    searchList=searchList,
    filter=encoding,
    filtersLib=weewx.junk)

# =============================================================================
# Filters used for encoding
# =============================================================================

class html_entities(Cheetah.Filters.Filter):

    def filter(self, val, **dummy_kw): #@ReservedAssignment
        """Filter incoming strings so they use HTML entity characters"""
        if isinstance(val, unicode):
            filtered = val.encode('ascii', 'xmlcharrefreplace')
        elif val is None:
            filtered = ''
        elif isinstance(val, str):
            filtered = val.decode('utf-8').encode('ascii', 'xmlcharrefreplace')
        else:
            filtered = self.filter(str(val))
        return filtered

class strict_ascii(Cheetah.Filters.Filter):

    def filter(self, val, **dummy_kw): #@ReservedAssignment
        """Filter incoming strings to strip out any non-ascii characters"""
        if isinstance(val, unicode):
            filtered = val.encode('ascii', 'ignore')
        elif val is None:
            filtered = ''
        elif isinstance(val, str):
            filtered = val.decode('utf-8').encode('ascii', 'ignore')
        else:
            filtered = self.filter(str(val))
        return filtered
    
class utf8(Cheetah.Filters.Filter):

    def filter(self, val, **dummy_kw): #@ReservedAssignment
        """Filter incoming strings, converting to UTF-8"""
        if isinstance(val, unicode):
            filtered = val.encode('utf8')
        elif val is None:
            filtered = ''
        else:
            filtered = str(val)
        return filtered
