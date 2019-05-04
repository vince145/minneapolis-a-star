// Matthew Vincent vince145@umn.edu
// Using A* to traverse roadnetwork of minneapolis
// by using different heuristics
//
//
// A* algorithm pseucode code implemented from
// https://en.wikipedia.org/wiki/A*_search_algorithm
//
//
//

String[] edgeStrings;
Environment roadmap = new Environment();
float roadmapScale = 0.10;
int n1;
int n2;
int counter = 100;
ArrayList<Node> savedNodes = new ArrayList<Node>();

void setup() {
  size(600, 800, P3D);
  fill(0);
  String[] lines = loadStrings("map.txt");
  edgeStrings = lines;
  roadmap.createEdges();
  
}


void draw() {
  lights();
  background(255);
  
  if (counter >= 25) {
    if (n1 == n2) {
      n2++;
    }
    if (n2 == roadmap.getNodes().size()) {
      n2 = 0;
      n1++;
    }
    if (n1 == roadmap.getNodes().size()) {
      n1 = 0;
    }

    perform_a_Star(n1,n2);
    n2++;
    counter = 0;
  } else {
    counter++;
  }
  
  roadmap.drawEnvironment();
  
}

int perform_a_Star(int start, int goal) {
  ArrayList<Edge> edges = roadmap.getEdges();
  ArrayList<Node> nodes = roadmap.getNodes();
  ArrayList<Node> shortestPath = a_Star(nodes, edges, start, goal);
  for (int i = 0; i < savedNodes.size(); i++) {
    savedNodes.get(i).setType(0);
    savedNodes.remove(i);
    i--;
  }
  if (shortestPath != null) {
    for (int i = 0; i < shortestPath.size(); i++) {
      savedNodes.add(shortestPath.get(i));
      shortestPath.get(i).setType(3);
      //println(shortestPath.get(i).getIndex());
    }
    shortestPath.get(0).setType(1);
    shortestPath.get(shortestPath.size()-1).setType(2);
    return 0;
  } else {
    savedNodes.add(nodes.get(start));
    savedNodes.add(nodes.get(goal));
    nodes.get(start).setType(2);
    nodes.get(goal).setType(1);
    return 1;
  }
}

class Node {
  int type;
  int index;
  float x;
  float y;
  Node prev;
  
  Node(float startX, float startY, int startType) {
    type = startType;
    x = startX;
    y = startY;
    index = -1;
  }
  
  void setType(int newType) {
    type = newType;
  }
  
  void setIndex(int newIndex) {
    index = newIndex;
  }
  
  int getType() {
    return type;
  }
  
  float getX() {
    return x;
  }
  
  float getY() {
    return y;
  }
  
  int getIndex() {
    return index;
  }
  void setPrev(Node newPrev) {
    prev = newPrev;
  }
  Node getPrev() {
    return prev;
  }
  boolean compare(Node A) {
    if (A == null) {
      return false;
    }
    if (this.x == A.getX() && this.y == A.getY()) {
      return true;
    } else {
      return false;
    }
  }
}

class Edge {
  Node A;
  Node B;
  float cost;
  int direction;
  
  Edge(Node startA, Node startB, float startCost, int startDirection) {
    A = startA;
    B = startB;
    cost = startCost;
    direction = startDirection;
  }
  
  Node getA() {
    return A;
  }
  
  Node getB() {
    return B;
  }
  
  float getCost() {
    return cost;
  }
  
  int getDirection() {
    return direction;
  }
}

class Environment {
  ArrayList<Edge> edges = new ArrayList<Edge>();
  ArrayList<Node> nodes = new ArrayList<Node>();
  float centerX;
  float centerY;
  
  Environment() {
    centerX = width/2;
    centerY = height/2;
  }
  
  ArrayList<Edge> getEdges() {
    return edges;
  }
  
  ArrayList<Node> getNodes() {
    return nodes;
  }
  
  void createEdges() {
    float minX = 9999999;
    float maxX = -9999999;
    float minY = 9999999;
    float maxY = -9999999;
    println("there are " + edgeStrings.length + " lines");
    for (int i = 0; i < edgeStrings.length; i++) {
      String[] splitLine = split(edgeStrings[i], " ");
      int edgeDirection = Integer.parseInt(str(splitLine[0].charAt(1)));
      float x1 = float(splitLine[1]);
      float y1 = float(splitLine[2]);
      float x2 = float(splitLine[3]);
      float y2 = float(splitLine[4]);
      float cost = sqrt(pow((x2 - x1),2) + pow((y2 - y1),2));
      Node nodeA = new Node(x1,y1,0);
      Node nodeB = new Node(x2,y2,0);
      boolean addNodeA = true;
      boolean addNodeB = true;
      int nodeAIndex = -1;
      int nodeBIndex = -1;
      for (int j = 0; j < nodes.size(); j++) {
        if (nodes.get(j).compare(nodeA)) {
          addNodeA = false;
          nodeAIndex = j;
        }
        if (nodes.get(j).compare(nodeB)) {
          addNodeB = false;
          nodeBIndex = j;
        }
      }
      if (addNodeA) {
        nodeAIndex = nodes.size();
        nodeA.setIndex(nodeAIndex);
        nodes.add(nodeA);
        
      }
      if (addNodeB) {
        nodeBIndex = nodes.size();
        nodeB.setIndex(nodeBIndex);
        nodes.add(nodeB);
      }
      //println(edgeStrings[i] + " " + edgeDirection + " " + x1 + " " + y1 + " " + x2 + " " + y2);
      edges.add(new Edge(nodes.get(nodeAIndex), nodes.get(nodeBIndex), cost, edgeDirection));
      if (x1 < minX) {
        minX = x1;
      }
      if (x2 < minX) {
        minX = x2;
      }
      if (x1 > maxX) {
        maxX = x1;
      }
      if (x2 > maxX) {
        maxX = x2;
      }
      if (y1 < minY) {
        minY = y1;
      }
      if (y2 < minY) {
        minX = y2;
      }
      if (y1 > maxY) {
        maxY = y1;
      }
      if (y2 > maxY) {
        maxY = y2;
      }

    }
    //println("xBounds = (" + minX + ", " + maxX + ") yBounds = (" + minY + ", " + maxY + ")");
    centerY = height/2;
    centerX = (maxX - minX)*0.5*roadmapScale - width/2;
    //println("Roadmap Center = (" + centerX + ", " + centerY + ")");
    println("Nodes size = " + nodes.size());
    println("Edges size = " + edges.size());
  }
  
  void drawEnvironment() {
    
    strokeWeight(1.4);
    // Draws roadmap
    pushMatrix();
    stroke(0, 95);
    for (int i = 0; i < edges.size(); i++) {
      pushMatrix();
      if (edges.get(i).getA().getType() > 0 &&
          edges.get(i).getB().getType() > 0) {
        stroke(255, 0, 0);
      } else {
        stroke(0, 95);
      }

      line ((edges.get(i).getA().getX()*roadmapScale)-centerX, edges.get(i).getA().getY()*roadmapScale-centerY,
            edges.get(i).getB().getX()*roadmapScale-centerX, edges.get(i).getB().getY()*roadmapScale-centerY);
            
      translate(0,0,5);
      if (edges.get(i).getA().getType() == 2) {
        pushMatrix();
        stroke(0,255,0);
        translate((edges.get(i).getA().getX()*roadmapScale)-centerX, edges.get(i).getA().getY()*roadmapScale-centerY, 2);
        sphere(3.5);
        popMatrix();
      } else if (edges.get(i).getA().getType() == 1) {
        pushMatrix();
        stroke(0,0,255);
        translate((edges.get(i).getA().getX()*roadmapScale)-centerX, edges.get(i).getA().getY()*roadmapScale-centerY, 2);
        sphere(3.5);
        popMatrix();
      }
      if (edges.get(i).getB().getType() == 2) {
        pushMatrix();
        stroke(0,255,0);
        translate((edges.get(i).getB().getX()*roadmapScale)-centerX, edges.get(i).getB().getY()*roadmapScale-centerY, 2);
        sphere(3.5);
        popMatrix();
      } else if (edges.get(i).getB().getType() == 1) {
        pushMatrix();
        stroke(0,0,255);
        translate((edges.get(i).getB().getX()*roadmapScale)-centerX, edges.get(i).getB().getY()*roadmapScale-centerY, 2);
        sphere(3.5);
        popMatrix();
      }
      popMatrix();
    }
    popMatrix();
  }
}

float heuristic_cost_estimate(int type, Node A, Node B) {
  if (type == 0) {
    return (sqrt(pow(B.getX()-A.getX(),2) + pow(B.getY()-A.getY(),2)));
  } else if (type == 1) {
    return (abs((B.getX() - A.getX())) + abs((B.getY() - A.getY())));
  } else if (type == 2) {
    return (abs((B.getX() - A.getX())) + abs((B.getY() - A.getY())))*2;
  } else if (type == 3) {
    return (abs((B.getX() - A.getX())) + abs((B.getY() - A.getY())))*4;
  } else if (type == 4) {
    return (abs((B.getX() - A.getX())) + abs((B.getY() - A.getY())))+100;
  }
  return 0;
}

ArrayList<Node> a_Star(ArrayList<Node> nodes, ArrayList<Edge> edges, int start, int goal) {
  //println("CHECKPOINT 1");
  // Set of nodes already evaluated
  ArrayList<Integer> closedSet = new ArrayList<Integer>();
  
  // Set of currently discored nodes that are not evaluated yet
  ArrayList<Integer> openSet = new ArrayList<Integer>();
  openSet.add(start);
  
  // For each node, which node it can most efficiently be reached from
  Node cameFrom[] = new Node[nodes.size()];
  
  // For each node, the cost of getting from the start node to that node.
  float gScore[] = new float[nodes.size()];
  
  // For each node, the total cost of getting frm the start node to the goal
  // by passing by that node. That value is partly known, partly heuristic
  float fScore[] = new float[nodes.size()];
  
  //println("CHECKPOINT 2");
  for (int i = 0; i < nodes.size(); i++) {
    if (!nodes.get(i).compare(nodes.get(start))) {
      gScore[i] = 999999;
      fScore[i] = 999999;
    } else if (nodes.get(i).compare(nodes.get(start))) {
      gScore[i] = 0;
      fScore[i] = heuristic_cost_estimate(1, nodes.get(i), nodes.get(goal)); // add heuristic
    }
  }
  
  //println("CHECKPOINT 3");
  while (openSet.size() > 0) {
    
    int currentIndex = openSet.get(0);
    int openSetIndex = 0;
    for (int i = 1; i < openSet.size(); i++) {
      if (fScore[openSet.get(i)] < fScore[currentIndex]) {
        currentIndex = openSet.get(i);
        openSetIndex = i;
      }
    }
    /*
    println("CHECKPOINT 4: " + "currentIndex : " + currentIndex + ", openSetSize: " + openSet.size() + ", closedSetSize: " + closedSet.size());
    if (nodes.get(currentIndex).getPrev() != null) {
      println("CHECKPOINT 4: " + "currentIndex : " + currentIndex + ", prev : " + nodes.get(currentIndex).getPrev().getIndex());
    }
    */
    if (currentIndex == goal) {
      ArrayList<Node> total_path = new ArrayList<Node>();
      Node finalPathNode = nodes.get(currentIndex);
      while(finalPathNode != null) {
        /*
        if (cameFrom[finalPathNode.getIndex()] != null) {
          println("finalPathNodeIndex: " + finalPathNode.getIndex() + ", cameFromIndex: " + cameFrom[finalPathNode.getIndex()].getIndex());
        } else {
          println("finalPathNodeIndex: " + finalPathNode.getIndex());
        }
        */
        total_path.add(finalPathNode);
        finalPathNode = finalPathNode.getPrev();
      }
      println("startIndex: " + start + ", goalIndex: " + goal + ", f: " + fScore[goal] + ", PathSize: " + total_path.size());
      return total_path; // return path
    }
    
    openSet.remove(openSetIndex);
    closedSet.add(currentIndex);
    
    // for each neighbor of current
    for (int i = 0; i < edges.size(); i++) {
      // If node A is current
      if (edges.get(i).getA().compare(nodes.get(currentIndex))) {
        //println("DIR 1: " + "EDGE A: " + edges.get(i).getA().getIndex() + ", EDGE B: " + edges.get(i).getB().getIndex());
        boolean nodeNotClosed = true;
        for (int j = 0; j < closedSet.size(); j++) {
          if (closedSet.get(j) == edges.get(i).getB().getIndex()) {
            nodeNotClosed = false;
            //println("Node : " + closedSet.get(j) + " CLOSED");
          }
        }
        if (nodeNotClosed) {
          float tentative_gScore = gScore[currentIndex] + edges.get(i).getCost();
          
          boolean nodeNotOpened = true;
          for (int j = 0; j < openSet.size(); j++) {
            if (openSet.get(j) == edges.get(i).getB().getIndex()) {
              nodeNotOpened = false;
              //println("NODE OPENED ALREADY");
            }
          }
          if (nodeNotOpened) {
            openSet.add(edges.get(i).getB().getIndex());
          } 
          if (tentative_gScore >= gScore[edges.get(i).getB().getIndex()]) {
            
          } else {
            cameFrom[edges.get(i).getB().getIndex()] = edges.get(i).getA();
            edges.get(i).getB().setPrev(edges.get(i).getA());
            gScore[edges.get(i).getB().getIndex()] = tentative_gScore;
            fScore[edges.get(i).getB().getIndex()] = gScore[edges.get(i).getB().getIndex()] + heuristic_cost_estimate(1, edges.get(i).getB(), nodes.get(goal)); // heuristic
          }
        }
      
      
      // If node B is current
      } else if (edges.get(i).getB().compare(nodes.get(currentIndex))) {
        if (edges.get(i).getDirection() == 2) {
          //println("DIR 2");
          boolean nodeNotClosed = true;
          for (int j = 0; j < closedSet.size(); j++) {
            if (closedSet.get(j) == edges.get(i).getA().getIndex()) {
              nodeNotClosed = false;
            }
          }
          if (nodeNotClosed) {
            float tentative_gScore = gScore[currentIndex] + edges.get(i).getCost();
            
            boolean nodeNotOpened = true;
            for (int j = 0; j < openSet.size(); j++) {
              if (openSet.get(j) == edges.get(i).getA().getIndex()) {
                nodeNotOpened = false;
              }
            }
            if (nodeNotOpened) {
              openSet.add(edges.get(i).getA().getIndex());
            }
            if (tentative_gScore >= gScore[edges.get(i).getA().getIndex()]) {
              
            } else {
              cameFrom[edges.get(i).getA().getIndex()] = edges.get(i).getB();
              edges.get(i).getA().setPrev(edges.get(i).getB());
              gScore[edges.get(i).getA().getIndex()] = tentative_gScore;
              fScore[edges.get(i).getA().getIndex()] = gScore[edges.get(i).getA().getIndex()] + heuristic_cost_estimate(1, edges.get(i).getA(), nodes.get(goal)); // heuristic
            }
          }
        }
      }
    }
  }
  println("startIndex: " + start + ", goalIndex: " + goal + ", NULL");
  return null;
  
  
}
