class K_Agent {
  PointAgent[] arms;
  float sightRange;
  PVector origin;
  boolean moves;
  float armAngle;
  PVector midPoint;
  float offSet;

  K_Agent(PVector _origin, float _offSet) {
    origin = _origin;
    armAngle = radians(60);
    offSet = _offSet;
    init();
  }
  void init() {
    arms = new PointAgent[4];
    arms[0] = new PointAgent(origin.x + offSet, origin.y + 1.5 * offSet);
    arms[1] = new PointAgent(origin.x - offSet, origin.y + 1.5 * offSet);
    arms[2] = new PointAgent(origin.x - offSet, origin.y - 1.5 * offSet);
    arms[3] = new PointAgent(origin.x + offSet, origin.y - 1.5 * offSet);
  }
  void display() {
      calculateMidPoint();
    for (PointAgent a : arms) {
      line( a.position.x, a.position.y, midPoint.x, midPoint.y);
    }
  }
  void calculateMidPoint () {
    float xAvg = 0;
    float yAvg = 0;
    for (int i = 0; i < arms.length; i++) {
      xAvg = xAvg + arms[i].position.x;
      yAvg = yAvg + arms[i].position.y;
    }
    xAvg = xAvg / arms.length;
    yAvg = yAvg / arms.length;
    midPoint = new PVector(xAvg, yAvg);
  }
   void move() {
    for (PointAgent b : arms) {
     b.move(origin, offSet); 
    }
   }
}