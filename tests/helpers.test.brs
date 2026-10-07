' Plain-BrightScript tests for the pure helpers. Run with: npm test
' Each failed expectation prints a line starting with FAIL.

sub main()
    m.failures = 0
    m.checks = 0

    expectEqual("isString on string", isString("a"), true)
    expectEqual("isString on number", isString(1), false)
    expectEqual("isString on invalid", isString(invalid), false)
    expectEqual("isNumber on integer", isNumber(3), true)
    expectEqual("isNumber on float", isNumber(3.5), true)
    expectEqual("isNumber on string", isNumber("3"), false)
    expectEqual("isArray on array", isArray([1]), true)
    expectEqual("isArray on assoc", isArray({}), false)
    expectEqual("isAssocArray on assoc", isAssocArray({ a: 1 }), true)
    expectEqual("isAssocArray on invalid", isAssocArray(invalid), false)
    expectEqual("stringOrDefault keeps strings", stringOrDefault("x", "d"), "x")
    expectEqual("stringOrDefault falls back for invalid", stringOrDefault(invalid, "d"), "d")
    expectEqual("stringOrDefault falls back for numbers", stringOrDefault(5, "d"), "d")

    ' relative time
    expectEqual("a fresh story is just now", RelativeTime_format(1000, 1030), "just now")
    expectEqual("exactly one minute", RelativeTime_format(1000, 1060), "1 min ago")
    expectEqual("minutes round down", RelativeTime_format(1000, 1000 + 59 * 60 + 59), "59 min ago")
    expectEqual("exactly one hour", RelativeTime_format(1000, 1000 + 3600), "1 h ago")
    expectEqual("hours round down", RelativeTime_format(1000, 1000 + 23 * 3600 + 3599), "23 h ago")
    expectEqual("exactly one day", RelativeTime_format(1000, 1000 + 86400), "1 d ago")
    expectEqual("a future timestamp counts as just now", RelativeTime_format(2000, 1000), "just now")
    expectEqual("a missing timestamp gives no text", RelativeTime_format(0, 1000), "")
    expectEqual("millis become seconds", RelativeTime_secondsFromMillis(1700000000000), 1700000000)
    expectEqual("a non-number becomes zero", RelativeTime_secondsFromMillis("x"), 0)
    expectEqual("invalid becomes zero", RelativeTime_secondsFromMillis(invalid), 0)

    print "checks=" + m.checks.toStr() + " failures=" + m.failures.toStr()
end sub

sub expectEqual(name as string, actual as dynamic, expected as dynamic)
    m.checks = m.checks + 1
    if actual <> expected
        m.failures = m.failures + 1
        print "FAIL " + name
    end if
end sub
