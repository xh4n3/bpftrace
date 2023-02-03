#include "common.h"

namespace bpftrace {
namespace test {
namespace codegen {

TEST(codegen, array_integer_equal_comparison)
{
  std::vector<std::string> variations;

  auto bpftrace = get_mock_bpftrace();
  if (bpftrace->has_loop())
  {
    variations.push_back("no_unroll");
  }

  test("struct Foo { int arr[4]; }"
       "kprobe:f"
       "{"
       "  $a = ((struct Foo *)arg0)->arr;"
       "  $b = ((struct Foo *)arg0)->arr;"
       "  if ($a == $b)"
       "  {"
       "    exit();"
       "  }"
       "}",

       NAME,
       variations);
}

} // namespace codegen
} // namespace test
} // namespace bpftrace
