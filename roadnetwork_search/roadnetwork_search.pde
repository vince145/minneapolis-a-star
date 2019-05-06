// Matthew Vincent vince145@umn.edu
// Using A* to traverse roadnetwork of minneapolis
// by using different heuristics
//
//
// A* algorithm pseucode code implemented from
// https://en.wikipedia.org/wiki/A*_search_algorithm
//
//
// 701 749
// 776
// 786
// 850
// 875
// 886
// 900
// 932
// 12
// 64
// 149
// 174
// 214

String[] edgeStrings;
ArrayList<String> outputStrings = new ArrayList<String>();
Environment roadmap = new Environment();

float roadmapScale = 0.1f;
int numberOfHeuristics = 7;

int n1 = 0;
int n2 = 0;
int h1 = 0;
float recentF = 0;
int recentPathSize = 0;
int recentNodesInClosedSet = 0;
int recentNodesInOpenSet = 0;


int counter = 100;
ArrayList<Node> savedNodes = new ArrayList<Node>();
ArrayList<Node> testNodes = new ArrayList<Node>();

boolean testAllRoutes = false;
boolean testFewRoutes = true;
boolean resultsSaved = false;
boolean testByHeuristic = true;

public void setup() {
  size(600,800,P3D);
  fill(0);
  String[] lines = loadStrings("map.txt");
  edgeStrings = lines;
  roadmap.createEdges();
  


  if (testFewRoutes) {
    testNodes.add(roadmap.getNodes().get(0));
    // 1 - 5
    testNodes.add(roadmap.getNodes().get(701));
    testNodes.add(roadmap.getNodes().get(749));
    testNodes.add(roadmap.getNodes().get(776));
    testNodes.add(roadmap.getNodes().get(786));
    testNodes.add(roadmap.getNodes().get(850));
    // 6 - 10
    testNodes.add(roadmap.getNodes().get(875));
    testNodes.add(roadmap.getNodes().get(886));
    testNodes.add(roadmap.getNodes().get(900));
    testNodes.add(roadmap.getNodes().get(932));
    testNodes.add(roadmap.getNodes().get(12));
    // 11 - 15
    testNodes.add(roadmap.getNodes().get(64));
    testNodes.add(roadmap.getNodes().get(149));
    testNodes.add(roadmap.getNodes().get(174));
    testNodes.add(roadmap.getNodes().get(214));
    testNodes.add(roadmap.getNodes().get(100));
    // 16 - 20
    testNodes.add(roadmap.getNodes().get(201));
    testNodes.add(roadmap.getNodes().get(300));
    testNodes.add(roadmap.getNodes().get(400));
    testNodes.add(roadmap.getNodes().get(500));
    testNodes.add(roadmap.getNodes().get(600));
    
  }
  
}



public void draw() {
  lights();
  background(255);
  
  if (testAllRoutes) {
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
  
      perform_a_Star(n1,n2,1);
      n2++;
      counter = 0;
    } else {
      counter++;
    }
  } else if (testFewRoutes && testByHeuristic && h1 < numberOfHeuristics) {
    if (counter >= 1) {
      if (n1 == n2) {
        n2++;
      }
      if (n2 >= testNodes.size()) {
        n2 = 0;
        h1++;
        if (n1 == n2) {
          n2++;
        }
      }
      if (n1 >= testNodes.size()) {
        n1 = 0;
      }
      if (h1 < numberOfHeuristics) {
        perform_a_Star(testNodes.get(n1).getIndex(),testNodes.get(n2).getIndex(), h1);
      }
      n2++;
      counter = 0;
    } else {
      counter++;
    }
      
    } else if (testFewRoutes && !testByHeuristic && n2 < testNodes.size()) {
      if (counter >= 1) {
        if (n1 == n2) {
          n2++;
        }
        if (h1 >= numberOfHeuristics) {
          h1 = 0;
          n2++;
          if (n1 == n2) {
            n2++;
          }
        }
        if (n1 >= testNodes.size()) {
          n1 = 0;
        }
        if (n2 < testNodes.size()) {
          perform_a_Star(testNodes.get(n1).getIndex(),testNodes.get(n2).getIndex(), h1);
        }
        h1++;
        counter = 0;
      
      } else {
        counter++;
        //println("n1: " + n1 + ", n2: " + n2);
      }
  } else if (!resultsSaved) {
    if (testByHeuristic) {
      String[] resultStrings = new String[outputStrings.size()];
      for (int i = 0; i < outputStrings.size(); i++) {
        resultStrings[i] = outputStrings.get(i);
      }
      saveStrings("resultsByHeuristic.txt", resultStrings);
      
      /*
      int resultsCounter = 0;
      String[] resultStrings2 = new String[outputStrings.size()];
      for (int i = 0; i < testNodes.size()-1; i++) {
        for (int j = 0; j < h1; j++) {
          resultStrings2[resultsCounter] = outputStrings.get((testNodes.size()-1)*j + i);
          resultsCounter++;
        }
      }
      saveStrings("resultsByPath.txt", resultStrings2);
      */
    } else {
      String[] resultStrings = new String[outputStrings.size()];
      for (int i = 0; i < outputStrings.size(); i++) {
        resultStrings[i] = outputStrings.get(i);
      }
      saveStrings("resultsByPath.txt", resultStrings);
      
      /*
      int resultsCounter = 0;
      String[] resultStrings2 = new String[outputStrings.size()];
      for (int i = 0; i < testNodes.size()-1; i++) {
        for (int j = 0; j < h1; j++) {
          resultStrings2[resultsCounter] = outputStrings.get((testNodes.size()-1)*j + i);
          resultsCounter++;
        }
      }
      saveStrings("resultsByHeuristic.txt", resultStrings2);
      */
    }
    resultsSaved = true;
  }
  
  roadmap.drawEnvironment();
  text("Start : " + PApplet.parseInt(testNodes.get(n1).getIndex()) + ", Goal: " + PApplet.parseInt(testNodes.get(n2-1).getIndex()), width*0.1f, height*0.9f, 0);
  text("f(goal) : " + recentF + ", PathSize: " + PApplet.parseInt(recentPathSize), width*0.1f, height*0.92f, 0);
  text("NodesInClosedSet : " + PApplet.parseInt(recentNodesInClosedSet) + ", NodesInOpenSet : " + PApplet.parseInt(recentNodesInOpenSet), width*0.1f, height*0.94f, 0);
  String heuristicName = "";
  switch(h1-1) {
    case 0:  heuristicName = "Uniform Cost";
             break;
    case 1:  heuristicName = "Euclidean";
             break;
    case 2:  heuristicName = "2x Weighted Euclidean";
             break;
    case 3:  heuristicName = "Manhattan";
             break;
    case 4:  heuristicName = "2x Weighted Manhattan";
             break;
    case 5:  heuristicName = "Diagonal";
             break;
    case 6:  heuristicName = "2x Weighted Diagonal";
             break;
    default:  break;
  }
  text("Heuristic : " + heuristicName, width*0.1f, height*0.96f, 0);
}

int perform_a_Star(int start, int goal, int heuristic) {
  ArrayList<Edge> edges = roadmap.getEdges();
  ArrayList<Node> nodes = roadmap.getNodes();
  ArrayList<Node> shortestPath = a_Star(nodes, edges, start, goal, heuristic);
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
  switch(type) {
             // Uniform cost
    case 0:  return 0;
             // Euclidean
    case 1:  return (sqrt(pow(B.getX()-A.getX(),2) + pow(B.getY()-A.getY(),2)));
             // 2x Weighted Euclidean
    case 2:  return (sqrt(pow(B.getX()-A.getX(),2) + pow(B.getY()-A.getY(),2)))*2;
             // Manhattan
    case 3:  return (abs((B.getX() - A.getX())) + abs((B.getY() - A.getY())));
             // 2x Weighted Manhattan
    case 4:  return (abs((B.getX() - A.getX())) + abs((B.getY() - A.getY())))*2;
             // Diagonal
    case 5:  if (abs(B.getX() - A.getX()) > abs(B.getY() - A.getY())) {
               return abs(B.getX() - A.getX());
             } else {
               return abs(B.getY() - B.getY());
             }
             // 2x Weighted Diagonal
    case 6:  if (abs(B.getX() - A.getX())*2 > abs(B.getY() - A.getY())*2) {
               return abs(B.getX() - A.getX())*2;
             } else {
               return abs(B.getY() - B.getY())*2;
             }
    default:  return 0;
  }
}

ArrayList<Node> a_Star(ArrayList<Node> nodes, ArrayList<Edge> edges, int start, int goal, int heuristic) {
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
      fScore[i] = heuristic_cost_estimate(heuristic, nodes.get(i), nodes.get(goal)); // add heuristic
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
      //println("startIndex: " + start + ", goalIndex: " + goal + ", f: " + fScore[goal] + ", PathSize: " + total_path.size());
      recentF = fScore[goal];
      recentPathSize = total_path.size();
      recentNodesInClosedSet = closedSet.size();
      recentNodesInOpenSet = openSet.size();
      String heuristicName = "";
      switch(heuristic) {
        case 0:  heuristicName = "Uniform Cost";
                 break;
        case 1:  heuristicName = "Euclidean";
                 break;
        case 2:  heuristicName = "2x Weighted Euclidean";
                 break;
        case 3:  heuristicName = "Manhattan";
                 break;
        case 4:  heuristicName = "2x Weighted Manhattan";
                 break;
        case 5:  heuristicName = "Diagonal";
                 break;
        case 6:  heuristicName = "2x Weighted Diagonal";
                 break;
        default:  break;
      }
      String s = heuristicName + " " + start + " " + goal + " " + recentF + " " + recentPathSize + " " + recentNodesInClosedSet + " " + recentNodesInOpenSet;
      outputStrings.add(s);
      
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
            fScore[edges.get(i).getB().getIndex()] = gScore[edges.get(i).getB().getIndex()] + heuristic_cost_estimate(heuristic, edges.get(i).getB(), nodes.get(goal)); // heuristic
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
              fScore[edges.get(i).getA().getIndex()] = gScore[edges.get(i).getA().getIndex()] + heuristic_cost_estimate(heuristic, edges.get(i).getA(), nodes.get(goal)); // heuristic
            }
          }
        }
      }
    }
  }
  println("startIndex: " + start + ", goalIndex: " + goal + ", NULL");
  return null;
  
  
}
