
void preSetup(){
  colorMode(HSB);
  myFont = createFont("Courier New", 14);
  //startBX = width-(10+listBoxWidth);
  textFont(myFont);
  pfont = createFont("Arial",16,true); // use true/false for smooth/no-smooth
  largeFont = new ControlFont(pfont,241);
  cp5 = new ControlP5(this);
  portList = Serial.list();
  
}
void initialiseControls(){
  setupLog();
  //setupListBoxes(20, 100, 300);
  //setupConnectButtons(20, 50, 300);
  //setupSerialDisplay();
  setupSerialDisplays(20, 50, 250, 50, numberOfUnits); //Xpos, ypos, x step, y step, quantity
  setupCommandButtons();
  if(numberOfEnvironments > 1) setupDiadControls(800, 35, 50);
  setupParticipentDataEntry( 1050, 35, 80, numberOfUnits);
  //setupPracticeButtons();
  setupManual(20, 50, 250, 50, numberOfUnits); //Xpos, ypos, x step, y step, quantity
  int buttonPos = 140;
  int buttonSpacing = 60;
  //buttonPos = setupAnimationButton(10, buttonPos, buttonSpacing);
  buttonPos = setupMouseConButton(10, buttonPos, buttonSpacing);
  buttonPos = setupRandomButtons(10, buttonPos, 350, 40);
  buttonPos = 60;
  buttonPos = setupParameters(10, buttonPos, buttonSpacing);
  buttonPos = setupTiming(10, buttonPos, buttonSpacing);
  buttonPos = setupSetButton(10, buttonPos, buttonSpacing);
  buttonPos = setupMessages(400, 140, buttonSpacing*2);
  if(numberOfEnvironments > 1) setupMapCon( 400, 40);
}


//The main event handler - called for EVERY event
void controlEvent(ControlEvent theControlEvent) {
  if (theControlEvent.isTab()) {
    //println("got an event from tab : "+theControlEvent.getTab().getName()+" with id "+theControlEvent.getTab().getId());
  }
  serialEventHandler(theControlEvent);
  manualEventHandler(theControlEvent);
  if( numberOfEnvironments > 1 && theControlEvent.isFrom( cp5.getController( "gameMapping" ) ) ){
    Trial.setMapping((int) cp5.getController( "gameMapping" ).getValue());
    //User[n].portIndex = (int) cp5.getController( "gameMapping" ).getValue();
    //println("Game mapping set to: "+(int) cp5.getController( "gameMapping" ).getValue());
  }
}

//Check and handle events generated by the serial control UI
void serialEventHandler(ControlEvent aControlEvent){
  for(int n = 0; n < numberOfUnits; n++){
    if( aControlEvent.isFrom( cp5.getController( serialConnectID.get(n) ) ) ){
      //println("SerialHandler Connect: "+serialConnectID.get(n));
      if(cp5.getController( serialConnectID.get(n) ).getValue() == 0.0 ) User[n].disconnectPort();
      else User[n].connectPort(this);
    }
    if( aControlEvent.isFrom( cp5.getController( serialListID.get(n) ) ) ){
      //println("SerialHandler List: "+serialListID.get(n));
      User[n].portIndex = (int) cp5.getController( serialListID.get(n) ).getValue();
      println("Port Index of unit: "+serialListID.get(n) + " is " + User[n].portIndex);
    }
  }
}

//Check and handle events generated by the manual control UI
void manualEventHandler(ControlEvent aControlEvent){
  for(int n = 0; n < numberOfUnits; n++){
    if( aControlEvent.isFrom( cp5.getController( manualLEDID.get(n) ) ) ){
      println("Manual LED : "+manualLEDID.get(n));
      
       println("Value: " + cp5.getController( manualLEDID.get(n) ).getValue());
      if(cp5.getController( manualLEDID.get(n) ).getValue() == 1.0 ) User[n].sendLEDOn();
      else User[n].sendLEDOff();
    }
    if( aControlEvent.isFrom( cp5.getController( manualBeeperID.get(n) ) ) ){
      println("Manual Beep: "+manualBeeperID.get(n));
       println("Value: " + cp5.getController( manualBeeperID.get(n) ).getValue());
      if(cp5.getController( manualBeeperID.get(n) ).getValue() == 1.0 ) User[n].sendBeepOn();
      else User[n].sendBeepOff();
    }
    if( aControlEvent.isFrom( cp5.getController( manualVibID.get(n) ) ) ){
      println("Manual Vib: "+manualVibID.get(n));
       println("Value: " + cp5.getController( manualVibID.get(n) ).getValue());
      if(cp5.getController( manualVibID.get(n) ).getValue() == 1.0 ) User[n].setHaptics(1023, 1023);
      else User[n].setHaptics(0, 0);
    }
  }
}

void setupTabs(){
  
  cp5.addTab("Configuration")
     .setColorBackground(color(100))
     .setColorLabel(color(255))
     .setColorActive(color(0))
     ;
   cp5.addTab("Serial")
     .setColorBackground(color(100))
     .setColorLabel(color(255))
     .setColorActive(color(0))
     ;    
   cp5.addTab("Manual")
     .setColorBackground(color(100))
     .setColorLabel(color(255))
     .setColorActive(color(0))
     ; 
  // if you want to receive a controlEvent when
  // a  tab is clicked, use activeEvent(true)
  
  cp5.getTab("default")
     .activateEvent(true)
     .setColorBackground(color(100))
     .setColorLabel(color(255))
     .setColorActive(color(0))
     .setLabel("Trials")
     .setWidth(150)
     .setHeight((25))
     .setId(1)
     ;

  cp5.getTab("Configuration")
     .activateEvent(true)
     .setLabel("Settings")
     .setWidth(150)
     .setHeight((25))
     .setId(2)
     ;

  cp5.getTab("Serial")
     .activateEvent(true)
     .setLabel("Serial Ports")
     .setWidth(150)
     .setHeight((25))
     .setId(3)
     ;

  cp5.getTab("Manual")
     .activateEvent(true)
     .setLabel("Manual Control")
     .setWidth(150)
     .setHeight((25))
     .setId(4)
     ;

}
