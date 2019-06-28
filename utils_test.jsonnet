local test = import 'jsonnetunit/jsonnetunit/test.libsonnet';
local utils = import 'utils.libjsonnet';

test.suite({
  local cases = {
    emptyArray: [],
    strArray: ['abc', 'bca', 'cab', 'cba', 'abc', 'bac'],
    intArray: [8, 2, -9, 10, -324, 9, 8],
    bigArray: std.range(0, 256),
    kongArray: std.range(0, 4096),

    simpleObj: { aaa: false, bbb: ['zzz', 'xxx', 'yyy'], ccc: '' },
    nestedObj: { aaa: true, bbb: ['yyy', 'xxx', 'www'], ccc: { ddd: true, eee: { fff: null }, ggg: [] }, hhh: {} },
    bigObj: utils.toObject(std.range(0, 256)),
  },

  // ------ Arrays tools
  // -- Arrays :: State tools (immutable)
  testAllTypeOfEmpty: { actual: utils.allTypeOf(cases.emptyArray, std.isString), expect: true },
  testAllTypeOfStr: { actual: utils.allTypeOf(cases.strArray, std.isString), expect: true },
  testAllTypeOfInt: { actual: utils.allTypeOf(cases.intArray, std.isNumber), expect: true },
  testNotAllTypeOfMixed: { actual: utils.allTypeOf(cases.strArray + cases.intArray, std.isString), expect: false },
  testIsEmpty: { actual: utils.isEmpty(cases.emptyArray), expect: true },
  testIsNotEmpty: { actual: utils.isEmpty(cases.strArray), expect: false },
  testContainsEmpty: { actual: utils.contains(cases.emptyArray, 'cba'), expect: false },
  testContainsStr: { actual: utils.contains(cases.strArray, 'cba'), expect: true },
  testContainsInt: { actual: utils.contains(cases.intArray, 9), expect: true },
  testNotContainsStr: { actual: utils.contains(cases.strArray, 'aaa'), expect: false },
  testNotContainsInt: { actual: utils.contains(cases.intArray, 0), expect: false },

  // -- Arrays :: Extraction tools (immutable)
  testFoundFirstStr: { actual: utils.findFirst(cases.strArray, 'abc'), expect: 0 },
  testFoundFirstInt: { actual: utils.findFirst(cases.intArray, 8), expect: 0 },
  testFoundFirstHeavy: { actual: utils.findFirst(cases.kongArray, 4096), expect: 4096 },
  testNotFoundFirstStr: { actual: utils.findFirst(cases.strArray, 'aaa'), expect: -1 },
  testNotFoundFirstInt: { actual: utils.findFirst(cases.intArray, 0), expect: -1 },
  testNotFoundFirstHeavy: { actual: utils.findFirst(cases.kongArray, -1), expect: -1 },
  testFoundFirstWithStr: { actual: utils.findFirstWith(cases.strArray, function(x) x == 'abc'), expect: 0 },
  testFoundFirstWithInt: { actual: utils.findFirstWith(cases.intArray, function(x) x < 5), expect: 1 },
  testFoundFirstWithHeavy: { actual: utils.findFirstWith(cases.kongArray, function(x) x > 4094), expect: 4095 },
  testNotFoundFirstWithStr: { actual: utils.findFirstWith(cases.strArray, function(x) x == 'aaa'), expect: -1 },
  testNotFoundFirstWithInt: { actual: utils.findFirstWith(cases.intArray, function(x) x > 10), expect: -1 },
  testNotFoundFirstWithHeavy: { actual: utils.findFirstWith(cases.kongArray, function(x) x < 0), expect: -1 },
  testFoundLastStr: { actual: utils.findLast(cases.strArray, 'abc'), expect: 4 },
  testFoundLastInt: { actual: utils.findLast(cases.intArray, 8), expect: 6 },
  testFoundLastHeavy: { actual: utils.findLast(cases.kongArray, 0), expect: 0 },
  testNotFoundLastStr: { actual: utils.findLast(cases.strArray, 'aaa'), expect: -1 },
  testNotFoundLastInt: { actual: utils.findLast(cases.intArray, 0), expect: -1 },
  testNotFoundLastHeavy: { actual: utils.findLast(cases.kongArray, -1), expect: -1 },
  testFoundLastWithStr: { actual: utils.findLastWith(cases.strArray, function(x) x == 'abc'), expect: 4 },
  testFoundLastWithInt: { actual: utils.findLastWith(cases.intArray, function(x) x < 5), expect: 4 },
  testFoundLastWithHeavy: { actual: utils.findLastWith(cases.kongArray, function(x) x < 1), expect: 0 },
  testNotFoundLastWithStr: { actual: utils.findLastWith(cases.strArray, function(x) x == 'aaa'), expect: -1 },
  testNotFoundLastWithInt: { actual: utils.findLastWith(cases.intArray, function(x) x > 10), expect: -1 },
  testNotFoundLastWithHeavy: { actual: utils.findLastWith(cases.kongArray, function(x) x < 0), expect: -1 },
  testFoundWithStr: { actual: utils.findWith(cases.strArray, function(x) x == 'abc'), expect: [0, 4] },
  testFoundWithInt: { actual: utils.findWith(cases.intArray, function(x) x < 5), expect: [1, 2, 4] },
  testNotFoundWithStr: { actual: utils.findWith(cases.strArray, function(x) x == 'aaa'), expect: [] },
  testNotFoundWithInt: { actual: utils.findWith(cases.intArray, function(x) x > 10), expect: [] },
  testNotFoundWithHeavy: { actual: utils.findWith(cases.kongArray, function(x) x > 4090), expect: [4091, 4092, 4093, 4094, 4095, 4096] },
  testHeadEmpty: { actual: utils.head(cases.emptyArray, 0), expect: [] },
  testHeadDefaultStr: { actual: utils.head(cases.strArray), expect: ['abc'] },
  testHeadThreeStr: { actual: utils.head(cases.strArray, 3), expect: ['abc', 'bca', 'cab'] },
  testHeadHeavy: { actual: utils.head(cases.kongArray), expect: [0] },
  testTailEmpty: { actual: utils.tail(cases.emptyArray, 0), expect: [] },
  testTailDefaultStr: { actual: utils.tail(cases.strArray), expect: ['bca', 'cab', 'cba', 'abc', 'bac'] },
  testTailThreeStr: { actual: utils.tail(cases.strArray, 3), expect: ['cba', 'abc', 'bac'] },
  testTailHeavy: { actual: utils.tail(cases.kongArray), expect: [i + 1 for i in std.range(0, 4095)] },

  // -- Arrays :: Edition tools
  testReverseEmpty: { actual: utils.reverse(cases.emptyArray), expect: [] },
  testReverseStr: { actual: utils.reverse(cases.strArray), expect: ['bac', 'abc', 'cba', 'cab', 'bca', 'abc'] },
  testReverseHeavy: { actual: utils.reverse(cases.kongArray), expect: [4096 - i for i in std.range(0, 4096)] },
  testUniqLeftEmpty: { actual: utils.uniql(cases.emptyArray), expect: [] },
  testUniqLeftStr: { actual: utils.uniql(cases.strArray), expect: ['abc', 'bca', 'cab', 'cba', 'bac'] },
  testUniqLeftHeavy: { actual: utils.uniql(cases.bigArray), expect: cases.bigArray },
  testUniqRightEmpty: { actual: utils.uniqr(cases.emptyArray), expect: [] },
  testUniqRightStr: { actual: utils.uniqr(cases.strArray), expect: ['bca', 'cab', 'cba', 'abc', 'bac'] },
  testUniqRightHeavy: { actual: utils.uniqr(cases.bigArray), expect: cases.bigArray },

  // -- Arrays :: Custom patching tools
  testPatchArrayEmpty: { actual: utils.patchArray(cases.emptyArray), expect: [] },
  testPatchArrayStr: { actual: utils.patchArray(cases.strArray + ['~cab', '~abc']), expect: ['bca', 'cba', 'bac'] },
  testPatchArrayHeavy: { actual: utils.patchArray(cases.kongArray + ['~cab', '~abc']), expect: cases.kongArray },

  // -- Arrays :: Convertion tools
  testToObjectArrayEmpty: { actual: utils.toObject(cases.emptyArray), expect: {} },
  testToObjectArrayStr: { actual: utils.toObject(cases.strArray), expect: { '000000': 'abc', '000001': 'bca', '000002': 'cab', '000003': 'cba', '000004': 'abc', '000005': 'bac' } },

  // ------ Objects tools
  // -- Objects :: State tools (immutable)
  testObjectHasSimple: { actual: utils.objectHas(cases.simpleObj, 'aaa'), expect: true },
  testObjectNotHasSimple1: { actual: utils.objectHas(cases.simpleObj, 'zzz'), expect: false },
  testObjectNotHasSimple2: { actual: utils.objectHas(cases.simpleObj, ['ccc', 'eee', 'fff']), expect: false },
  testObjectHasNested: { actual: utils.objectHas(cases.nestedObj, ['ccc', 'eee', 'fff']), expect: true },
  testObjectNotHasNested: { actual: utils.objectHas(cases.nestedObj, ['ccc', 'eee', 'ggg']), expect: false },

  // -- Objects :: Edition tools
  testDeepMergeSimple1: { actual: utils.deepMerge(cases.simpleObj, cases.nestedObj), expect: { aaa: true, bbb: ['zzz', 'xxx', 'yyy', 'www'], ccc: { ddd: true, eee: { fff: null }, ggg: [] }, hhh: {} } },
  testDeepMergeSimple2: { actual: utils.deepMerge(cases.nestedObj, cases.simpleObj), expect: { aaa: false, bbb: ['yyy', 'xxx', 'www', 'zzz'], ccc: '', hhh: {} } },
  testDeepMergeSimple3: { actual: utils.deepMerge(cases.nestedObj, cases.simpleObj, utils.uniqr), expect: { aaa: false, bbb: ['www', 'zzz', 'xxx', 'yyy'], ccc: '', hhh: {} } },
})
