import java.util.*;
import java.util.function.*;

class Point {
  double x;
  double y;
  Point (double x, double y) {this.x = x; this.y = y;}

  double distance(Point other) {
    double delta_x = this.x - other.x;
    double delta_y = this.y - other.y;
    return Math.sqrt(delta_x * delta_x + delta_y * delta_y);
  }
}


class PSet {
  Predicate<Point> ps;    // representation of a point set
  private PSet(Predicate<Point> ps) {this.ps = ps;}

  boolean in(Point p) {
    return ps.test(p);
  }

  static PSet disk(Point center, double radius) {
    return new PSet(point -> center.distance(point) <= radius);
  }

  PSet intersect(PSet set) {
    return new PSet(point -> ps.test(point) && set.ps.test(point));
  }

  static PSet rect(Point corner1, Point corner2) {
    if(corner1.x > corner2.x && corner1.y < corner2.y)//point one bottom right
    {
      return new PSet(point -> point.x <= corner1.x && point.y >= corner1.y && point.x >=corner2.x && point.y <=corner2.y);
    }
    else if(corner1.x > corner2.x && corner1.y > corner2.y)//point one top right
    {
      return new PSet(point -> point.x <= corner1.x && point.y <= corner1.y && point.x >= corner2.x && point.y >= corner2.y);
    }
    else if(corner1.x < corner2.x && corner1.y < corner2.y)//point one bottom left
    {
      return new PSet(point -> point.x >= corner1.x && point.y >= corner1.y && point.x <= corner2.x && point.y <= corner2.y);
    }
    else//point one top left
    {
      return new PSet(point -> point.x >= corner1.x && point.y <= corner1.y && point.x <= corner2.x && point.y >= corner2.y);
    }
  }

  PSet union(PSet set) {
    return new PSet(point -> this.in(point) || set.in(point));
  }

  PSet complement() {
    return new PSet(point-> !this.in(point));
  }

  PSet reflectx() {
    return new PSet(point -> this.in(new Point(point.x,point.y *-1)));
  }
}


class Example {
  public static void main(String argv[]) {
    double x = Double.parseDouble(argv[0]);
    double y = Double.parseDouble(argv[1]);
    Point p = new Point(x,y);
    PSet myregion = PSet.disk(new Point(0,0),2).intersect(PSet.disk(new Point(0,2),2));
    System.out.println(myregion.in(p));

    //Lines I added:
    //PSet rectTest = PSet.rect(new Point(10,2),new Point(1,5));
    //PSet toUnion = PSet.rect(new Point(-1,-3),new Point(2,3));
    //System.out.println(rectTest.in(p));
    //PSet unionTest = rectTest.union(toUnion);
    //System.out.println(unionTest.in(p));
    //PSet compTest = rectTest.complement();
    //System.out.println(compTest.in(p));
    //PSet reflectTest = rectTest.reflectx();
    //System.out.println(reflectTest.in(p));
  }
}
