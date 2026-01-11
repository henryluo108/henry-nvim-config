-- Python snippets for LuaSnip
local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local fmt = require("luasnip.extras.fmt").fmt

-- Define snippets
local snippets = {
  -- Main function
  s("main", fmt(
    [[
def main():
    {}

if __name__ == "__main__":
    main()
    ]],
    { i(1, "pass") }
  )),

  -- Class
  s("cl", fmt(
    [[
class {}:
    """{}"""

    def __init__(self):
        {}
    ]],
    { i(1, "ClassName"), i(2, "Class description"), i(0, "pass") }
  )),

  -- Function
  s("func", fmt(
    [[
def {}({}):
    """{}"""
    {}
    return {}
    ]],
    { i(1, "function_name"), i(2, "params"), i(3, "docstring"), i(4, ""), i(0, "result") }
  )),

  -- If main
  s("ifm", fmt(
    [[
if __name__ == "__main__":
    {}
    ]],
    { i(0, "main()") }
  )),

  -- For loop
  s("for", fmt(
    [[
for {} in {}:
    {}
    ]],
    { i(1, "item"), i(2, "iterable"), i(0, "pass") }
  )),

  -- For enumerate
  s("fore", fmt(
    [[
for {} in enumerate({}):
    {}
    ]],
    { i(1, "idx, item"), i(2, "iterable"), i(0, "pass") }
  )),

  -- While loop
  s("while", fmt(
    [[
while {}:
    {}
    ]],
    { i(1, "condition"), i(0, "pass") }
  )),

  -- If statement
  s("if", fmt(
    [[
if {}:
    {}
    ]],
    { i(1, "condition"), i(0, "pass") }
  )),

  -- If-else
  s("ife", fmt(
    [[
if {}:
    {}
else:
    {}
    ]],
    { i(1, "condition"), i(2, "pass"), i(0, "pass") }
  )),

  -- If-elif-else
  s("ifel", fmt(
    [[
if {}:
    {}
elif {}:
    {}
else:
    {}
    ]],
    { i(1, "condition"), i(2, "pass"), i(3, "condition"), i(4, "pass"), i(0, "pass") }
  )),

  -- Try-except
  s("try", fmt(
    [[
try:
    {}
except Exception as e:
    raise
    ]],
    { i(0, "pass") }
  )),

  -- Try-except with custom exception
  s("trye", fmt(
    [[
try:
    {}
except {} as e:
    {}
    ]],
    { i(1, "pass"), i(2, "Exception"), i(0, "raise") }
  )),

  -- With statement
  s("with", fmt(
    [[
with {} as {}:
    {}
    ]],
    { i(1, "context_manager"), i(2, "f"), i(0, "pass") }
  )),

  -- Import
  s("imp", fmt(
    [[import {}]],
    { i(0, "module") }
  )),

  -- From import
  s("from", fmt(
    [[from {} import {}]],
    { i(1, "module"), i(0, "name") }
  )),

  -- Logging
  s("log", fmt(
    [[
import logging

logger = logging.getLogger(__name__)
    ]],
    {}
  )),

  -- Decorator
  s("deco", fmt(
    [[
def {}(func):
    """{}"""
    def wrapper(*args, **kwargs):
        {}
        return func(*args, **kwargs)
    return wrapper
    ]],
    { i(1, "decorator_name"), i(2, "Decorator description"), i(3, "# Do something before") }
  )),

  -- Decorated function
  s("decos", fmt(
    [[
@{}
def {}({}):
    """{}"""
    {}
    return {}
    ]],
    { i(1, "decorator"), i(2, "function_name"), i(3, "params"), i(4, "docstring"), i(5, ""), i(0, "result") }
  )),

  -- Typing import
  s("type", fmt(
    [[
from typing import {}

    ]],
    { i(0, "List, Dict, Optional") }
  )),

  -- Typed variable
  s("tvar", fmt(
    [[{}: {} = {}]],
    { i(1, "variable"), i(2, "type"), i(0, "value") }
  )),

  -- Typed function
  s("tfun", fmt(
    [[
def {}({}) -> {}:
    """{}"""
    {}
    return {}
    ]],
    { i(1, "function_name"), i(2, "params"), i(3, "return_type"), i(4, "docstring"), i(5, ""), i(0, "result") }
  )),

  -- leetcode template
  s("leetcode", fmt(
    [[
import bisect
import heapq
from collections import defaultdict, deque
from functools import lru_cache
from typing import Dict, List, Optional
    ]],
    {}
  )),
}



return snippets
