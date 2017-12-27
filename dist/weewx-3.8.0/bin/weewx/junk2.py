import weewx.units

from weewx.units import ValueHelper

value_t = (68.01, "degree_F", "group_temperature")
vh = ValueHelper(value_t)
x = str(vh)
print type(x)
print x