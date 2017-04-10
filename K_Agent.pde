class K_Agent {
  PointAgent[] arms;
  float sightRange;
  PVector origin;
  boolean moves;
  float armAngle;
  PVector midPoint;
  float offSet;

  K_Agent(PVector _origin, float _offSet) {
    midPoint = _origin;
    origin = _origin;
    armAngle = radians(60);
    offSet = _offSet;
    moves = false;
    init();
  }
  void init() {
    arms = new PointAgent[4];
    arms[0] = new PointAgent(origin.x + offSet, origin.y + 1.5 * offSet, origin.z);
    arms[1] = new PointAgent(origin.x - offSet, origin.y + 1.5 * offSet, origin.z);
    arms[2] = new PointAgent(origin.x - offSet, origin.y - 1.5 * offSet, origin.z);
    arms[3] = new PointAgent(origin.x + offSet, origin.y - 1.5 * offSet, origin.z);
  }
  void display() {
    calculateMidPoint();
    for (PointAgent a : arms) {
      line( a.position.x, a.position.y, a.position.z, midPoint.x, midPoint.y, midPoint.z);
    }
  }
  void calculateMidPoint () {
    PVector result = new PVector(0, 0, 0);
    int count = 0;
    for ( PointAgent agent : arms ) {
      result = result.add(agent.position);
      count++;
    }
    result.mult(1.0f / count);
    midPoint = result;
  } 

  void freezeToggle() {
    for (PointAgent p : arms) {
      if (p.moves == true) { 
        p.moves = false;
      } else if (p.moves == false) {
        p.moves = true;
      }
    }
  }

  void update(K_Agent[] agents) {
    calculateMidPoint();
    for (PointAgent b : arms) {
      b.expansion(midPoint, offSet); 
      //   b.seek(a);
      b.cohesion(agents);

      b.update();
    }
    display();
  }
}