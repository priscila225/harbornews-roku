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

    ' article model and configuration
    cfg = ConfigManager_relatedCountFromJson("{""relatedCount"": 3}")
    expectEqual("related count is read from the config", cfg, 3)
    withImage = ArticleDetailModel_fromJson({ title: "Harbor reopens", body: "Ferries run", images: [{ url: "https://img.example/1.jpg" }] })
    expectEqual("title is kept", withImage.title, "Harbor reopens")
    expectEqual("hero url comes from the first image", withImage.heroUrl, "https://img.example/1.jpg")
    expectEqual("pickHeroImage returns the first image", ArticleDetailModel_pickHeroImage([{ url: "a" }, { url: "b" }]).url, "a")
    notAnArticle = ArticleDetailModel_fromJson(invalid)
    expectEqual("a missing payload gives an empty title", notAnArticle.title, "")
    expectEqual("a missing payload gives an empty hero url", notAnArticle.heroUrl, "")

    print "checks=" + m.checks.toStr() + " failures=" + m.failures.toStr()
end sub

sub expectEqual(name as string, actual as dynamic, expected as dynamic)
    m.checks = m.checks + 1
    if actual <> expected
        m.failures = m.failures + 1
        print "FAIL " + name
    end if
end sub
