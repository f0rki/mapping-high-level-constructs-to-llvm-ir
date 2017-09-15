#include <cstdio>

struct Point {
    double x;
    double y;
    double z;
};


Point make_point() {
  Point p;
  p.x = 0;
  p.y = 0;
  p.z = 0;
  return p;
}


Point add_points(Point a, Point b) {
  Point p;
  p.x = a.x + b.x;
  p.y = a.y + b.y;
  p.z = a.z + b.z;
  return p;
}

int main() {
  Point a = {1.0, 3.0, 4.0};
  Point b = {2.0, 8.0, 5.0};
  Point c = add_points(a, b);
  printf("%f - %f\n", c.x, c.y);
  return 0;
}
