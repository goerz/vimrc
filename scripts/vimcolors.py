#!/usr/bin/env python

CLUT = [  # color look-up table
#    8-bit, RGB hex

    # Primary 3-bit (8 colors). Unique representation!
    ('00',  '000000'),
    ('01',  '800000'),
    ('02',  '008000'),
    ('03',  '808000'),
    ('04',  '000080'),
    ('05',  '800080'),
    ('06',  '008080'),
    ('07',  'c0c0c0'),

    # Equivalent "bright" versions of original 8 colors.
    ('08',  '808080'),
    ('09',  'ff0000'),
    ('10',  '00ff00'),
    ('11',  'ffff00'),
    ('12',  '0000ff'),
    ('13',  'ff00ff'),
    ('14',  '00ffff'),
    ('15',  'ffffff'),

    # Strictly ascending.
    ('16',  '000000'),
    ('17',  '00005f'),
    ('18',  '000087'),
    ('19',  '0000af'),
    ('20',  '0000d7'),
    ('21',  '0000ff'),
    ('22',  '005f00'),
    ('23',  '005f5f'),
    ('24',  '005f87'),
    ('25',  '005faf'),
    ('26',  '005fd7'),
    ('27',  '005fff'),
    ('28',  '008700'),
    ('29',  '00875f'),
    ('30',  '008787'),
    ('31',  '0087af'),
    ('32',  '0087d7'),
    ('33',  '0087ff'),
    ('34',  '00af00'),
    ('35',  '00af5f'),
    ('36',  '00af87'),
    ('37',  '00afaf'),
    ('38',  '00afd7'),
    ('39',  '00afff'),
    ('40',  '00d700'),
    ('41',  '00d75f'),
    ('42',  '00d787'),
    ('43',  '00d7af'),
    ('44',  '00d7d7'),
    ('45',  '00d7ff'),
    ('46',  '00ff00'),
    ('47',  '00ff5f'),
    ('48',  '00ff87'),
    ('49',  '00ffaf'),
    ('50',  '00ffd7'),
    ('51',  '00ffff'),
    ('52',  '5f0000'),
    ('53',  '5f005f'),
    ('54',  '5f0087'),
    ('55',  '5f00af'),
    ('56',  '5f00d7'),
    ('57',  '5f00ff'),
    ('58',  '5f5f00'),
    ('59',  '5f5f5f'),
    ('60',  '5f5f87'),
    ('61',  '5f5faf'),
    ('62',  '5f5fd7'),
    ('63',  '5f5fff'),
    ('64',  '5f8700'),
    ('65',  '5f875f'),
    ('66',  '5f8787'),
    ('67',  '5f87af'),
    ('68',  '5f87d7'),
    ('69',  '5f87ff'),
    ('70',  '5faf00'),
    ('71',  '5faf5f'),
    ('72',  '5faf87'),
    ('73',  '5fafaf'),
    ('74',  '5fafd7'),
    ('75',  '5fafff'),
    ('76',  '5fd700'),
    ('77',  '5fd75f'),
    ('78',  '5fd787'),
    ('79',  '5fd7af'),
    ('80',  '5fd7d7'),
    ('81',  '5fd7ff'),
    ('82',  '5fff00'),
    ('83',  '5fff5f'),
    ('84',  '5fff87'),
    ('85',  '5fffaf'),
    ('86',  '5fffd7'),
    ('87',  '5fffff'),
    ('88',  '870000'),
    ('89',  '87005f'),
    ('90',  '870087'),
    ('91',  '8700af'),
    ('92',  '8700d7'),
    ('93',  '8700ff'),
    ('94',  '875f00'),
    ('95',  '875f5f'),
    ('96',  '875f87'),
    ('97',  '875faf'),
    ('98',  '875fd7'),
    ('99',  '875fff'),
    ('100', '878700'),
    ('101', '87875f'),
    ('102', '878787'),
    ('103', '8787af'),
    ('104', '8787d7'),
    ('105', '8787ff'),
    ('106', '87af00'),
    ('107', '87af5f'),
    ('108', '87af87'),
    ('109', '87afaf'),
    ('110', '87afd7'),
    ('111', '87afff'),
    ('112', '87d700'),
    ('113', '87d75f'),
    ('114', '87d787'),
    ('115', '87d7af'),
    ('116', '87d7d7'),
    ('117', '87d7ff'),
    ('118', '87ff00'),
    ('119', '87ff5f'),
    ('120', '87ff87'),
    ('121', '87ffaf'),
    ('122', '87ffd7'),
    ('123', '87ffff'),
    ('124', 'af0000'),
    ('125', 'af005f'),
    ('126', 'af0087'),
    ('127', 'af00af'),
    ('128', 'af00d7'),
    ('129', 'af00ff'),
    ('130', 'af5f00'),
    ('131', 'af5f5f'),
    ('132', 'af5f87'),
    ('133', 'af5faf'),
    ('134', 'af5fd7'),
    ('135', 'af5fff'),
    ('136', 'af8700'),
    ('137', 'af875f'),
    ('138', 'af8787'),
    ('139', 'af87af'),
    ('140', 'af87d7'),
    ('141', 'af87ff'),
    ('142', 'afaf00'),
    ('143', 'afaf5f'),
    ('144', 'afaf87'),
    ('145', 'afafaf'),
    ('146', 'afafd7'),
    ('147', 'afafff'),
    ('148', 'afd700'),
    ('149', 'afd75f'),
    ('150', 'afd787'),
    ('151', 'afd7af'),
    ('152', 'afd7d7'),
    ('153', 'afd7ff'),
    ('154', 'afff00'),
    ('155', 'afff5f'),
    ('156', 'afff87'),
    ('157', 'afffaf'),
    ('158', 'afffd7'),
    ('159', 'afffff'),
    ('160', 'd70000'),
    ('161', 'd7005f'),
    ('162', 'd70087'),
    ('163', 'd700af'),
    ('164', 'd700d7'),
    ('165', 'd700ff'),
    ('166', 'd75f00'),
    ('167', 'd75f5f'),
    ('168', 'd75f87'),
    ('169', 'd75faf'),
    ('170', 'd75fd7'),
    ('171', 'd75fff'),
    ('172', 'd78700'),
    ('173', 'd7875f'),
    ('174', 'd78787'),
    ('175', 'd787af'),
    ('176', 'd787d7'),
    ('177', 'd787ff'),
    ('178', 'd7af00'),
    ('179', 'd7af5f'),
    ('180', 'd7af87'),
    ('181', 'd7afaf'),
    ('182', 'd7afd7'),
    ('183', 'd7afff'),
    ('184', 'd7d700'),
    ('185', 'd7d75f'),
    ('186', 'd7d787'),
    ('187', 'd7d7af'),
    ('188', 'd7d7d7'),
    ('189', 'd7d7ff'),
    ('190', 'd7ff00'),
    ('191', 'd7ff5f'),
    ('192', 'd7ff87'),
    ('193', 'd7ffaf'),
    ('194', 'd7ffd7'),
    ('195', 'd7ffff'),
    ('196', 'ff0000'),
    ('197', 'ff005f'),
    ('198', 'ff0087'),
    ('199', 'ff00af'),
    ('200', 'ff00d7'),
    ('201', 'ff00ff'),
    ('202', 'ff5f00'),
    ('203', 'ff5f5f'),
    ('204', 'ff5f87'),
    ('205', 'ff5faf'),
    ('206', 'ff5fd7'),
    ('207', 'ff5fff'),
    ('208', 'ff8700'),
    ('209', 'ff875f'),
    ('210', 'ff8787'),
    ('211', 'ff87af'),
    ('212', 'ff87d7'),
    ('213', 'ff87ff'),
    ('214', 'ffaf00'),
    ('215', 'ffaf5f'),
    ('216', 'ffaf87'),
    ('217', 'ffafaf'),
    ('218', 'ffafd7'),
    ('219', 'ffafff'),
    ('220', 'ffd700'),
    ('221', 'ffd75f'),
    ('222', 'ffd787'),
    ('223', 'ffd7af'),
    ('224', 'ffd7d7'),
    ('225', 'ffd7ff'),
    ('226', 'ffff00'),
    ('227', 'ffff5f'),
    ('228', 'ffff87'),
    ('229', 'ffffaf'),
    ('230', 'ffffd7'),
    ('231', 'ffffff'),

    # Gray-scale range.
    ('232', '080808'),
    ('233', '121212'),
    ('234', '1c1c1c'),
    ('235', '262626'),
    ('236', '303030'),
    ('237', '3a3a3a'),
    ('238', '444444'),
    ('239', '4e4e4e'),
    ('240', '585858'),
    ('241', '626262'),
    ('242', '6c6c6c'),
    ('243', '767676'),
    ('244', '808080'),
    ('245', '8a8a8a'),
    ('246', '949494'),
    ('247', '9e9e9e'),
    ('248', 'a8a8a8'),
    ('249', 'b2b2b2'),
    ('250', 'bcbcbc'),
    ('251', 'c6c6c6'),
    ('252', 'd0d0d0'),
    ('253', 'dadada'),
    ('254', 'e4e4e4'),
    ('255', 'eeeeee'),
]

clut_dict = {int(k): v for (k, v) in CLUT}


def grey_number(x):
    """Approximate grey index for the given grey level"""
    if x < 14:
        return 0
    else:
        n = (x - 8) // 10
        m = (x - 8) % 10
        if m < 5:
            return n
        else:
            return n + 1


def grey_level(n):
    """Actual grey level represented by the grey index"""
    if n == 0:
        return 0
    else:
        return 8 + n * 10


def grey_colour(n):
    """Palette index for grey index"""
    if n == 0:
        return 16
    elif n == 25:
        return 231
    else:
        return 231 + n


def rgb_number(x):
    """Actual colour level for the given colour index"""
    if x < 75:
        return 0
    else:
        n = (x - 55) // 40
        m = (x - 55) % 40
        if m < 20:
            return n
        else:
            return n + 1


def rgb_level(n):
    """Return the actual colour level for the given colour index"""
    if n == 0:
        return 0
    else:
        return 55 + n * 40


def rgb_colour(x, y, z):
  """Palette index for the given R/G/B colour indices"""
  return 16 + (x * 36) + (y * 6) + z


def colour(r, g, b):
    """Palette index that approximates the given R/G/B colour levels"""
    # get the closest grey
    gx = grey_number(r)
    gy = grey_number(g)
    gz = grey_number(b)

    # get the closest colour
    x = rgb_number(r)
    y = rgb_number(g)
    z = rgb_number(b)

    if x == y == z:
        # there are two possibilities
        dgr = grey_level(gx) - r
        dgg = grey_level(gy) - g
        dgb = grey_level(gz) - b
        dgrey = (dgr * dgr) + (dgg * dgg) + (dgb * dgb)
        dr = rgb_level(gx) - r
        dg = rgb_level(gy) - g
        db = rgb_level(gz) - b
        drgb = (dr * dr) + (dg * dg) + (db * db)
        if dgrey < drgb:
            return grey_colour(gx)
        else:
            return rgb_colour(x, y, z)
    else:
        # only one possibility
        return rgb_colour(x, y, z)


def rgb_to_index(rrggbb):
    """Palette index that approximate the 'rrggbb' hex string"""
    rrggbb = rrggbb.replace('#', '')
    assert len(rrggbb) == 6
    r = int(rrggbb[0:2], 16)
    g = int(rrggbb[2:4], 16)
    b = int(rrggbb[4:6], 16)
    return colour(r, g, b)


def index_to_rgb(ind):
    """'rrggbb' hex string that corresponds to palette index"""
    return clut_dict[ind]


def rgb_to_rgb(rrggbb):
    """Return the 'rrggbb' hex string that most closely resembles the input
    'rrggbb' string"""
    return index_to_rgb(rgb_to_index(rrggbb))

def print_all():
    for i in range(256):
        print("\033[48;5;{i}m\033[38;5;15m {i:03d} ".format(i=i), end=' ')
        print("\033[33;5;0m\033[38;5;{i}m {i:03d} ".format(i=i), end= ' ')
        print("\033[0m", end='')
        print(clut_dict[i])

if __name__ == "__main__":
    print_all()
