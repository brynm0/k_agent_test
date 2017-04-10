import processing.dxf.*;

import peasy.*;
import peasy.org.apache.commons.math.*;
import peasy.org.apache.commons.math.geometry.*;

boolean record;
PeasyCam  camera;

//use arraylist if getting from csv
K_Agent[] agentArray;
ArrayList<PVector> pointData;
float x, y, z;
Table points;


int agentNumber;
PointAgent p;
int zLimit;



void setup () {

  record = false;
  //agentNumber = 50;
  zLimit = 50;

  size(1000, 1000, P3D);

  camera = new PeasyCam(this, 500);
  points = loadTable("pointInfo.csv", "header");

  pointData = new ArrayList<PVector>();
  for (int i = 0; i < points.getRowCount(); i++) {
    TableRow row = points.getRow(i);
    x = row.getFloat("x");
    y = row.getFloat("y");
    z = row.getFloat("z");
    PVector tempVector = new PVector(x, y, z);
    pointData.add(tempVector);
  }
  agentNumber = pointData.size();
  agentArray = new K_Agent[agentNumber];



  for (int i = 0; i < agentArray.length; i++) {
    float offset = random(1, 5);
    //float randx = random(width);
    //float randy = random(height);
    //float randz = random(zLimit);
    PVector origin = new PVector();
    origin = pointData.get(i);
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