Query myQuery1;
MyLine myLine1;
MyLine myLine2;

// constants
float line1Length = 100; //<>//
float line2Length = 100; //<>//
float line1InitialAngle = PI/6;
float line2InitialAngle = PI/3;
float radius = line1Length + line2Length;

Boolean isDragging;
int dragX;
int dragY;
 
void setup()
{
  size(800, 500);
  smooth();
  //fullScreen();
  myLine1 = new MyLine(0,0,line1InitialAngle,line1Length); //<>//
  myLine2 = new MyLine(line1Length*cos(line1InitialAngle) + line2Length*cos(line2InitialAngle),line1Length*sin(line1InitialAngle) + line2Length*sin(line2InitialAngle),line2InitialAngle-PI,line2Length);
  //myLine1.theta = atan(  ( (height/5.0) -myLine1.y1 )   /    ( (width/2.0) -myLine1.x1 )      ); //<>//
  //myLine1.theta = atan(  ( myQuery1.qy -myLine1.y1 )   /    ( myQuery1.qx -myLine1.x1 )      ); //<>//
  //myLine2.theta = atan(  ( myQuery1.qy -myLine1.y1 )   /    ( myQuery1.qx -myLine1.x1 )      );
  myQuery1 = new Query(color(255,0,0),line1Length*cos(line1InitialAngle) + line2Length*cos(line2InitialAngle),line1Length*sin(line1InitialAngle) + line2Length*sin(line2InitialAngle),10,10);
}

void draw()
{
    myQuery1.display();
    myLine1.display();
    myLine2.display();
    stroke(230);
    noFill();
    ellipse(0,0,2*radius, 2*radius);
    ellipse(0,0,2*line1Length,2*line1Length);
}
 
class Query {
  color qc;
  float qx;
  float qy;
  int dQx;
  int dQy;
 
  Query(color tempQc, float tempQx, float tempQy,int tempdQx, int tempdQy) {
    qc = tempQc;
   qx = tempQx;
   qy = tempQy;
   dQx = tempdQx;
   dQy = tempdQy;
  }
 
  void display() {
    background(255);
    stroke(0);
    fill(qc);
    //rectMode(RADIUS);
    //rect(qx,qy,dQx,dQy);
    ellipse(qx,qy,20,20);
    //line(0,0,qx,qy);
    fill(qc);
  }
  boolean inQuery(int x, int y){
    //changed to x > qx-dQx and y > qy-dQy
    
    if((x > qx-dQx) & x < (qx+dQx)){
      if((y > qy-dQy)  & y < (qy+dQy)){
        
        return true;
      }
    }
    return false;
  }
}  

class MyLine {
  float x1; //co-ordinates for the starting point of the line
  float y1;
  float len; // the length of the line
  float theta; // describes the slope of the line. (Counted anti-clockwise starting from the positive X-axis.)
  
  MyLine(float X1, float Y1, float tempTheta, float tempLength) {
    x1 = X1;
    y1 = Y1;
    theta = tempTheta; // Multiply the theta with -1 since the y-axis of the co-ordinate system of processing is inverted.
    len = tempLength;
  }
  
  void display() {
    line(x1,y1,len*cos(theta)+x1,len*sin(theta)+y1);
  }
}

void mousePressed(){
  println("pressed");
  if (myQuery1.inQuery(mouseX, mouseY)){
    isDragging = true;
    dragX = (int)myQuery1.qx - mouseX;
    dragY = (int)myQuery1.qy - mouseY;
    
  }else{
    print("not in box");
    isDragging = false;
  }
}

void mouseReleased(){
  isDragging = false;
}

void mouseDragged(){
  //println("dragging");
  if(isDragging){
    myQuery1.qx = mouseX + dragX;
    myQuery1.qy = mouseY + dragY;
    float distance_query = sqrt(pow(myQuery1.qx,2) + pow(myQuery1.qy,2));
    myQuery1.qx = (distance_query > radius)?(radius * myQuery1.qx)/distance_query:myQuery1.qx;
    myQuery1.qy = (distance_query > radius)?(radius * myQuery1.qy)/distance_query:myQuery1.qy; // todo
    //float value_x = (radius * myQuery1.qx)/sqrt(1+ pow(myQuery1.qy,2));
    //float value_y = (radius * myQuery1.qy) / sqrt(1+ pow(myQuery1.qy,2));
    myLine1.x1 = 0; // not needed
    myLine1.y1 = 0; // not needed
    myLine1.theta = atan(  ( (mouseY+dragY) -myLine1.y1 )   /    ( (mouseX+dragX) -myLine1.x1 )      );
    float phi2 = getPhi2(line1Length, line2Length, myQuery1.qx, myQuery1.qy);
    float phi1 = getPhi1(line1Length, line2Length, phi2);
    //myLine2.theta = -PI - (PI/4) + getTheta2(phi2, myQuery1.qx, myQuery1.qy);  //This works with some accuracy.
    myLine2.theta = PI - PI/4 + getTheta2(phi2, myQuery1.qx, myQuery1.qy);
    myLine1.theta = (PI/4) +getTheta1(phi1, myQuery1.qx, myQuery1.qy);
    //myLine2.theta = PI/6;
    myLine2.x1 = myQuery1.qx;
    myLine2.y1 = myQuery1.qy;
    println("Theta1="+myLine1.theta*180/PI+" Theta2="+myLine2.theta*180/PI+" Phi1="+phi1*180/PI+" Phi2="+phi2*180/PI);
  }
}

float getPhi2(float A, float B, float x2, float y2) { //A is length of line1. B is length of line2. x2 and y2 are the co0ordinates of the tip of the arm.
  float R = sqrt(pow(x2,2) + pow(y2,2));
  //float phi1 = atan(y2/x2) + atan(y1/x1);
  //float k1 = pow(A,2)*B*R*tan(phi1);
  //float k2 = pow(A,2)*tan(phi1);
  //float a = pow(k2,2) + pow(B,4);
  //float b = -2 * k1 * pow(B,2);
  //float c = pow(k1,2) - pow(k2,2);
  //float phi2_plus = asin(     (-b+sqrt(pow(b,2)-4*a*c)) / (2*a)    );
  //float phi2_minus = asin(     (-b-sqrt(pow(b,2)-4*a*c)) / (2*a)    );
  //float theta2_plus = phi2_plus + atan(y2/x2);
  //float theta2_minus = phi2_minus + atan(y2/x2);
  
  float phi2 = acos(  (pow(R,2) - pow(B,2) - pow(A,2) ) /  (2*R*B)  );
  //float theta2 = phi2 + atan(y2/x2);
  
  
  return phi2;
}

float getTheta2(float phi2, float x2, float y2) {
  float theta2 = phi2 + atan(y2/x2);
  return theta2;
}

float getPhi1(float A, float B, float phi2) {
  float phi1;
  if(phi2*180/PI<90) {
    phi1 = asin(B*sin(phi2)/A);
  }
  else {
    phi1 = asin(B*sin(phi2)/A);
    phi1 = PI-phi1;
  }
  return phi1;
}

float getTheta1(float phi1, float x2, float y2) {
  float theta1 = atan(y2/x2) - phi1;
  return theta1;
}