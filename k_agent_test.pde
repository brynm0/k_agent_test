import processing.dxf.*;

import peasy.*;
import peasy.org.apache.commons.math.*;
import peasy.org.apache.commons.math.geometry.*;

boolean record;
PeasyCam  camera;
K_Agent[] agentArray;
int agentNumber;
PointAgent p;
int zLimit;

void setup () {

  record = false;
  agentNumber = 50;
  zLimit = 50;

  size(1000, 1000, P3D);

  camera = new PeasyCam(this, 500);

  agentArray = new K_Agent[agentNumber];
  for (int i = 0; i < agentArray.length; i++) {
    float offset = random(10, 50);
    float randx = random(width);
    float randy = random(height);
    float randz = random(zLimit);
    PVector origin = new PVector(randx, randy, randz);
    K_Agent agent = new K_Agent(origin, offset);
    agentArray[i] = agent;
  }
  //p = new PointAgent(position);
}

void draw () {
  if (record) {
    beginRaw(DXF, "output.dxf");
  }
  background(51);
  for (K_Agent agent : agentArray) {

    agent.update(agentArray);
  }
  if (record) {
   endRaw();
   record = false;
  }
}

void keyPressed() {
  if (key == ' ') {
    for (K_Agent a : agentArray) {
      a.freezeToggle();
    }
  }
  if (key == 'r') {
    record = true;
  }
}