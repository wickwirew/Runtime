#!/usr/bin/env python3
# coding=utf-8
import sys
import string
import glob


def build_provider_file():
    return


def build_provider_extension(class_name, functions):
    map = get_function_map(functions)
    return """
extension """ + class_name + """: XCTestCaseProvider {
    var allTests : [(String, () throws -> Void)] {
        return [""" + map + """
        ]
    }
}
    """


def get_function_map(functions):
    result = ""

    for func in functions:
        result += "\n            (\"" + func + "\", " + func + "),"

    return result


def get_function_name(words):
    for word in words:
        if word != "public" and word != "func" and word != "static" \
                and word != "private" and word != "open" and word != "fileprivate":
            return word.replace("()", "")

    return ""


def is_test_function(words):
    if not words.__contains__("func"):
        return False

    function_name = str(get_function_name(words))

    return function_name.__contains__("test")


def is_class_declaration(words):
    return words.__contains__("class") and words.__contains__("XCTestCase")


def get_class_name(words):
    for word in words:
        if word != "public" and word != "class" and word != "static" \
                and word != "private" and word != "open" and word != "fileprivate":
            return word.replace(":", "")

    return ""


def get_words(line):
    line_str = str(line).strip()
    words = line_str.split(' ', 10)

    while '' in words:
        words.remove('')

    return words


def generate_providers():
    test_path = "../RuntimeTests/*"
    output_file = "../RuntimeTests/TestProviders.swift"
    linux_main = "../RuntimeTests/LinuxMain.swift"

    extensions = []
    class_names = []

    files = glob.glob(test_path)

    for fle in files:
        with open(fle) as f:
            class_name_found = False
            class_name = ""
            functions = []

            if fle.title().lower().__contains__(".swift"):
                for line in f.readlines():
                    words = get_words(line)

                    if is_class_declaration(words) and not class_name_found:
                        class_name = get_class_name(words)
                        class_name_found = True
                        class_names.append(class_name)
                    elif is_test_function(words):
                        functions.append(get_function_name(words))

                extensions.append(build_provider_extension(class_name, functions))

    with open(output_file, "w") as f:
        f.write("// This file is generated. Please do not add to source control.\n")
        f.write("@testable import Runtime\n")
        f.write("import XCTest\n\n")

        for ext in extensions:
            f.write(ext)
            continue

    with open(linux_main, "w") as f:
        f.write("// This file is generated. Please do not add to source control.\n")
        f.write("@testable import Runtime\n")
        f.write("import XCTest\n\n")

        f.write("XCTMain([")
        for c in class_names:
            f.write(" \n   " + c + "(),")
            continue
        f.write("\n])")
             

if __name__ == '__main__':
    generate_providers()
