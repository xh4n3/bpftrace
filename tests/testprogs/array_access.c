struct A
{
  int x[4];
};

struct B
{
  int y[2][2];
};

void test_array(int *a __attribute__((unused)))
{
}

void test_arrays(struct A *a __attribute__((unused)),
                 struct A *c __attribute__((unused)))
{
}

void test_struct(struct A *a __attribute__((unused)),
                 struct B *b __attribute__((unused)))
{
}

int main(int argc __attribute__((unused)), char ** argv __attribute__((unused)))
{
  struct A a;
  a.x[0] = 1;
  a.x[1] = 2;
  a.x[2] = 3;
  a.x[3] = 4;

  struct A c;
  c.x[0] = 4;
  c.x[1] = 3;
  c.x[2] = 2;
  c.x[3] = 1;

  struct B b;
  b.y[0][0] = 5;
  b.y[0][1] = 6;
  b.y[1][0] = 7;
  b.y[1][1] = 8;
  test_struct(&a, &b);
  test_array(a.x);
  test_arrays(&a, &c);
}
