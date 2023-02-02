#include "common.h"

namespace bpftrace {
namespace test {
namespace codegen {

TEST(codegen, call_system_ringbuf)
{
  auto bpftrace = get_mock_bpftrace();
  if (!bpftrace->has_map_ringbuf())
  {
    return;
  }

  test(" kprobe:f { system(\"echo %d\", 100) }",

       NAME,
       false);
}

} // namespace codegen
} // namespace test
} // namespace bpftrace
