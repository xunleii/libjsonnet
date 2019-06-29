local test = import 'jsonnetunit/jsonnetunit/test.libsonnet';
local network = import 'network.libjsonnet';


local addr = network.ipv4.addr.parse('1.1.1.1/13');
local subnet = network.ipv4.subnet('1.1.1.1/13');
test.suite({
  testParse_string: { actual: network.ipv4.addr.parse('1.1.1.1/13').full, expect: '1.1.1.1/13' },
  testParse_mixed: { actual: network.ipv4.addr.parse('1.1.1.1', addr.mask).full, expect: '1.1.1.1/13' },
  testParse_int: { actual: network.ipv4.addr.parse(addr.bytes, addr.mask).full, expect: '1.1.1.1/13' },

  'testParse_0.0.0.0/0_short': { actual: network.ipv4.addr.parse('0.0.0.0/0').short, expect: '0.0.0.0' },
  'testParse_0.0.0.0/0_full': { actual: network.ipv4.addr.parse('0.0.0.0/0').full, expect: '0.0.0.0/0' },
  'testParse_0.0.0.0/0_mask': { actual: network.ipv4.addr.parse('0.0.0.0/0').mask, expect: 0 },
  'testParse_0.0.0.0/0_bytes': { actual: network.ipv4.addr.parse('0.0.0.0/0').bytes, expect: 0 },

  'testParse_255.255.255.255/32_short': { actual: network.ipv4.addr.parse('255.255.255.255/32').short, expect: '255.255.255.255' },
  'testParse_255.255.255.255/32_full': { actual: network.ipv4.addr.parse('255.255.255.255/32').full, expect: '255.255.255.255/32' },
  'testParse_255.255.255.255/32_mask': { actual: network.ipv4.addr.parse('255.255.255.255/32').mask, expect: 32 },
  'testParse_255.255.255.255/32_bytes': { actual: network.ipv4.addr.parse('255.255.255.255/32').bytes, expect: 4294967295 },

  'testSubnet_10.0.0.0/8': {
    actual: network.ipv4.subnet('10.0.0.0/8'),
    expect: { address: '10.0.0.0', broadcast: '10.255.255.255', hostMax: '10.255.255.254', hostMin: '10.0.0.1', mask: 8, netmask: '255.0.0.0', numHost: 16777214, wildcard: '0.255.255.255' },
  },
  'testSubnet_10.0.0.0/8_prev': {
    actual: network.ipv4.subnet('10.0.0.0/8').prev(),
    expect: { address: '9.0.0.0', broadcast: '9.255.255.255', hostMax: '9.255.255.254', hostMin: '9.0.0.1', mask: 8, netmask: '255.0.0.0', numHost: 16777214, wildcard: '0.255.255.255' },
  },
  'testSubnet_10.0.0.0/8_next': {
    actual: network.ipv4.subnet('10.0.0.0/8').next(),
    expect: { address: '11.0.0.0', broadcast: '11.255.255.255', hostMax: '11.255.255.254', hostMin: '11.0.0.1', mask: 8, netmask: '255.0.0.0', numHost: 16777214, wildcard: '0.255.255.255' },
  },
  'testSubnet_10.0.0.0/8_next_5': {
    actual: network.ipv4.subnet('10.0.0.0/8').next(5),
    expect: { address: '15.0.0.0', broadcast: '15.255.255.255', hostMax: '15.255.255.254', hostMin: '15.0.0.1', mask: 8, netmask: '255.0.0.0', numHost: 16777214, wildcard: '0.255.255.255' },
  },
  'testSubnet_192.168.1.0/31': {
    actual: network.ipv4.subnet('192.168.1.0/31'),
    expect: { address: '192.168.1.0', broadcast: null, hostMax: '192.168.1.1', hostMin: '192.168.1.0', mask: 31, netmask: '255.255.255.254', numHost: 2, wildcard: '0.0.0.1' },
  },
  'testSubnet_127.0.0.1/32': {
    actual: network.ipv4.subnet('127.0.0.1/32'),
    expect: { address: '127.0.0.1', broadcast: null, hostMax: '127.0.0.1', hostMin: '127.0.0.1', mask: 32, netmask: '255.255.255.255', numHost: 1, wildcard: '0.0.0.0' },
  },

  'testSubnet_0.0.0.0/0': {
    actual: network.ipv4.subnet('0.0.0.0/0'),
    expect: { address: '0.0.0.0', broadcast: '255.255.255.255', hostMax: '255.255.255.254', hostMin: '0.0.0.1', mask: 0, netmask: '0.0.0.0', numHost: 4294967294, wildcard: '255.255.255.255' },
  },
  'testSubnet_255.255.255.255/32': {
    actual: network.ipv4.subnet('255.255.255.255/32'),
    expect: { address: '255.255.255.255', broadcast: null, hostMax: '255.255.255.255', hostMin: '255.255.255.255', mask: 32, netmask: '255.255.255.255', numHost: 1, wildcard: '0.0.0.0' },
  },

  'testAddress_216.58.209.227/22': {
    actual: network.ipv4.subnet('216.58.209.227/22'),
    expect: { address: '216.58.208.0', broadcast: '216.58.211.255', hostMax: '216.58.211.254', hostMin: '216.58.208.1', mask: 22, netmask: '255.255.252.0', numHost: 1022, wildcard: '0.0.3.255' },
  },
  'testAddress_216.58.209.227/22_next_7': {
    actual: network.ipv4.subnet('216.58.209.227/22').next(7),
    expect: { address: '216.58.236.0', broadcast: '216.58.239.255', hostMax: '216.58.239.254', hostMin: '216.58.236.1', mask: 22, netmask: '255.255.252.0', numHost: 1022, wildcard: '0.0.3.255' },
  },
  'testAddress_216.58.209.227/11': {
    actual: network.ipv4.subnet('216.58.209.227/11'),
    expect: { address: '216.32.0.0', broadcast: '216.63.255.255', hostMax: '216.63.255.254', hostMin: '216.32.0.1', mask: 11, netmask: '255.224.0.0', numHost: 2097150, wildcard: '0.31.255.255' },
  },
  'testAddress_216.58.209.227/11_next_2': {
    actual: network.ipv4.subnet('216.58.209.227/11').next(2),
    expect: { address: '216.96.0.0', broadcast: '216.127.255.255', hostMax: '216.127.255.254', hostMin: '216.96.0.1', mask: 11, netmask: '255.224.0.0', numHost: 2097150, wildcard: '0.31.255.255' },
  },

  'testField_192.168.1.0/24_address': {
    actual: network.ipv4.subnet('192.168.1.0/24').address,
    expect: '192.168.1.0',
  },
  'testField_192.168.1.0/24_mask': {
    actual: network.ipv4.subnet('192.168.1.0/24').mask,
    expect: 24,
  },
  'testField_192.168.1.0/24_netmask': {
    actual: network.ipv4.subnet('192.168.1.0/24').netmask,
    expect: '255.255.255.0',
  },
  'testField_192.168.1.0/24_wildcard': {
    actual: network.ipv4.subnet('192.168.1.0/24').wildcard,
    expect: '0.0.0.255',
  },
  'testField_192.168.1.0/24_broadcast': {
    actual: network.ipv4.subnet('192.168.1.0/24').broadcast,
    expect: '192.168.1.255',
  },
  'testField_192.168.1.0/24_hostMax': {
    actual: network.ipv4.subnet('192.168.1.0/24').hostMax,
    expect: '192.168.1.254',
  },
  'testField_192.168.1.0/24_hostMin': {
    actual: network.ipv4.subnet('192.168.1.0/24').hostMin,
    expect: '192.168.1.1',
  },
  'testField_192.168.1.0/24_numHost': {
    actual: network.ipv4.subnet('192.168.1.0/24').numHost,
    expect: 254,
  },

  'testChaining_192.168.1.0/24_next_next2_next2_prev4': {
    actual: network.ipv4.subnet('192.168.1.0', 24).next().next(2).next(2).prev(4).address,
    expect: '192.168.2.0',
  },

  'testVariable_1.1.1.1/13_address': {
    actual: subnet.address,
    expect: '1.0.0.0',
  },
  'testVariable_1.1.1.1/13_next_address': {
    actual: subnet.next().address,
    expect: '1.8.0.0',
  },
})
